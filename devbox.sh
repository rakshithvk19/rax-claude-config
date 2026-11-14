#!/bin/sh
set -eu

PATH="$PATH:/usr/sbin:/sbin"

here=$(cd "$(dirname "$0")" && pwd)
name=devbox
root="$here/data/$name"
suite=trixie
user=$(id -un)

usage() {
    cat >&2 <<-EOF
	usage: $0 <command>

	  build    install debian $suite into data/$name
	  shell    open a shell as $user inside the container
	  boot     boot the container to a login prompt
	EOF
    exit 1
}

fail() {
    echo "$1" >&2
    exit 1
}

find_elevator() {
    if command -v sudo >/dev/null
    then echo sudo
    elif command -v doas >/dev/null
    then echo doas
    else fail "neither sudo nor doas found"
    fi
}

as_root() {
    elevator=$(find_elevator)
    echo "+ $elevator $*" >&2
    "$elevator" "$@"
}

require_root() {
    if test ! -d "$root"
    then fail "no container at $root, run: $0 build"
    fi
}

nspawn() {
    require_root
    as_root env SYSTEMD_NSPAWN_API_VFS_WRITABLE=network\
        systemd-nspawn \
            --directory="$root" \
            --background= \
            --machine="$name" \
            --bind=/dev/net/tun \
            "$@"
}

build() (
    uid=$(id -u)
    subordinate_ids=100000-165535
    packages="systemd-sysv dbus ca-certificates curl doas git podman podman-compose uidmap tmux ripgrep"
    podman_config='[containers]
        keyring = false
        default_sysctls = []
        pidns = "host"
    '

    bootstrap() {
        if test -e "$root"
        then fail "container already exists at $root"
        fi
        as_root debootstrap "$suite" "$root"
    }

    install_packages() {
        nspawn apt-get update
        nspawn apt-get install --yes $packages
    }

    add_user() {
        nspawn useradd --create-home --shell /bin/bash --uid "$uid" "$user"
        nspawn usermod --add-subuids "$subordinate_ids" --add-subgids "$subordinate_ids" "$user"
        nspawn passwd --delete "$user"
        nspawn passwd --delete root
    }

    allow_doas() {
        nspawn sh -c "echo 'permit nopass $user' > /etc/doas.conf"
    }

    configure_podman() {
        nspawn sh -c "mkdir -p /etc/containers/containers.conf.d && printf '%s' '$podman_config' > /etc/containers/containers.conf.d/devbox.conf"
    }

    bootstrap
    install_packages
    add_user
    allow_doas
    configure_podman
)

shell() {
    nspawn --user="$user" --chdir="/home/$user" env -u NOTIFY_SOCKET bash --login
}

boot() {
    nspawn --boot
}

case "${1:-}" in
    build) build ;;
    shell) shell ;;
    boot) boot ;;
    *) usage ;;
esac

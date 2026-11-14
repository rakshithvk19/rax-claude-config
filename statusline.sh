#!/bin/bash
# Two-line status line for Claude Code
#
# Line 1: model, folder, git branch
# Line 2: context bar and percentage, session cost, duration, cache hits,
#         5-hour and 7-day plan usage
#
# Adapted from carback-claude-config/base/statusline.sh, without the
# transcript cost scan and the usage file that script publishes.
#
# Claude Code passes the session as JSON on stdin. The context percentage uses
# remaining_percentage, which counts the compaction reserve: 100% means
# compaction fires.

stdin_data=$(cat)

IFS=$'\t' read -r current_dir model_name cost duration_ms ctx_used cache_pct five_hour seven_day < <(
    echo "$stdin_data" | jq --raw-output '[
        .workspace.current_dir // .cwd // "unknown",
        .model.display_name // "Unknown",
        (try (.cost.total_cost_usd // 0 | . * 100 | floor / 100) catch 0),
        (.cost.total_duration_ms // 0),
        (try (
            if (.context_window.remaining_percentage // null) != null then
                100 - (.context_window.remaining_percentage | floor)
            elif (.context_window.context_window_size // 0) > 0 then
                (((.context_window.current_usage.input_tokens // 0) +
                  (.context_window.current_usage.cache_creation_input_tokens // 0) +
                  (.context_window.current_usage.cache_read_input_tokens // 0)) * 100 /
                 .context_window.context_window_size) | floor
            else "null" end
        ) catch "null"),
        (try (
            (.context_window.current_usage // {}) |
            if (.input_tokens // 0) + (.cache_read_input_tokens // 0) > 0 then
                ((.cache_read_input_tokens // 0) * 100 /
                 ((.input_tokens // 0) + (.cache_read_input_tokens // 0))) | floor
            else 0 end
        ) catch 0),
        (.rate_limits.five_hour.used_percentage // "null"),
        (.rate_limits.seven_day.used_percentage // "null")
    ] | @tsv' 2>/dev/null
)

: "${current_dir:=unknown}"
: "${model_name:=Unknown}"
: "${cost:=0}"
: "${duration_ms:=0}"
: "${ctx_used:=null}"
: "${cache_pct:=0}"

# Folder: the repo name at the repo root, otherwise the current folder's name
if cd "$current_dir" 2>/dev/null; then
    git_branch=$(git -c core.useBuiltinFSMonitor=false branch --show-current 2>/dev/null)
    git_root=$(git -c core.useBuiltinFSMonitor=false rev-parse --show-toplevel 2>/dev/null)
fi
if [ -n "$git_root" ] && [ "$current_dir" = "$git_root" ]; then
    folder_name=$(basename "$git_root")
else
    folder_name=$(basename "$current_dir")
fi

# Prints a bar of the given width: green under 50%, yellow under 80%, red above
bar() {
    local pct=$1 width=$2 filled color out i
    [ "$pct" -gt 100 ] && pct=100
    filled=$((pct * width / 100))
    if [ "$pct" -lt 50 ]; then
        color='\033[32m'
    elif [ "$pct" -lt 80 ]; then
        color='\033[33m'
    else
        color='\033[31m'
    fi
    out="$color"
    for ((i = 0; i < filled; i++)); do out="${out}█"; done
    out="${out}\033[2m"
    for ((i = filled; i < width; i++)); do out="${out}⣿"; done
    printf '%s\\033[0m' "$out"
}

# Session time, human-readable
session_time=""
if [ "$duration_ms" -gt 0 ] 2>/dev/null; then
    total_sec=$((duration_ms / 1000))
    hours=$((total_sec / 3600))
    minutes=$(((total_sec % 3600) / 60))
    seconds=$((total_sec % 60))
    if [ "$hours" -gt 0 ]; then
        session_time="${hours}h ${minutes}m"
    elif [ "$minutes" -gt 0 ]; then
        session_time="${minutes}m ${seconds}s"
    else
        session_time="${seconds}s"
    fi
fi

SEP='\033[2m│\033[0m'
short_model=$(echo "$model_name" | sed --regexp-extended 's/Claude [0-9.]+ //; s/^Claude //')

# Line 1: [model] folder │ branch
line1="\033[37m[${short_model}]\033[0m \033[94m📁 ${folder_name}\033[0m"
if [ -n "$git_branch" ]; then
    line1="${line1} ${SEP} \033[96m🌿 ${git_branch}\033[0m"
fi

# Line 2: context bar and % │ cost │ duration, cache hits │ plan usage
line2=""
if [ "$ctx_used" != "null" ] && [ "$ctx_used" -ge 0 ] 2>/dev/null; then
    line2="$(bar "$ctx_used" 12) \033[37m${ctx_used}%\033[0m ${SEP} "
fi
line2="${line2}\033[33m\$${cost}\033[0m"
if [ -n "$session_time" ]; then
    line2="${line2} ${SEP} \033[36m⏱ ${session_time}\033[0m"
fi
if [ "$cache_pct" -gt 0 ] 2>/dev/null; then
    line2="${line2} \033[2m↻${cache_pct}%\033[0m"
fi
for window in "5h:${five_hour}" "7d:${seven_day}"; do
    label=${window%%:*}
    pct=${window#*:}
    pct=${pct%.*}
    [ -n "$pct" ] && [ "$pct" != "null" ] || continue
    line2="${line2} ${SEP} \033[2m${label}\033[0m $(bar "$pct" 6) \033[37m${pct}%\033[0m"
done

printf '%b\n%b' "$line1" "$line2"

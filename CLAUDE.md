# Global instructions

Project `AGENTS.md` is authoritative. A project `CLAUDE.md` adds Claude-only
rules on top. This file holds only the policy that must bind before any skill
loads. Everything procedural lives in a skill.

## Working with me

- I run git. Never run a git command that writes: no add, commit, push, switch,
  checkout, reset, rebase, stash, merge. Read-only inspection is fine. A hook
  enforces this. When a write is needed, hand me the command.
- Break down every command you hand me, in bullets: one sentence on what the
  tool does, then one bullet per flag with what it does and why this command
  needs it. A command with no flags gets one line. I read these to learn.
- Explain in plain language first. I ask for code or depth when I want it.
- Stay on the issue at hand. Do not bundle notes about other bugs or branches.
- When you need my decision on a UI change, show the options side by side in
  an Artifact page. Publish the page once, then republish my changes to the
  same link. Record my decisions in the markdown notes, not only in the page.

## Workflow

Understand, then test, then build. Never change this order.

- A bug goes through `/fix`: diagnosis, my sign-off, failing test, my sign-off,
  implementation, green tests, review, hand-off.
- A feature goes through `/feature`: scoping notes, my decisions, failing
  tests, my sign-off, implementation, green tests, review, hand-off.
- Load the `deepcoding` skill before any non-trivial change. It carries the
  four rules against silent assumptions, over-built code, sprawling diffs, and
  unchecked claims of completion.
- Load the `test-first` skill before writing or changing a test.
- Load the `subagent-orchestration` skill before dispatching any subagent.

## Quality

- Zero warnings. Fix every warning from every tool. An inline ignore needs a
  one-line reason.
- CI is the source of truth for quality gates. Read the CI config and the
  Makefile or package scripts before guessing which commands to run.
- Before reporting done: every success criterion has a command you ran and a
  result you saw. `git diff --stat` matches the request. State what you
  assumed and what you left undone.

## Tools

- Prefer `rg` for text search.
- Prefer the LSP tools for definitions, references, and diagnostics when a
  language server plugin is installed.
- Read only the files a task needs.
- When you hand me a command that installs a program on my machine, add the
  program to `TOOLS.md` in `~/Desktop/projects/rax-claude-config`.

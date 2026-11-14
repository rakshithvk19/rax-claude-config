---
name: deepcoding
description: "Use before any non-trivial change, and when building from a written design, plan, spec or brief. Four rules against the four ways coding work goes wrong: silent assumptions, over-built code, sprawling diffs, and unchecked claims of completion. Not for typo fixes, one-line edits, or config value changes."
---

# Deep coding

Four rules that counter the four ways coding work goes wrong: silent
assumptions, over-built code, sprawling diffs, and unchecked claims of
completion.

Apply all four to any non-trivial change. For a typo or an obvious one-liner,
use judgment. These rules trade speed for a smaller and safer diff, and that
trade is a loss on trivial work.

## Think before coding (rule 1)

State your assumptions. Do not hide confusion.

- Write down the reading you chose before you build on it.
- If a simpler approach exists, say so before you build the complex one.
- If two readings of the request lead to materially different work, present
  both. Do not pick one without saying so.
- If something is unclear, name what is unclear.

A reader can see which decisions you made and why, without reading the diff.

## Simplicity first (rule 2)

Write the least code that solves the problem. Nothing speculative.

- No features beyond what the request asked for.
- No abstraction for code with one caller.
- No configurability or extension point that nobody asked for.
- No error handling for conditions that cannot occur.
- If the result runs 200 lines and 50 would do, write the 50.

Ask whether a senior engineer would call the result over-built. If yes, cut it.

## Surgical changes (rule 3)

Change only what the task requires. Clean up only what you disturbed.

- Do not improve adjacent code, comments, or formatting.
- Do not refactor code that works.
- Match the style already in the file, even when you prefer another style.
- Remove the imports, variables, and functions that **your** change orphaned.
- Flag pre-existing dead code. Do not delete it unless asked.
- Do not quietly do less, either. Scaling scope down is the user's call.

Every changed line traces to the request, and every part of the request gets a
changed line or a stated reason it did not.

## Goal-driven execution (rule 4)

Define success criteria first, then loop until they pass.

| Instead of | Build toward |
|---|---|
| Add validation | Tests for invalid input, then make them pass |
| Fix the bug | A test that reproduces it, then make it pass |
| Refactor X | The same tests pass before and after |

For multi-step work, state the plan as steps paired with checks:

```text
1. [step] -> verify: [check]
2. [step] -> verify: [check]
```

Strong criteria let you work without interruption. Weak criteria such as "make
it work" force a round trip for every decision.

## House deviations

These override the plain reading of the four rules. Do not "correct" them
back.

**Decide, do not stall.** Rule 1 says to surface uncertainty. The house rule is
bias toward action. Sort the uncertainty first:

| Uncertainty | Action |
|---|---|
| Easy to reverse: naming, file layout, internal helper, test shape | Decide, state the assumption in one line, keep going |
| Hard to reverse: public interface, data model, schema, architecture, new dependency | Ask before you build |
| External writes or destructive operations | Ask, always |
| Two readings, materially different work | Present both, do not pick one alone |

Blocking on a question is correct only when any assumption makes the work
unsafe or useless if wrong. In a subagent, nobody can answer mid-run: "ask"
means record the question under **Needs decision** in your report.

**Style matching stops at warnings.** Rule 3 says to match existing style. It
never permits a new lint, type, or compiler warning. The zero warnings policy
wins. Leave pre-existing warnings on lines you did not change, and flag them.

**Replacement is in scope, drive-by deletion is not.** Rule 3 forbids deleting
pre-existing dead code. It does not protect the code your change replaces.
When your change supersedes old code, remove that old code whole. Do not leave
a shim, a dual code path, or a migration layer.

**Tests come from the `test-first` skill.** Rule 4 sets the shape of the goal.
For the failing test, the order of work and how to run tests, load the
`test-first` skill.

## Building from a design

When a written plan or design drives the work:

1. The plan defines the criteria. Its verify steps are rule 4. Do not invent
   extra acceptance criteria.
2. The current step defines the scope. Work outside that step counts as rule 3
   sprawl, even when a later step needs it.
3. Raise plan defects before you start, not halfway through. A plan that
   contradicts itself is a rule 1 confusion, so name it.
4. Report each step against its own check. "Done" without the check is a
   claim, not a result.

## Before you report done

- Every criterion has a run command and a result you saw.
- The `git diff --stat` scope matches the request.
- No new warnings from any linter, type checker, or compiler.
- You stated your assumptions and anything you left undone.

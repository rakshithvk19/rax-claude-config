---
name: subagent-orchestration
description: Use before dispatching any subagent. Covers which agent does which job, what a brief must contain, when agents may run in parallel, and how to collect and relay an agent's report.
---

# Subagent orchestration

## Which agent does which job

| Job | Agent | What the agent writes |
|---|---|---|
| Scope a feature or a ticket | architect | `ignored/feature-<slug>.md`, plus one Artifact page for UI architecture decisions |
| Diagnose a bug | investigator | `ignored/diagnosis-<slug>.md` |
| Write the failing tests, then the code | developer | Tests in the tests stage, production code in the build stage |
| Run scoped tests and report only the failures | tester | Nothing |
| Review a code diff before a commit | code-reviewer | Nothing |
| Write or update a convention page in `doc/` | docs-writer | Pages in `doc/` |
| Fact-check a `doc/` page or an `ignored/` note against the code | docs-reviewer | Nothing |

- `/fix` and `/feature` run these agents in a fixed order. Follow the command and never reorder its steps.
- Each agent's file sets the agent's model. Don't override the model unless I ask.

## Writing the brief

The brief is the only context the agent gets. Every brief names:

- the goal, in one or two sentences
- where to start: the files, the build-plan step or the note in `ignored/`
- what is already ruled out, so the agent doesn't redo the work
- the scope: what to leave alone
- for the developer agent: the stage, `tests` or `build`, and for the build stage, that I have signed off the tests

Paste the unattended contract into every brief:

> You run unattended. Nobody answers questions or approval prompts, and a hook
> denies every prompt you raise. Don't retry a denied call or look for another
> route to the same action. Put every question and every denied call under
> **Needs decision** in your report, and carry on with the work that doesn't
> depend on it.

When you want an independent check, such as a review, give the agent the code, not your conclusion. An agent handed a conclusion tends to confirm it.

## Parallel or sequential

- Run agents in parallel only when no agent needs another agent's output and no two agents write the same files.
  - Example: the code-reviewer agent and the docs-reviewer agent on the same change.
  - Example: two investigator agents on two unrelated bugs.
- Never run two developer agents in the same checkout at once.
- The steps of `/fix` and `/feature` are sequential: each step needs the previous step's result and my sign-off.

## Collecting the result

- A dispatched agent is not finished work. Don't end your turn while an agent you started is still running.
- When an agent writes a file, such as the architect agent or the investigator agent, read the file before deciding the agent failed. A file on disk means the work finished and only the message dropped.
- I never see an agent's report. Relay what matters: the result, **Not done** and **Needs decision**.
- Check an agent's claims before passing them on.
  - A test result needs the command and the output.
  - A review finding needs the line the finding points at.
- Carry the code-reviewer agent's labels over unchanged, such as P1.1, in the reviewer's order.
- Fix nothing that an agent hands back as a decision. Put the decision to me.

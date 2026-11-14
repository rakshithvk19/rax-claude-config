---
description: Fix a bug in order. Diagnosis, my sign-off, failing test, my sign-off, the fix, green tests, review, hand-off.
argument-hint: <what is broken, or the ticket ID>
---

# Fix

The bug: $ARGUMENTS

Run the steps in order. Never skip a step or merge two steps. Load the
`subagent-orchestration` skill before the first dispatch. At each sign-off,
present the result, then stop and wait for my "go".

1. **Diagnose.** Dispatch the investigator agent with the bug. The investigator
   writes `ignored/diagnosis-<slug>.md`.
   - Relay the cause, the evidence and the recovery, in plain language.
2. **Sign-off: the diagnosis.** Stop. I confirm the cause or send you back to
   step 1.
3. **Failing test.** Dispatch the developer agent for the tests stage, with the
   diagnosis as the brief. The developer writes a regression test that
   reproduces the bug, then stops.
   - Relay each new test and the failure, word for word.
4. **Sign-off: the failing test.** Stop. I confirm the test fails for the right
   reason.
5. **Fix.** Dispatch the developer agent for the build stage. The brief says I
   have signed off the tests.
6. **Green tests.** Dispatch the tester agent on the signed-off tests and the
   tests next to the changed code.
   - A failure goes back to step 5. Never edit a signed-off test.
7. **Review.** Dispatch the code-reviewer agent on the diff.
   - Relay every finding with the reviewer's label. Fix nothing until I say go.
8. **Hand-off.** Report:
   - the cause, in one sentence
   - each changed file, with one line on what changed
   - each test command you ran and the result you saw
   - the review verdict
   - a commit message, and the git commands for me to run

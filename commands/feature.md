---
description: Build a feature in order. Scoping notes, my decisions, failing tests, my sign-off, the code, green tests, review, hand-off.
argument-hint: <the feature, or the ticket ID>
---

# Feature

The feature: $ARGUMENTS

Run the steps in order. Never skip a step or merge two steps. Load the
`subagent-orchestration` skill before the first dispatch. At each sign-off,
present the result, then stop and wait for my "go".

1. **Scope.** Dispatch the architect agent with the feature. The architect
   writes `ignored/feature-<slug>.md`.
   - Relay what the feature is, the blocker if there is one, and each decision
     in section 4 of the notes.
2. **Sign-off: my decisions.** Stop. I answer each decision. Record my answers
   in the notes before going on.
3. **Failing tests.** Dispatch the developer agent for the tests stage, with
   the notes and my decisions as the brief.
   - Relay each new test and the failure, word for word.
4. **Sign-off: the failing tests.** Stop. I confirm each test fails for the
   right reason.
5. **Build.** Dispatch the developer agent for the build stage. The brief says I
   have signed off the tests.
6. **Green tests.** Dispatch the tester agent on the signed-off tests and the
   tests next to the changed code.
   - A failure goes back to step 5. Never edit a signed-off test.
7. **Review.** Dispatch the code-reviewer agent on the diff.
   - Relay every finding with the reviewer's label. Fix nothing until I say go.
8. **Hand-off.** Report:
   - what the feature does, in one sentence
   - each changed file, with one line on what changed
   - each test command you ran and the result you saw
   - the review verdict
   - a commit message, and the git commands for me to run

When the notes split the feature into several build steps, run steps 3 to 7
once per build step, then hand off once at the end.

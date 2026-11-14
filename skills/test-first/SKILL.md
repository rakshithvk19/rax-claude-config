---
name: test-first
description: Use before writing or changing a test, and before fixing a bug. Covers writing the failing test first, proving the test fails for the right reason, testing through the public entry point, fakes instead of module mocks, and running tests narrowly. Not for running an existing suite to check a change, which is the tester agent's job.
---

# Test first

When the project's docs give testing conventions, follow those where they
differ from this skill.

1. Write the failing test before the code
   - A bug fix starts with a regression test that reproduces the bug
   - A new behaviour starts with a test for that behaviour
   - Change no production code until the test exists and fails

2. Prove the test fails for the right reason
   - Run the new test and read the failure
   - The failure must be an assertion about the missing behaviour
     - Not an import error, a typo, a missing fixture or a timeout
   - Quote the failure word for word when you report the test
   - In `/fix` and `/feature`, stop here: I sign off the failing tests before any production code changes

3. Test behaviour through the public entry point
   - Call the code the way the code's callers do, and assert on what a caller can see
   - Never assert on private functions, internal state or the shape of the source files
   - User-facing behaviour gets an end-to-end test where the project has end-to-end tests, not only a unit test

4. Use fakes, never module mocks
   - Never replace an import to test a unit: no `mock.module`, `jest.mock`, `vi.mock` or the like
   - A unit that can only be tested by replacing an import is missing an injection seam
     - Add the seam with no change in behaviour, say so, and pass a fake through the seam
   - Fake only the edges: network, clock, storage, randomness and other external services

5. Never weaken a signed-off test
   - Never edit a signed-off test to make the test pass
   - Never drop or loosen an assertion
   - When a signed-off test looks wrong, stop and record the problem under **Needs decision**

6. Name tests after the feature
   - Follow item 9 of the naming rule: spec files and `describe` blocks use the user's words for the feature

7. Run tests narrowly
   - Find the project's test command in the CI config or the package scripts before guessing
   - Run only the test files you wrote or changed, plus the tests next to the code you changed
   - Report each run with the command and the result you saw

---
description: "TDD Agent Team implementation — Test Agent writes tests first, Dev Agent implements until tests pass, Leader orchestrates all tasks"
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Overview

This command implements tasks.md using a **TDD Agent Team** pattern that follows the
classic **Red → Green → Refactor** cycle:

- **Leader (you)**: Orchestrates the workflow, tracks progress, makes decisions
- **Test Agent (Red)**: Writes failing tests first for each user story (contract tests + unit tests)
- **Dev Agent (Green)**: Implements the minimum code to make tests pass
- **Refactor Agent (Refactor)**: Improves the design while keeping every test green
- **Verification**: Leader runs tests after each Dev Agent and after each Refactor Agent

## Execution Protocol

### Phase 0: Load Context

1. Run `.specify/scripts/bash/check-prerequisites.sh --json --require-tasks --include-tasks` from repo root and parse FEATURE_DIR and AVAILABLE_DOCS list.

2. Check checklists status (same as speckit.implement — skip if all pass).

3. Load all design docs:
   - **REQUIRED**: tasks.md, plan.md
   - **IF EXISTS**: data-model.md, contracts/, research.md, quickstart.md

4. Parse tasks.md and extract:
   - All phases and their tasks
   - Which tasks are test tasks (IDs containing "test" or "contract" or task description mentions "test"/"contract test"/"unit test")
   - Which tasks are implementation tasks
   - Which tasks are setup/infrastructure tasks
   - Dependency relationships between phases

5. Build a **Story Execution Plan** — group tasks by User Story:

   ```
   Phase 1 (Setup): T001-T007 → Leader executes directly (small infra tasks)
   Phase 2 (Foundational): T008-T015 → Leader executes directly (schemas, deps, routing)
   Phase 3 (US1):
     Test Tasks: T016, T017 → Test Agent (RED)
     Impl Tasks: T018-T025 → Dev Agent (GREEN)
     Verify: run pytest → Leader
     Refactor: improve design, tests stay green → Refactor Agent
   Phase 4 (US2):
     Test Tasks: T026, T027 → Test Agent (RED)
     Impl Tasks: T028-T030 → Dev Agent (GREEN)
     Verify: run pytest → Leader
     Refactor: improve design, tests stay green → Refactor Agent
   ...
   Phase N (Polish): → Leader executes directly
   ```

### Phase 1-2: Setup & Foundational (Leader Direct)

Leader executes setup and foundational tasks **directly** (no agents needed for small infra tasks like creating models, schemas, routes):

- Execute each task sequentially
- Parallel tasks [P] can be done together
- Mark completed tasks as [x] in tasks.md
- **Checkpoint**: Verify all foundational pieces compile/import correctly

### Phase 3+: User Story Phases (Agent Team TDD Loop)

For **each User Story phase**, execute this loop:

#### Step 1: Test Agent — RED (write failing tests first)

Launch an Agent with this prompt pattern:

```
You are the TEST AGENT for a TDD workflow. Your ONLY job is to write tests.

CONTEXT:
- Feature: [feature name from plan.md]
- Tech stack: [from plan.md]
- User Story: [story description from tasks.md]

DESIGN DOCS (paste relevant sections):
- Data Model: [relevant entities from data-model.md]
- API Contracts: [relevant contracts from contracts/]
- Quickstart scenarios: [relevant scenarios from quickstart.md]

TASKS TO COMPLETE:
[List the test tasks for this story, e.g.:]
- T016: Contract test for POST/GET/PUT/DELETE /projects in backend/tests/contract/test_projects_contract.py
- T017: Unit test for project_service in backend/tests/unit/test_project_service.py

RULES:
1. Write ONLY test files — do NOT implement any production code
2. Tests should follow existing test patterns in the project (check conftest.py and any existing tests)
3. Tests MUST be comprehensive: happy path, error cases, edge cases, permission checks
4. Each test should be independently runnable
5. Use descriptive test names that document expected behavior
6. Tests should initially FAIL (no implementation exists yet) — this is expected and correct
7. Import from the production code paths that WILL exist (per the task descriptions)
8. Return the list of files you created and the test count
```

Wait for Test Agent to complete. Record which test files were created.

#### Step 2: Verify RED (Leader)

- Confirm test files were created at the expected paths
- **Run the tests and confirm they FAIL** — this is the RED gate. Tests must fail for the
  right reason (missing implementation), not for setup/import/syntax errors.
- If tests pass or error out before any implementation exists, send them back to the Test
  Agent — a test that passes with no implementation is not a valid test.
- Mark test tasks as [x] in tasks.md

#### Step 3: Dev Agent — GREEN (implement to pass tests)

Launch an Agent with this prompt pattern:

```
You are the DEV AGENT for a TDD workflow. Your job is to write production code that makes existing tests pass.

CONTEXT:
- Feature: [feature name]
- Tech stack: [from plan.md]
- User Story: [story description]

DESIGN DOCS:
- Data Model: [relevant entities]
- API Contracts: [relevant contracts]
- Existing code patterns: [reference existing services, routes, models in the project]

TEST FILES ALREADY WRITTEN (you must make these pass):
[List the test files the Test Agent created]

TASKS TO COMPLETE:
[List the implementation tasks for this story, e.g.:]
- T018: Implement project_service.create_project() in backend/app/services/project_service.py
- T019: Implement project_service.list_projects() in backend/app/services/project_service.py
- ...
- T024: Create project list page in frontend/src/pages/Projects/index.tsx

RULES:
1. Your PRIMARY goal is making the test files pass — this is the GREEN phase, NOT the
   cleanup phase. Prefer the simplest code that passes; a dedicated Refactor Agent will
   improve the design afterwards, so do NOT over-engineer or prematurely abstract here.
2. Follow existing code patterns in the project (check existing services, models, routes)
3. Do NOT modify any test files
4. Implement the minimum code needed to pass tests + fulfill the task descriptions
5. For frontend tasks (no backend tests), follow the UI contracts and existing component patterns
6. Return the list of files you created/modified
```

Wait for Dev Agent to complete.

#### Step 4: Verify GREEN — Run Tests (Leader Verification)

Leader runs the test suite:

```bash
# Run only the tests for this user story
pytest tests/contract/test_<story>_contract.py tests/unit/test_<story>_service.py -v --tb=short
```

**If tests PASS:**
- Mark all implementation tasks as [x] in tasks.md
- Report: "✅ US{N} GREEN — {X} tests passed"
- Proceed to Step 5 (Refactor) — do NOT skip straight to the next User Story

**If tests FAIL:**
- Analyze the failure output
- Launch Dev Agent again with the error context:

```
You are the DEV AGENT. Some tests are failing after your previous implementation.

FAILING TESTS:
[paste pytest output with failures]

FILES YOU PREVIOUSLY CREATED/MODIFIED:
[list files]

Fix the implementation to make all tests pass. Do NOT modify test files.
```

- Re-run tests after fix
- Retry up to 3 times. If still failing after 3 retries:
  - Report the failures to the user
  - Ask whether to continue to next story or stop

#### Step 5: Refactor Agent — REFACTOR (improve design while green)

Now that the story is GREEN, improve the code's internal quality **without changing behavior**.
This is the third leg of Red → Green → Refactor and is what separates real TDD from
"test-first batch coding".

Launch an Agent with this prompt pattern:

```
You are the REFACTOR AGENT for a TDD workflow. All tests for this user story currently PASS.
Your job is to improve the internal quality of the production code WITHOUT changing its behavior.

CONTEXT:
- Feature: [feature name]
- User Story: [story description]

FILES THE DEV AGENT CREATED/MODIFIED (refactor scope):
[List the production files from Step 3 — do NOT touch other stories' code]

PASSING TESTS (your safety net — they MUST stay green):
[List the test files for this story]

RULES:
1. Do NOT modify any test files and do NOT change observable behavior
2. Do NOT add new features or new test cases — refactor only
3. Target real code smells: duplication, poor names, long functions, leaky abstractions,
   dead code, inconsistent patterns vs. the rest of the project
4. Make small, behavior-preserving changes; keep the code idiomatic to the project
5. If the code is already clean, say so and change nothing — do NOT refactor for its own sake
6. Return the list of files you changed and a one-line summary of each refactor
```

Wait for Refactor Agent to complete, then **re-run the story's tests** to confirm they are
still green. If the refactor broke a test, treat it like a GREEN failure: send the Refactor
Agent the failing output to fix (it must restore green without modifying tests), retry up to
2 times, and if still red, revert the refactor and keep the last known-green implementation.

#### Step 6: Integration Check (Leader)

After the story is GREEN and refactored:
- Run the FULL test suite (not just this story) to check for regressions
- If regressions found, launch Dev Agent to fix
- Report: "✅ US{N} complete — {X} tests passed, refactored"

### Final Phase: Polish (Leader Direct)

Execute polish tasks directly:
- Seed data, audit log verification, Docker build, README updates
- Run full test suite one final time
- Report completion summary

## Agent Prompt Guidelines

### For Test Agent prompts, ALWAYS include:
1. The full conftest.py content (fixtures, DB setup)
2. Relevant Pydantic schemas (request/response models)
3. Relevant API contracts from contracts/
4. Existing test patterns from the project
5. The exact file paths where tests should be written

### For Dev Agent prompts, ALWAYS include:
1. The test files content (so it knows what to make pass)
2. Existing service/model patterns from the project
3. The schemas and dependencies already created in foundational phase
4. The exact file paths from task descriptions

### For Refactor Agent prompts, ALWAYS include:
1. The exact list of production files the Dev Agent created/modified (refactor scope)
2. The passing test files for this story (the safety net that must stay green)
3. Relevant project conventions/patterns so refactors stay idiomatic
4. An explicit reminder: behavior-preserving only, no test edits, no new features

### Context Management:
- Each agent gets ONLY the context it needs (minimize prompt size)
- Include file contents inline rather than asking agents to read files
- Paste relevant existing code patterns so agents maintain consistency

## Progress Tracking

After each User Story completes, output a progress table:

```
| Phase      | Story | Tests (Red) | Impl (Green) | Refactor | Status  |
|------------|-------|-------------|--------------|----------|---------|
| Setup      | -     | -           | 7/7          | -        | ✅ Done |
| Foundation | -     | -           | 8/8          | -        | ✅ Done |
| US1        | P1    | 2/2         | 8/8          | ✅       | ✅ Done |
| US2        | P1    | 2/2         | 3/3          | ✅       | ✅ Done |
| US3        | P2    | 0/2         | 0/3          | ⬜       | ⏳ Next |
| US4        | P2    | -           | 0/3          | ⬜       | ⬜ Wait |
| US5        | P3    | -           | 0/3          | ⬜       | ⬜ Wait |
| Polish     | -     | -           | 0/5          | -        | ⬜ Wait |
```

## Error Recovery

- **Test Agent fails**: Retry once with more context. If still fails, Leader writes tests directly.
- **Tests pass before any implementation (invalid RED)**: Send back to Test Agent — the test
  isn't exercising the new behavior.
- **Dev Agent fails 3 times**: Stop, report to user with detailed error context.
- **Refactor breaks tests**: Retry Refactor Agent up to 2 times with the failing output; if
  still red, revert the refactor and keep the last known-green implementation.
- **Regression detected**: Launch targeted Dev Agent with regression test output.
- **Context too large**: Split User Story into sub-batches (backend first, then frontend).

## Key Differences from speckit.implement

| Aspect | speckit.implement | speckit.tdd-implement |
|--------|-------------------|----------------------|
| Cycle | Build then test | Red → Green → Refactor per story |
| Test writing | Mixed with implementation | Dedicated Test Agent, failing tests first |
| Implementation | Sequential single-threaded | Dev Agent writes minimum code to pass tests |
| Refactoring | Ad hoc / none | Dedicated Refactor Agent while tests stay green |
| Verification | Manual/end-of-phase | Automated after Green and after Refactor |
| Error recovery | Halt on failure | Retry loop with error context |
| Context management | Single large context | Scoped context per agent |

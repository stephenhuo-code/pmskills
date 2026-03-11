---
description: "Analyze recent changes, generate a commit message, and commit to git"
---

## User Input

```text
$ARGUMENTS
```

## Instructions

You are a git commit assistant. Analyze the current working tree changes and generate a well-structured commit message, then commit.

### Step 1: Gather Context

Run the following commands in parallel to understand the changes:

1. `git status` — see all modified, staged, and untracked files
2. `git diff --stat` — summary of staged + unstaged changes
3. `git diff` — full diff of modified tracked files
4. `git diff --cached --stat` — already staged changes (if any)
5. `git log --oneline -5` — recent commit style reference

For untracked files, read key new files to understand their purpose (skip large generated files, lock files, etc.).

### Step 2: Analyze Changes

Categorize the changes:

- **feat**: New feature or capability
- **fix**: Bug fix
- **refactor**: Code restructuring without behavior change
- **docs**: Documentation only
- **test**: Adding or updating tests
- **chore**: Build, config, tooling changes
- **style**: Formatting, whitespace, no logic change
- **perf**: Performance improvement

If changes span multiple categories, use the primary one for the prefix. If changes are large and logically separable, suggest splitting into multiple commits and ask the user.

### Step 3: Generate Commit Message

Format:

```
<type>: <concise summary in imperative mood, max 72 chars>

<optional body: explain WHAT changed and WHY, not HOW>
<bullet points for multiple logical changes>

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
```

Rules:
- Summary line: imperative mood ("add", "fix", "refactor"), not past tense
- Summary line: max 72 characters, lowercase after prefix
- Body: wrap at 72 characters
- If user provided input in $ARGUMENTS, incorporate it into the message
- Match the language style of recent commits (Chinese/English)
- Do NOT include file lists in the commit message — git tracks that

### Step 4: Stage and Commit

1. Stage relevant files using `git add <specific files>` — prefer explicit file paths over `git add -A`
   - Do NOT stage files that look like secrets (`.env`, credentials, keys)
   - Do NOT stage large binary files unless they are clearly intentional
   - If unsure about a file, ask the user
2. Show the user the proposed commit message and list of files to be staged
3. Wait for user confirmation (unless $ARGUMENTS contains "auto" or "--no-confirm")
4. Create the commit using a HEREDOC for the message
5. Run `git status` after commit to verify success

### Step 5: Report

Show:
- Commit hash (short)
- Files committed count
- Branch name

### Special Flags (via $ARGUMENTS)

- `auto` or `--no-confirm`: Skip confirmation, commit directly
- `--amend`: Amend the previous commit instead of creating new one
- `--scope <scope>`: Only include changes matching the scope (e.g., `--scope backend`)
- Any other text: Use as hint/context for the commit message

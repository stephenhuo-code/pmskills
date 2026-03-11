# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

This is a **dotfiles repository** for managing shared Claude Code configuration across environments. It contains reusable Claude Code commands, skills, and settings that are symlinked into `~/.claude/` via `install.sh`.

## Architecture

```
dotfiles/
├── install.sh              # Deployment script — symlinks config into ~/.claude/
├── claude/
│   ├── CLAUDE.md           # Global Claude Code instructions (symlinked to ~/.claude/CLAUDE.md)
│   ├── claude.json         # Claude Code settings (symlinked to ~/.claude/claude.json)
│   ├── commands/           # Slash commands (symlinked to ~/.claude/commands/)
│   │   ├── commit.md       # /commit — structured git commit workflow
│   │   └── speckit.tdd-implement.md  # /speckit.tdd-implement — TDD agent team orchestration
│   └── skills/
│       └── drawio-skill/   # Draw.io diagram generation skill
```

## Deployment

```bash
bash install.sh
```

This creates symlinks from `~/.claude/` → this repo, so editing files here updates all environments.

## Conventions

- Commands use frontmatter (`---` blocks) for metadata (description, etc.)
- Commit messages follow conventional commits format: `<type>: <summary>` (feat, fix, refactor, docs, test, chore, style, perf)
- Commit messages may be in Chinese or English — match the style of recent commits in the target repo
- All commits include `Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>`

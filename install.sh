#!/bin/bash
# ~/dotfiles/install.sh

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p ~/.claude/commands

# 符号链接 —— 改仓库里的文件，所有环境实时同步
ln -sf "$DOTFILES_DIR/claude/CLAUDE.md" ~/.claude/CLAUDE.md
ln -sf "$DOTFILES_DIR/claude/commands" ~/.claude/commands
ln -sf "$DOTFILES_DIR/claude/claude.json" ~/.claude/claude.json

echo "✅ Claude Code 配置已部署"

#!/usr/bin/env bash
# claude-eng-kit 自带的独立安装脚本(不依赖、不修改 dotfiles/install.sh)。
# 作用:把 writing-specs 技能软链进全局 ~/.claude/skills/,使其对所有项目可用。
# 路径自解析:把整个 claude-eng-kit/ 拆到任何位置后,本脚本仍可用。
set -euo pipefail

KIT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$HOME/.claude/skills"
SRC="$KIT/skills/writing-specs"
DST="$SKILLS_DIR/writing-specs"

[ -f "$SRC/SKILL.md" ] || { echo "✗ 找不到 $SRC/SKILL.md(套件结构异常)"; exit 1; }

mkdir -p "$SKILLS_DIR"
ln -sfn "$SRC" "$DST"     # 幂等;-n 避免在已有软链目录内再嵌套

echo "✓ writing-specs 已软链:$DST -> $(readlink "$DST")"
echo
echo "依赖:本套件复用 superpowers(writing-plans / executing-plans / brainstorming / requesting-code-review)。"
echo "      未装 superpowers 时,writing-specs 仍可单独产出 spec/design;完整流程建议装 superpowers。"
echo
echo "新项目接入:"
echo "  cp \"$KIT/templates/constitution.template.md\" <项目>/docs/constitution.md   # 填空,DoR 行引用全局技能"
echo "  流程参考:$KIT/playbook/ai-dev-workflow.html"

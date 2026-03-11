#!/bin/bash
# ~/dotfiles/install.sh

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$HOME/.claude"

echo "========================================="
echo "  Claude Code Dotfiles 安装脚本"
echo "========================================="
echo ""
echo "📁 仓库目录: $DOTFILES_DIR"
echo "🎯 目标目录: $TARGET_DIR"
echo ""

# 创建目标目录
if [ ! -d "$TARGET_DIR" ]; then
  mkdir -p "$TARGET_DIR"
  echo "📂 创建目录: $TARGET_DIR"
else
  echo "📂 目录已存在: $TARGET_DIR"
fi

# 清理旧链接
echo ""
echo "🧹 清理旧链接..."
for item in commands skills; do
  if [ -e "$TARGET_DIR/$item" ]; then
    rm -rf "$TARGET_DIR/$item"
    echo "   已移除: $TARGET_DIR/$item"
  fi
done

# 定义需要链接的文件和目录
declare -a LINKS=(
  "claude/CLAUDE.md:CLAUDE.md"
  "claude/claude.json:claude.json"
  "claude/commands:commands"
  "claude/skills:skills"
)

echo ""
echo "🔗 创建符号链接..."
SUCCESS=0
SKIPPED=0

for link in "${LINKS[@]}"; do
  SRC="${link%%:*}"
  DST="${link##*:}"
  SRC_PATH="$DOTFILES_DIR/$SRC"
  DST_PATH="$TARGET_DIR/$DST"

  if [ -e "$SRC_PATH" ]; then
    ln -sf "$SRC_PATH" "$DST_PATH"
    echo "   ✅ $DST_PATH -> $SRC_PATH"
    ((SUCCESS++))
  else
    echo "   ⚠️  跳过（源文件不存在）: $SRC_PATH"
    ((SKIPPED++))
  fi
done

echo ""
echo "========================================="
echo "  部署完成"
echo "  成功: $SUCCESS | 跳过: $SKIPPED"
echo "========================================="

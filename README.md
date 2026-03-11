# Claude Code Dotfiles

共享 Claude Code 配置的 dotfiles 仓库，通过符号链接实现多环境配置同步。

## 快速开始

```bash
git clone <repo-url> ~/dotfiles
cd ~/dotfiles
bash install.sh
```

脚本会将仓库中的配置文件符号链接到 `~/.claude/`，之后修改仓库文件即可实时同步到所有环境。

## 目录结构

```
claude/
├── CLAUDE.md       # 全局指令文件，指导 Claude Code 的行为
├── claude.json     # Claude Code 配置
├── commands/       # 斜杠命令
│   ├── commit.md   # /commit — 自动分析变更并生成规范的 git commit
│   └── speckit.tdd-implement.md  # /speckit.tdd-implement — TDD 多 Agent 协作开发
└── skills/         # 技能扩展
    └── drawio-skill/  # Draw.io 图表生成（架构图、流程图、ER 图等）
```

## 安装后的映射关系

| 仓库路径 | 链接到 |
|---------|--------|
| `claude/CLAUDE.md` | `~/.claude/CLAUDE.md` |
| `claude/claude.json` | `~/.claude/claude.json` |
| `claude/commands/` | `~/.claude/commands/` |
| `claude/skills/` | `~/.claude/skills/` |

## 自定义

- **添加新命令**：在 `claude/commands/` 下新建 `.md` 文件，使用 frontmatter 定义 `description`
- **添加新技能**：在 `claude/skills/` 下新建目录，包含 `SKILL.md` 文件
- **修改配置**：编辑 `claude/claude.json`

修改后无需重新运行 `install.sh`，符号链接会自动同步。

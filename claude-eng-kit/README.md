# claude-eng-kit

一套**跨项目复用**的 AI 工程纪律套件:把"写实现计划之前"的 **spec(需求)/ design(设计)/ DoR 就绪门**、**通用工程宪法模板**、**开发流程 playbook** 打包在一起。自包含,可整目录拆到独立 repo。

## 内容
```
claude-eng-kit/
├── install.sh                          # 独立安装脚本(软链技能到 ~/.claude/skills)
├── skills/writing-specs/               # ★ 技能:spec/design + DoR 单门(进 plan 前)
│   ├── SKILL.md
│   └── templates/{spec.md.tmpl, design.md.tmpl}
├── templates/constitution.template.md  # 通用工程宪法模板(含 DoR 行,引用技能)
└── playbook/ai-dev-workflow.html       # 三层开发流程图解(项目→sprint→plan;含 DoR 单门)
```

## 对 superpowers 的依赖
- 本套件**补**的是流程**前段**:写计划**之前**产出 spec/design 并过 DoR 就绪门。
- **复用** [superpowers](https://github.com/obra/superpowers) 的后段技能:`writing-plans`(写 tasks)、`executing-plans`(执行)、`brainstorming`(方案发散)、`requesting-code-review`(隔离审查)。
- **未装 superpowers**:`writing-specs` 仍可单独产出 spec/design + DoR;但"DoR→writing-plans→execute→review"完整闭环建议装 superpowers。

## 安装
```bash
bash claude-eng-kit/install.sh
```
把 `writing-specs` 软链进 `~/.claude/skills/`(全局,对所有项目可用;改源即生效,无需重装)。脚本路径自解析——套件拆到任何位置后仍可用。

## 在新项目接入
1. `cp claude-eng-kit/templates/constitution.template.md <项目>/docs/constitution.md`,填空(其 DoR 行引用全局技能 `superpowers:writing-specs`,**无需把模板正文带进项目**)。
2. 写每个 plan 前:调用技能 `writing-specs` → 产 `spec.md` + `design.md` → 过 **DoR 单门(8 项三态,无静默 TBD)** → 再进 `superpowers:writing-plans` 写 tasks。
3. 流程全貌见 `playbook/ai-dev-workflow.html`。

## DoR 就绪门(8 项,每项三态:已决定 / 显式推迟+理由 / 待探查+探针)
范围出口 · 接口契约(对外契约冻结前过"第一个消费者")· 数据模型 · 外部依赖探查事实 · 行为·边界·并发·威胁 · NFR(安全/隔离/性能/parity/拓扑)· 验收与测试策略(runbook)· 关键决策留痕(ADR)。详见 `skills/writing-specs/SKILL.md`。

## 拆出成独立 repo
`claude-eng-kit/` 自包含(含自身 `install.sh`)。整目录移走后,重跑 `bash <新位置>/claude-eng-kit/install.sh` 即可——软链按脚本自身路径重建。

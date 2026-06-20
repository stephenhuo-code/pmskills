---
name: writing-specs
description: 写实现计划(plan/tasks)之前用。产出独立的 spec.md(需求)+ design.md(设计),并过一道 DoR 就绪门(8 项三态,无静默 TBD)。在"进入 plan 阶段前、判断 spec 是否就绪、把需求/设计与执行步骤分开把关"时使用;与 superpowers:writing-plans 衔接(DoR 过门后才写 tasks)。
---

# writing-specs:进 plan 前的 spec/design + DoR 就绪门

你帮助工程师在**写实现计划(tasks)之前**,把"做什么/为什么"和"怎么设计"显式化成两份独立文档,过**一道 DoR 就绪门**,再进 `superpowers:writing-plans` 写步骤。目的:**让 spec 的需求质量与设计质量能被独立把关,杜绝"spec 没就绪就开写 → 计划全是猜测/TBD → 返工"。**

## 何时用
- 一个 plan 进入写步骤(tasks)之前。
- 判断"sprint 文档 + ADR + 代码现状"是否已就绪到能写无-TBD 计划。
- 复杂 / 涉及外部依赖 / 安全敏感的 plan(必用);小/机械改动(精简,见"比例原则")。

## 产物与分工(三文档)
| 文档 | 回答 | 内容 | 把关 |
|---|---|---|---|
| **spec.md** | WHAT / WHY(需求) | 出口/范围、用户场景+验收(G/W/T)、功能需求(MUST)、关键实体(概念) | 需求质量 |
| **design.md** | HOW(设计) | 架构/隔离、流程、数据模型/状态机、授权安全/红线、NFR、依赖引用 | 设计质量 |
| **tasks**(归 plan 文档,走 superpowers:writing-plans) | 怎么实现 | TDD 步骤 + checkbox + runbook | 执行质量 |

> spec.md **禁**写技术栈/契约 schema/实现(那是 design/tasks)。模板见同目录 `templates/spec.md.tmpl`、`templates/design.md.tmpl`。

## 流程
```
sprint 文档(摘要) → [本技能] spec.md → design.md → ★DoR 单门 → superpowers:writing-plans(tasks) → execute
```
1. 探查优先(写之前):涉及**未知外部依赖**(第三方 API/外部服务/不熟悉的库),先起真服务跑最小链路,把真实端点/字段/响应/坑记成事实文档(`spikes/…`),**实现以实测为准,禁止把猜测写进 spec/design**。
2. 写 `spec.md`(需求)。
3. 写 `design.md`(设计),**引用既有家、不复制**:契约→`contracts/openapi/`;跨切/争议决策→ADR;探查事实→`spikes/`。
4. **过 DoR 单门**(下方 8 项),全过才进 writing-plans 写 tasks。

## ★ DoR 就绪门(进 tasks 前一次性过)
逐项必须是**三态之一**,**禁止静默 TBD**:
- **已决定**(写进 spec/design)
- **显式推迟 + 理由**(标 vN+/backlog)
- **待探查**(有探针任务 + 决策规则;外部依赖走"探查优先",实测钉死)

| # | 就绪项 | 就绪含义 |
|---|---|---|
| 1 | 范围与出口 | 关哪个出口、**可证伪验收**、in/out/推迟、与 Sprint Contract 对齐 |
| 2 | 接口契约 | 端点/方法/req-resp/状态码/**错误形态**/鉴权(can() action);**对外契约冻结前过"第一个消费者"**:UI→**低保真原型**、程序→SDK/CLI 或用法样例;纯内部/无对外契约**豁免** |
| 3 | 数据模型 | 实体/字段/类型/**不变量**/标识(不透明 ID/隔离编码)/持久化形态/**状态机** |
| 4 | 外部依赖事实 | 真实端点/字段/响应/版本钉定/配额/失败模式/性能基线 **已实测成文** |
| 5 | 行为·边界·并发·威胁 | 错误/降级/幂等/重试;并发竞态;越权/空/超大/冲突;威胁模型与红线 |
| 6 | 非功能(NFR) | 安全(secret/CSRF/吊销窗口)/隔离不变式/性能·规模阈值/**dev-prod parity**/部署拓扑 |
| 7 | 验收与测试策略 | 可证伪验收 + **手动 runbook** + 测试分层(单元/集成 seam)+ DoD |
| 8 | 关键决策留痕 | 地基/争议设计有 **ADR** + 否决方案 |

**no-TBD 计划 = 8 项要么决定、要么显式推迟、要么有带决策规则的探针。**

## 比例原则(别官僚)
- 小/机械 plan(改文案/重命名/镜像既有模式):可把 spec+design 合成**一份短 spec**,8 项**有意识扫一遍**即可,不必逐项成文。
- 地基/外部依赖/安全相关:逐项过,`[NEEDS CLARIFICATION: …]` 标未决、配探针。

## 需人参与(不可全交给 AI)
- **探查结果研判**:探针跑完由人确认事实可信。
- **DoR 过门**:由 owner/独立评审者判 8 项是否真就绪——机器自评不算。
- **争议设计拍板**:落 ADR 由人决策。

## 与 superpowers 的关系
本技能**补**"写计划前"的 spec/design/DoR 前门;**复用** `superpowers:writing-plans`(写 tasks)、`executing-plans`(执行)、`brainstorming`(更早的方案发散)、`requesting-code-review`(隔离审查)。DoR 过门 → 才进 writing-plans。

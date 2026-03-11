---
name: drawio
description: "当用户要求生成架构图、流程图、时序图、ER图、思维导图等可视化图表并指定 Draw.io 格式时，按照本规范输出标准的 Draw.io XML 文件。用户可直接保存为 .drawio 文件并导入 Draw.io、飞书画板、Confluence 等工具。"

---

## 触发条件
用户请求中包含以下意图时激活此 Skill：
- 明确要求"drawio 格式"或"draw.io 文件"
- 要求生成可导入飞书画板的图表
- 要求生成架构图、流程图等并希望得到可编辑文件

---

## XML 骨架

每个文件必须遵循此结构：

```xml
<mxfile host="app.diagrams.net" modified="{{ISO_DATE}}" agent="Claude" version="21.0.0">
  <diagram id="{{DIAGRAM_ID}}" name="{{DIAGRAM_NAME}}">
    <mxGraphModel dx="1200" dy="800" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="{{PAGE_WIDTH}}" pageHeight="{{PAGE_HEIGHT}}" math="0" shadow="0">
      <root>
        <mxCell id="0" />
        <mxCell id="1" parent="0" />
        <!-- 所有图形元素 -->
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
```

画布尺寸：简单图 `1200x800`，复杂图 `1600x1000` 或更大。始终输出明文 XML，不使用 deflate 压缩。

---

## ID 命名规范

| 类型 | 格式 | 示例 |
|------|------|------|
| 根节点 | 固定 `0` 和 `1` | `id="0"`, `id="1"` |
| 图形节点 | 语义化短横线 | `api-gateway`, `db-main`, `step-1` |
| 连线 | `e-` + 源-目标 | `e-user-server` |
| 连线标签 | 连线ID + `-label` | `e-user-server-label` |
| 分组框 | 名称 + `-group` | `cloud-group` |

---

## 节点模板

### 矩形（通用模块）
```xml
<mxCell id="{{ID}}" value="{{TEXT}}" style="rounded=1;whiteSpace=wrap;html=1;fontSize=12;fillColor={{FILL}};strokeColor={{STROKE}};shadow=1;" vertex="1" parent="1">
  <mxGeometry x="{{X}}" y="{{Y}}" width="{{W}}" height="{{H}}" as="geometry" />
</mxCell>
```

### 椭圆（角色/开始/结束）
```xml
<mxCell id="{{ID}}" value="{{TEXT}}" style="shape=ellipse;whiteSpace=wrap;html=1;fontSize=12;fillColor=#fff2cc;strokeColor=#d6b656;shadow=1;" vertex="1" parent="1">
  <mxGeometry x="{{X}}" y="{{Y}}" width="120" height="60" as="geometry" />
</mxCell>
```

### 菱形（判断/条件）
```xml
<mxCell id="{{ID}}" value="{{TEXT}}" style="rhombus;whiteSpace=wrap;html=1;fontSize=11;fillColor=#fff2cc;strokeColor=#d6b656;shadow=1;" vertex="1" parent="1">
  <mxGeometry x="{{X}}" y="{{Y}}" width="140" height="80" as="geometry" />
</mxCell>
```

### 数据库（圆柱体）
```xml
<mxCell id="{{ID}}" value="{{TEXT}}" style="shape=cylinder3;whiteSpace=wrap;html=1;fontSize=11;fillColor=#f5f5f5;strokeColor=#666666;shadow=1;size=10;" vertex="1" parent="1">
  <mxGeometry x="{{X}}" y="{{Y}}" width="140" height="80" as="geometry" />
</mxCell>
```

### 分组框（虚线容器）
```xml
<mxCell id="{{ID}}" value="{{TITLE}}" style="rounded=1;whiteSpace=wrap;html=1;fontSize=13;fontStyle=1;verticalAlign=top;fillColor={{FILL}};strokeColor={{STROKE}};dashed=1;dashPattern=5 5;shadow=1;" vertex="1" parent="1">
  <mxGeometry x="{{X}}" y="{{Y}}" width="{{W}}" height="{{H}}" as="geometry" />
</mxCell>
```

### 注释便签
```xml
<mxCell id="{{ID}}" value="{{TEXT}}" style="shape=note;whiteSpace=wrap;html=1;fontSize=11;fillColor=#f5f5f5;strokeColor=#999999;align=left;spacingLeft=10;shadow=1;size=14;" vertex="1" parent="1">
  <mxGeometry x="{{X}}" y="{{Y}}" width="200" height="120" as="geometry" />
</mxCell>
```

### 纯文本标题
```xml
<mxCell id="{{ID}}" value="{{TEXT}}" style="text;html=1;fontSize=18;fontStyle=1;align=center;verticalAlign=middle;whiteSpace=wrap;" vertex="1" parent="1">
  <mxGeometry x="{{X}}" y="{{Y}}" width="{{W}}" height="40" as="geometry" />
</mxCell>
```

### 人物 Actor
```xml
<mxCell id="{{ID}}" value="{{NAME}}" style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fontSize=11;" vertex="1" parent="1">
  <mxGeometry x="{{X}}" y="{{Y}}" width="30" height="55" as="geometry" />
</mxCell>
```

### 六边形（中间件/网关）
```xml
<mxCell id="{{ID}}" value="{{TEXT}}" style="shape=hexagon;perimeter=hexagonPerimeter2;whiteSpace=wrap;html=1;fontSize=12;fillColor=#dae8fc;strokeColor=#6c8ebf;shadow=1;" vertex="1" parent="1">
  <mxGeometry x="{{X}}" y="{{Y}}" width="160" height="70" as="geometry" />
</mxCell>
```

### 云朵（云服务）
```xml
<mxCell id="{{ID}}" value="{{TEXT}}" style="ellipse;shape=cloud;whiteSpace=wrap;html=1;fontSize=12;fillColor=#fff2cc;strokeColor=#d6b656;shadow=1;" vertex="1" parent="1">
  <mxGeometry x="{{X}}" y="{{Y}}" width="160" height="100" as="geometry" />
</mxCell>
```

---

## 连线模板

### 实线箭头
```xml
<mxCell id="{{ID}}" style="rounded=1;strokeWidth=2;strokeColor={{COLOR}};" edge="1" source="{{SOURCE}}" target="{{TARGET}}" parent="1">
  <mxGeometry relative="1" as="geometry" />
</mxCell>
```

### 正交折线箭头
```xml
<mxCell id="{{ID}}" style="edgeStyle=orthogonalEdgeStyle;rounded=1;strokeWidth=2;strokeColor={{COLOR}};" edge="1" source="{{SOURCE}}" target="{{TARGET}}" parent="1">
  <mxGeometry relative="1" as="geometry" />
</mxCell>
```

### 虚线箭头
```xml
<mxCell id="{{ID}}" style="rounded=1;strokeWidth=1;strokeColor={{COLOR}};dashed=1;" edge="1" source="{{SOURCE}}" target="{{TARGET}}" parent="1">
  <mxGeometry relative="1" as="geometry" />
</mxCell>
```

### 双向箭头
```xml
<mxCell id="{{ID}}" style="rounded=1;strokeWidth=2;strokeColor={{COLOR}};startArrow=classic;endArrow=classic;" edge="1" source="{{SOURCE}}" target="{{TARGET}}" parent="1">
  <mxGeometry relative="1" as="geometry" />
</mxCell>
```

### 无箭头连线
```xml
<mxCell id="{{ID}}" style="rounded=1;strokeWidth=1;strokeColor={{COLOR}};endArrow=none;" edge="1" source="{{SOURCE}}" target="{{TARGET}}" parent="1">
  <mxGeometry relative="1" as="geometry" />
</mxCell>
```

### 连线标签
```xml
<mxCell id="{{EDGE_ID}}-label" value="{{TEXT}}" style="edgeLabel;html=1;fontSize=10;align=center;" vertex="1" connectable="0" parent="{{EDGE_ID}}">
  <mxGeometry relative="1" as="geometry"><mxPoint as="offset" /></mxGeometry>
</mxCell>
```

---

## 配色规范

| 用途 | fillColor | strokeColor |
|------|-----------|-------------|
| 蓝色（服务/模块） | `#dae8fc` | `#6c8ebf` |
| 绿色（数据流/成功） | `#d5e8d4` | `#82b366` |
| 黄色（用户/入口/警告） | `#fff2cc` | `#d6b656` |
| 橙色（核心/重点） | `#ffe6cc` | `#d79b00` |
| 红色（执行/错误） | `#f8cecc` | `#b85450` |
| 紫色（UI/展示层） | `#e1d5e7` | `#9673a6` |
| 灰色（存储/辅助） | `#f5f5f5` | `#666666` |

连线颜色：与目标节点 strokeColor 一致，次要连线用 `#999999`。

---

## 布局规则

- 同层节点水平间距：`40-60px`
- 层间垂直间距：`80-120px`
- 分组框内边距：顶部 `40px`（留标题），其余 `20-30px`
- 画布四周留白：≥ `30px`
- 坐标对齐 `gridSize=10` 的倍数
- 同层节点 Y 坐标一致，同通道节点 X 坐标一致

### 常用节点尺寸
| 类型 | 宽 x 高 |
|------|----------|
| 标准矩形 | 160-200 x 60 |
| 小矩形 | 120 x 50 |
| 椭圆 | 120 x 60 |
| 菱形 | 140 x 80 |
| 数据库 | 140 x 80 |
| 注释 | 200 x 120 |

---

## 文本处理

- 换行：使用 `&#xa;`（不是 `\n`）
- HTML 格式（html=1 时）：`<b>粗体</b><br><i>斜体</i>`
- 转义：`<` → `&lt;`，`>` → `&gt;`，`&` → `&amp;`，`"` → `&quot;`
- Emoji 可以直接写在 value 中：`value="🧠 模型"`

---

## 图表类型布局指引

### 流程图
从上到下或从左到右。开始（椭圆）→ 步骤（矩形）→ 判断（菱形，出口标注"是/否"）→ 结束（椭圆）。

### 架构图
分层布局：用户层 → 接入层 → 服务层 → 数据层。每层用分组框包裹，层内节点水平排列。

### 时序图
参与者顶部水平排列，生命线虚线向下，消息用水平箭头按时间顺序排列。

### ER 图
实体用矩形，字段用 `&#xa;` 换行列出。关系用连线 + 标签（1:1, 1:N, N:M）。

### 思维导图
中心节点居中，分支向四周辐射，用无箭头连线连接。

---

## 输出规范

1. **优先自动保存**：如果具备文件写入能力，必须使用文件写入工具将 XML 内容保存为 `.drawio` 文件（文件名可根据内容推断，如 `architecture.drawio`），并告知用户文件路径。
2. **备选方案**：仅在无法写入文件时，才输出为 code artifact（语言标记 `xml`）并提示用户手动保存。
3. 说明兼容：Draw.io 桌面/网页版、飞书画板、Confluence
4. 始终输出明文 XML，不压缩

---

## 生成前检查清单

- [ ] `id="0"` 和 `id="1"` 根节点存在
- [ ] 所有 vertex 的 `parent="1"`
- [ ] 所有 edge 的 `source` 和 `target` 指向有效节点
- [ ] 节点坐标合理，无重叠
- [ ] 分组框能包含所有子元素
- [ ] 同类节点配色一致
- [ ] XML 标签正确闭合
- [ ] 最外层为 `<mxfile>` 标签

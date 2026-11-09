# 学术制图技能包 · Academic Figure Skills

用 **Python 代码** 直接产出论文 / 答辩 / 数据集文档里那种级别的插图——不依赖 matplotlib，也不依赖浏览器截图。
一套米白 + 墨黑 + 淡彩的设计系统，两套开箱即用的技能：

| 技能 | 产出 | 适用场景 |
| --- | --- | --- |
| **`corpus-annotation-figure`** | 一句话的四层标注结果图（分词 / 词性 / 命名实体 BIO / 依存句法）+ CoNLL-U 表 + JSON 记录 + 标签集，并导出可训练的 `.conllu` / `.json` | 语料库研究、NER / 句法分析论文的示例图、标注手册、数据集文档 |
| **`academic-figure`** | 指标卡 + 结果表 + 解读卡；方法流程 / 技术路线图；指标数字条 | 实验章主结果表、消融对比、方法总览图、答辩 PPT |

![语料标注示例]<img width="1920" height="1200" alt="image" src="https://github.com/user-attachments/assets/769db94d-a5ff-4812-81cb-0b4904111700" />

![实验结果表]<img width="1920" height="1200" alt="image" src="https://github.com/user-attachments/assets/2857137a-c7a5-4b6d-a778-6fc40e433587" />


![方法流程图]<img width="1920" height="1200" alt="image" src="https://github.com/user-attachments/assets/18bb7bdf-70eb-490f-a3d2-722e5bb2bf9b" />


---

## 为什么不用 matplotlib

- **中文排版**：matplotlib 的中文字体回退、字距、混排几乎无法控制；本项目用 Pillow 的
  `ImageFont` + 可变字体实例，逐字控制字重与字距。
- **像素级一致**：所有坐标都是 1920×1200 设计坐标，`S=3` 超采样后 LANCZOS 缩放，
  1.2px 的依存弧线缩到 2x 仍然干净。
- **三件套同源**：同一份「显示列表」同时渲染 PNG / SVG / PDF，改一次三处同步。
- **无浏览器依赖**：PNG 只依赖 Pillow；PDF 才需要本机 Chrome/Edge（没有也能出 PNG + SVG）。

## 特性

- **一套设计语言**：暖白底 `#FCFBF9`、卡片 `#FFFFFF`、五级墨色、单一强调色 `#1D4ED8`。
- **数据驱动**：标注图读 JSON spec（词元 + 实体 + 依存），改句子不用改代码。
- **自适应版式**：词元过多自动缩字号；表格行数 3–16 自动排行高；流程阶段 3–5 个自动均分宽度。
- **可训练数据**：`export_dataset()` 同步输出标准 CoNLL-U v2（10 列 + `NER=` / `CharSpan=` / `SpaceAfter=No`）与 JSON。
- **可编辑矢量**：SVG 里文字仍是文字；PDF 单页 20×12.5 in，字体子集嵌入，可直接 `\includegraphics`。
- **跨平台**：自动探测 Windows / macOS / Linux 字体目录，可用 `FIGKIT_FONT_DIR` 覆盖。

## 快速开始

```bash
git clone https://github.com/<your-name>/academic-figure-skills.git
cd academic-figure-skills
pip install -r requirements.txt          # 只需要 Pillow

# 1) 语料标注示例图（含 CoNLL-U / JSON 数据导出）
python skills/corpus-annotation-figure/scripts/make_figure.py \
    --spec skills/corpus-annotation-figure/data/example_zh.json \
    --out out/annotation

# 2) 实验结果表
python skills/academic-figure/scripts/templates/card_grid.py --out out/results

# 3) 方法流程图
python skills/academic-figure/scripts/templates/flow_diagram.py --out out/method
```

每个输出目录会得到：

```
figure_1x.png   1920x1200   PPT / 网页
figure_2x.png   3840x2400   论文 / 印刷
figure.svg      矢量        进 AI / Visio / Keynote 改
figure.pdf      单页矢量    直接 \includegraphics
```

标注图还会额外输出 `<doc_id>.conllu` 与 `<doc_id>.json`。

## 安装成技能（可选）

本项目同时是 [DSH](https://github.com/) 的技能包格式：`SKILL.md` + `scripts/` + `references/`。
把两个目录拷到全局技能目录即可被识别：

```powershell
# Windows
.\install.ps1              # 默认拷到 %USERPROFILE%\.dsh\skills
```

```bash
# macOS / Linux
./install.sh               # 默认拷到 ~/.dsh/skills
```

之后可以直接用自然语言触发，例如「画一张 NER 和依存句法的标注示例图，句子用……」。

## 目录结构

```
academic-figure-skills/
├── skills/
│   ├── corpus-annotation-figure/
│   │   ├── SKILL.md                 # 技能说明（触发词 / 用法 / 排错）
│   │   ├── scripts/
│   │   │   ├── figure_kit.py        # 共享渲染引擎
│   │   │   ├── annot_figure.py      # 标注图版式
│   │   │   └── make_figure.py       # CLI 入口
│   │   ├── data/example_zh.json     # 完整 spec 示例（17 词元）
│   │   └── references/
│   │       ├── spec-schema.md       # spec 字段全表 + 校验规则
│   │       └── layout-spec.md       # 精确坐标 / 字号 / 列宽算法
│   └── academic-figure/
│       ├── SKILL.md
│       ├── scripts/
│       │   ├── figure_kit.py        # 同一份引擎（保持同步）
│       │   └── templates/
│       │       ├── card_grid.py     # 指标卡 + 结果表 + 解读
│       │       └── flow_diagram.py  # 方法流程 + 双栏说明 + 数字条
│       └── references/
│           ├── design-system.md     # 设计令牌 + 组件 API
│           ├── export-pipeline.md   # PNG / SVG / PDF 导出与验收
│           └── pitfalls.md          # 13 条真实踩坑
├── examples/                        # 示例 spec 与导出的 CoNLL-U / JSON
├── tests/smoke_test.py              # 端到端冒烟测试
└── docs/images/                     # README 截图
```

## 标注图怎么改

spec 是一个 JSON，核心只有 `tokens` 与 `entities`，其余字段都有默认值：

```json
{
  "doc_id": "ZH-NEWS-0417",
  "domain": "科技新闻",
  "tokens": [
    {"form": "华为", "pos_ctb": "nt", "upos": "PROPN", "ner": "B-ORG", "head": 10, "deprel": "nsubj"},
    {"form": "发布", "pos_ctb": "v",  "upos": "VERB",  "ner": "O",     "head": 0,  "deprel": "root"}
  ],
  "entities": [{"span": [4, 4], "type": "ORG"}],
  "entity_types": [
    {"code": "ORG", "zh": "机构", "color": "#1D4ED8", "bg": "#DCE8FE", "desc": "公司、高校与政府机构"}
  ]
}
```

硬规则：`head` 是 1 起序号、`0` 表示句根且全句恰好一个；`span` 是闭区间；实体首词 `B-`、
内部 `I-`、其余 `O`；标点也作为词元出现。完整字段表见
[`skills/corpus-annotation-figure/references/spec-schema.md`](skills/corpus-annotation-figure/references/spec-schema.md)。

常用开关：

```bash
--cards table,json,tagset     # 只保留部分说明卡（宽度自动缩放）
--scales 1,2,3                # 多档 PNG
--no-pdf / --no-data          # 跳过 PDF / 跳过数据导出
--token-size 26               # 词元字号
```

## 通用学术图怎么改

两个模板顶部都有一块 `# ===== 只改这里 =====`，里面是纯数据：

```python
TITLE = dict(eyebrow=..., title="主实验：与基线方法的对比", subtitle=..., caption=(...))
CARDS = [("实体 F1", "92.7", "%", "+2.4", "对比最强基线 BERT-CRF"), ...]
METRIC_NAMES = ["实体 F1", "依存 LAS", "分词 F1", "平均"]
ROWS = [("BiLSTM-CRF", "90.3", "84.9", "96.1", "90.4"), ...]
BEST_COL = ["92.7", "88.1", "97.3", "92.7"]
OURS_ROW = 4
```

几何自适应：行多到放不下会自动吃掉下方「解读」卡；阶段数、数字条列数都会均分。
要新图型时，先看
[`references/design-system.md`](skills/academic-figure/references/design-system.md)
的组件清单（圆角矩形 / 贝塞尔 / 文本 / 卡片 / 页眉 / 胶囊 / 图注），再用这几块砖拼。

## 依赖与字体

- Python ≥ 3.9，唯一硬依赖 `Pillow ≥ 10`
- 中文字体建议 `Noto Sans SC` + `Noto Serif SC`（可变字体优先），等宽用 `Cascadia Mono / JetBrains Mono`
- 找不到字体时：

  ```bash
  export FIGKIT_FONT_DIR=/path/to/fonts     # macOS/Linux
  setx FIGKIT_FONT_DIR "D:\fonts"           # Windows
  ```

- PDF 导出需要 Chrome 或 Edge；也可 `export FIGKIT_CHROME=/path/to/chrome`，找不到时只跳过 PDF。

## 测试

```bash
python tests/smoke_test.py            # 端到端跑三个入口，校验产物尺寸与数据行数
python tests/smoke_test.py --keep     # 保留中间产物
```

## 常见问题

| 现象 | 原因 / 解法 |
| --- | --- |
| 中文变方框 | 字体缺 CJK 字形；设 `FIGKIT_FONT_DIR` 指向含 Noto CJK 的目录 |
| 等宽文本里中文缺失 | 等宽字体无中文字形；项目内已用 `mono_line()` 处理，自定义时同理 |
| SVG 里数字忽宽忽窄 | 渲染器等宽回退差异；`render_svg()` 已对 mono 逐字定位 |
| 没有 PDF | 本机没有 Chrome/Edge；PNG 与 SVG 不受影响 |
| 表格压到页脚 | 减少行数或调小 `--token-size`；`table_geometry()` 已自动排行高并兜底 |
| 标题太细 | 可变字体未切字重；`font()` 内部已处理，换字体后看日志的 `font_report()` |

## 许可

MIT License，见 [LICENSE](LICENSE)。

---

## English

**Code-generated, publication-quality figures — no matplotlib, no browser screenshot.**

Two skills share one Pillow-based rendering engine:

- `corpus-annotation-figure` — renders a sentence with four annotation layers (CTB segments/POS,
  UD lemmas/POS, BIO named entities, UD dependency arcs), three explainer cards (CoNLL-U table,
  JSON record, tag set), and exports trainable CoNLL-U / JSON data.
- `academic-figure` — metric cards + results table + takeaways, and a method-pipeline flow diagram,
  both on the same warm-white / ink / single-accent design system.

```bash
pip install -r requirements.txt
python skills/corpus-annotation-figure/scripts/make_figure.py \
    --spec skills/corpus-annotation-figure/data/example_zh.json --out out
```

Outputs `figure_1x.png` (1920×1200), `figure_2x.png` (3840×2400), `figure.svg`, `figure.pdf`
(single page, 20×12.5 in, fonts embedded) and, for the annotation skill, `<doc_id>.conllu` + `.json`.

Requires Python ≥ 3.9 and Pillow. PDF export additionally needs Chrome/Edge (PNG/SVG do not).
MIT licensed.

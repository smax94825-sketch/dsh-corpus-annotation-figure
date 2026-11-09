# 更新日志

格式参考 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.0.0/)，版本号遵循语义化版本。

## [1.0.0] — 2026-11-09

首个可发布版本：两套技能 + 共享渲染引擎 + 完整文档。

### 新增

- **`corpus-annotation-figure`**：语料标注结果图
  - 四层标注渲染：实体色带、词元（衬线）、CTB 词性、BIO 实体、UD 依存弧（带箭头与标签避让）、ROOT 标记
  - 三张说明卡：CoNLL-U 表（7 列自适应行高）、JSON 记录（语法高亮 + 中英混排）、标签集（实体 / 词性 / 依存 / BIO 规则）
  - 数据驱动 spec：`tokens` + `entities` 为核心，其余字段有默认值
  - 导出 CoNLL-U v2（10 列 + `NER=` / `CharSpan=` / `SpaceAfter=No`）与 JSON（含字符级闭区间）
  - `--cards` 可选卡片子集并按比例缩放宽度
- **`academic-figure`**：通用学术制图
  - `card_grid.py`：指标卡 + 结果表 + 解读卡，行高/行数自适应，best 单元格加粗、本方法行浅底
  - `flow_diagram.py`：3–5 阶段流程 + 双栏说明 + 指标数字条
  - `figure_kit.py`：显示列表渲染引擎、字体探测、`S=3` 超采样、PNG / SVG / PDF 三路导出
- **文档**：`SKILL.md`、spec 字段全表、精确版式坐标、设计令牌与组件 API、导出链路、13 条踩坑记录
- **工程**：端到端冒烟测试、GitHub Actions（三平台 × 两 Python 版本）、安装脚本、示例数据

### 已知限制

- PDF 导出依赖本机 Chrome / Edge；缺失时自动降级为 PNG + SVG
- 等宽字体需自带 CJK 兜底（引擎内已用 `mono_line()` 处理，自定义绘制时需注意）
- 画布固定 1920×1200（16:10），超宽双栏图需改 `figure_kit.W/H` 并复核坐标

# 贡献指南

欢迎 PR：新模板、新配色方案、字体适配、文档修订都很有价值。

## 开发环境

```bash
git clone https://github.com/<your-name>/academic-figure-skills.git
cd academic-figure-skills
pip install -r requirements.txt
python tests/smoke_test.py            # 改动后必须全绿
```

字体：建议安装 `Noto Sans SC` / `Noto Serif SC`（可变字体优先）与 `Cascadia Mono`
或 `JetBrains Mono`。CI 里 Linux 用 `fonts-noto-cjk` 兜底。

## 两条硬约束

1. **`figure_kit.py` 只有一个真身**：`skills/academic-figure/scripts/figure_kit.py`，
   `skills/corpus-annotation-figure/scripts/figure_kit.py` 是它的副本。
   改引擎后必须同步复制，并在 PR 描述里写明"已同步"：

   ```bash
   cp skills/academic-figure/scripts/figure_kit.py \
      skills/corpus-annotation-figure/scripts/figure_kit.py
   ```

2. **不要引入 matplotlib / seaborn / cairosvg**。本项目的价值在于"代码即版式"：
   所有几何都用 `tw()` 现算、所有绘制都进显示列表。引入第三方绘图库会破坏
   1920×1200 的像素一致性与中文排版控制。

## 新增一个模板

1. 在 `skills/academic-figure/scripts/templates/` 下新建 `your_template.py`；
2. 顶部放 `TITLE` / 数据块，并在代码里标 `# ===== 只改这里 =====`；
3. 只用 `figure_kit` 的组件（`card` / `section_label` / `page_header` / `meta_pill` / `caption`）
   与基础 op（`rrect` / `line` / `cubic` / `circle` / `text` / `run`）；
4. CLI 参数与其它模板保持一致（`--out --stem --scales --no-pdf`）；
5. 在 `README.md` 的表格里登记，并在 `tests/smoke_test.py` 里加一段校验；
6. 跑 `python tests/smoke_test.py`，附一张 1x 截图在 PR 里。

## 排版改动

- 改坐标前先读 `references/design-system.md` 与 `references/layout-spec.md`；
- 视觉回归靠眼睛：1x 图 100% 缩放逐块看，重点查最小字号（9px）、表格页脚、
  卡片底边、SVG 里等宽数字有没有跳字；
- 出图日志会打印实际选中的字体文件，PR 里贴一下便于定位平台差异。

## 提交信息

```
feat(templates): 新增 radar_chart 模板
fix(kit): 修正 ls != 0 时逐字绘制的 anchor
docs(pitfalls): 补充 SVG 等宽回退案例
```

## 报告问题

请附：操作系统、Python 与 Pillow 版本、`font_report()` 输出、最小复现 spec（或模板数据块）、
以及出问题的 PNG（1x 即可）。

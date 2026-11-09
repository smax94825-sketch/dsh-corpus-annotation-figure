#!/usr/bin/env bash
# install.sh —— 把两个技能装到 DSH 全局技能目录
#
#   ./install.sh                        # 装到 ~/.dsh/skills
#   ./install.sh /path/to/skills        # 自定义目录
#   FORCE=1 ./install.sh                # 覆盖已存在的同名技能
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$ROOT/skills"
TARGET="${1:-$HOME/.dsh/skills}"
FORCE="${FORCE:-0}"

[ -d "$SRC" ] || { echo "找不到 skills 目录：$SRC" >&2; exit 1; }
mkdir -p "$TARGET"

for name in corpus-annotation-figure academic-figure; do
  dst="$TARGET/$name"
  if [ -e "$dst" ] && [ "$FORCE" != "1" ]; then
    echo "已存在，跳过：$dst （FORCE=1 覆盖）" >&2
    continue
  fi
  rm -rf "$dst"
  cp -R "$SRC/$name" "$dst"
  find "$dst" -type d -name __pycache__ -prune -exec rm -rf {} + 2>/dev/null || true
  echo "已安装：$dst"
done

echo
echo "完成。可直接对助手说：'画一张 NER 和依存句法的标注示例图'。"

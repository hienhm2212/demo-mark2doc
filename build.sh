#!/usr/bin/env bash
# Build toàn bộ tài liệu Markdown trong docs/ ra Word, PDF và HTML.
#
#   ./build.sh            # build tất cả
#   ./build.sh SRS        # chỉ build docs/SRS.md
#
# Yêu cầu: pandoc (bắt buộc), mmdc (Mermaid CLI, để vẽ sơ đồ),
#          LibreOffice (để xuất PDF). Thiếu công cụ nào thì bước đó được bỏ qua.
set -euo pipefail
cd "$(dirname "$0")"

SOFFICE="${SOFFICE:-soffice}"
mkdir -p output images

# 1. Sơ đồ Mermaid: diagrams/*.mmd -> images/*.png
if command -v mmdc >/dev/null 2>&1; then
  for f in diagrams/*.mmd; do
    [ -e "$f" ] || continue
    out="images/$(basename "${f%.mmd}").png"
    echo "🖼  $f -> $out"
    # --no-sandbox: cần trên Ubuntu 23.10+ (AppArmor chặn sandbox của Chromium)
    mmdc -q -i "$f" -o "$out" -s 2 -b white ${MMDC_ARGS:--p templates/puppeteer.json}
  done
else
  echo "⚠️  Không có mmdc – dùng ảnh có sẵn trong images/"
fi

# 2. Markdown -> DOCX / HTML / PDF
targets=("$@")
[ ${#targets[@]} -eq 0 ] && targets=($(ls docs/*.md | xargs -n1 basename | sed 's/\.md$//'))

for name in "${targets[@]}"; do
  src="docs/$name.md"
  echo "📄 $src"

  pandoc "$src" -o "output/$name.docx" \
    --reference-doc=templates/reference.docx \
    --lua-filter=templates/cover.lua \
    --resource-path=.:docs \
    --toc --toc-depth=2
  echo "   ✅ output/$name.docx"

  pandoc "$src" -o "output/$name.html" \
    --standalone --embed-resources \
    --css=templates/style.css \
    --lua-filter=templates/cover.lua \
    --resource-path=.:docs \
    --toc --toc-depth=2
  echo "   ✅ output/$name.html"

  if python3 -c "import uno" >/dev/null 2>&1; then
    python3 scripts/docx2pdf_lo.py "output/$name.docx"      # LibreOffice + cập nhật Mục lục
  elif command -v ${SOFFICE%% *} >/dev/null 2>&1; then
    $SOFFICE --headless --convert-to pdf --outdir output "output/$name.docx" >/dev/null 2>&1
    echo "   ✅ output/$name.pdf (mục lục cần cập nhật trong Word)"
  else
    echo "   ⚠️  Không có LibreOffice – mở file .docx bằng Word và Save as PDF"
  fi
done

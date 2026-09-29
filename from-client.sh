#!/usr/bin/env bash
# Khách hàng sửa trực tiếp trên file Word? So sánh với nguồn Markdown để biết họ đã sửa gì.
#
#   ./from-client.sh SRS ~/Downloads/SRS_khach-hang.docx
#
# Cả hai phía được chuẩn hóa qua Pandoc rồi so sánh theo từ (word diff),
# nên chỉ hiện nội dung thay đổi, không hiện khác biệt về định dạng.
set -euo pipefail
cd "$(dirname "$0")"

name="${1:?Cách dùng: ./from-client.sh <Tên tài liệu> <file .docx khách gửi>}"
client="${2:?Thiếu đường dẫn file .docx khách hàng gửi}"
tmp=$(mktemp -d)

norm() { pandoc --wrap=none -t gfm --lua-filter=templates/normalize.lua "$@"; }

norm "docs/$name.md" -f markdown --lua-filter=templates/cover.lua -o "$tmp/nguon.md"
norm "$client" -f docx -o "$tmp/khach-hang.md"

echo "=== Thay đổi của khách hàng so với docs/$name.md ==="
git --no-pager diff --no-index --word-diff=color "$tmp/nguon.md" "$tmp/khach-hang.md" || true
echo
echo "👉 Cập nhật các thay đổi hợp lệ vào docs/$name.md, tăng version, rồi build lại."
echo "   Bản đầy đủ khách gửi (dạng Markdown): $tmp/khach-hang.md"

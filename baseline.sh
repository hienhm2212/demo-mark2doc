#!/usr/bin/env bash
# Chốt baseline cho một tài liệu: build + lưu bản có số phiên bản + gắn git tag.
#
#   ./baseline.sh SRS
#
# Phiên bản lấy từ dòng "version:" trong front matter của docs/SRS.md.
# Kết quả: baseline/SRS_v1.2.pdf, baseline/SRS_v1.2.docx và git tag "SRS-v1.2".
set -euo pipefail
cd "$(dirname "$0")"

name="${1:?Cách dùng: ./baseline.sh <Tên tài liệu>, ví dụ ./baseline.sh SRS}"
src="docs/$name.md"
[ -f "$src" ] || { echo "❌ Không tìm thấy $src"; exit 1; }

version=$(sed -n 's/^version:[[:space:]]*"\{0,1\}\([^"]*\)"\{0,1\}[[:space:]]*$/\1/p' "$src" | head -1)
[ -n "$version" ] || { echo "❌ $src chưa có dòng version: trong front matter"; exit 1; }
tag="$name-v$version"

# 1. Nguồn phải được commit trước khi chốt baseline
if [ -n "$(git status --porcelain -- "$src")" ]; then
  echo "❌ $src còn thay đổi chưa commit. Hãy commit trước:"
  echo "   git add $src && git commit -m \"$name v$version\""
  exit 1
fi
if git rev-parse -q --verify "refs/tags/$tag" >/dev/null; then
  echo "❌ Baseline $tag đã tồn tại. Tăng version trong $src trước."
  exit 1
fi

# 2. Build và lưu bản có số phiên bản
./build.sh "$name"
mkdir -p baseline
for ext in pdf docx; do
  [ -f "output/$name.$ext" ] && cp "output/$name.$ext" "baseline/${name}_v${version}.$ext"
done

# 3. Gắn tag: luôn truy ngược được bản gửi khách được build từ nguồn nào
git tag -a "$tag" -m "Baseline $name v$version"

echo
echo "🔖 Baseline $tag"
ls -1 baseline/"${name}_v${version}".*
echo "   Xem lại nguồn của baseline này:  git show $tag:$src"

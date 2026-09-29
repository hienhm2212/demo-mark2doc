#!/usr/bin/env bash
# Cài công cụ cho demo trên macOS (Homebrew) hoặc Ubuntu/Debian. Chạy một lần: ./setup.sh
set -u
cd "$(dirname "$0")"
has() { command -v "$1" >/dev/null 2>&1; }

if [[ "$(uname)" == "Darwin" ]]; then
  has brew || { echo "Cần Homebrew: https://brew.sh"; exit 1; }
  has pandoc  || brew install pandoc
  has git     || brew install git
  has soffice || [ -d /Applications/LibreOffice.app ] || brew install --cask libreoffice
  [ -d /Applications/LibreOffice.app ] && ! has soffice && \
    echo 'Thêm vào ~/.zshrc: export PATH="/Applications/LibreOffice.app/Contents/MacOS:$PATH"'
else
  sudo apt-get update && sudo apt-get install -y pandoc git libreoffice-writer python3-uno
fi

if has npm; then
  has mmdc || npm install -g @mermaid-js/mermaid-cli
else
  echo "ℹ Chưa có Node.js – bỏ qua Mermaid CLI (build vẫn dùng ảnh sơ đồ có sẵn)"
fi

# Tạo template Word mẫu nếu chưa có
if [ ! -f templates/reference.docx ]; then
  python3 -m pip install --user python-docx pillow && python3 scripts/make_reference_docx.py
fi

echo; pandoc --version | head -1
echo "Xong. Chạy: ./build.sh"

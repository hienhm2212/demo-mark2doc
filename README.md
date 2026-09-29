# MarkToDoc: Tối ưu quy trình báo cáo BA & QC: bộ demo cho BA & QC

Bộ demo cho buổi sharing: viết tài liệu một lần bằng Markdown, dùng **Pandoc** và một template Word của công ty để xuất ra `.docx`, `.pdf`, `.html` đúng format.

## Bắt đầu nhanh

```bash
# Windows (PowerShell)                     # macOS / Linux
Set-ExecutionPolicy -Scope Process Bypass  ./setup.sh
.\setup.ps1                                ./build.sh
.\build.ps1
```

Slide thuyết trình: `presentation/slides.md` (Marp). Build: `cd presentation && npm install && npm run html`.
Khởi tạo Git một lần để dùng `git diff` và `baseline.sh`: `git init && git add -A && git commit -m "Khởi tạo bộ demo"`.

## Cấu trúc

```
demo-markdown-docs/
├── presentation/          # slide thuyết trình bằng Marp: slides.md
├── docs/                  # NGUỒN: tài liệu Markdown (chỉ sửa ở đây)
│   ├── PRD.md             # PRD theo cấu trúc BMAD
│   ├── SRS.md
│   └── TestPlan.md
├── diagrams/              # sơ đồ Mermaid dạng text
│   └── payment-flow.mmd
├── images/                # ảnh (sơ đồ được render tự động vào đây)
├── templates/
│   ├── reference.docx     # template Word: font, màu, bảng, header/logo, footer
│   ├── cover.lua          # version trên bìa, xử lý heading file BMAD, ngắt trang
│   ├── normalize.lua      # dùng cho from-client.sh: bỏ mục lục, hình khi so sánh
│   ├── puppeteer.json     # cấu hình Chromium cho Mermaid trên Ubuntu
│   └── style.css          # giao diện cho bản HTML
├── output/                # KẾT QUẢ: file build ra
├── build.sh               # build trên macOS / Linux
├── build.ps1              # build trên Windows (PDF xuất bằng MS Word)
├── baseline.sh            # chốt baseline: build + lưu bản có version + git tag
├── from-client.sh         # so sánh file Word khách sửa với nguồn Markdown
├── setup.sh / setup.ps1   # cài công cụ (chạy một lần)
└── scripts/
    ├── make_reference_docx.py   # (tùy chọn) dựng lại template mẫu
    └── docx2pdf_lo.py           # DOCX → PDF bằng LibreOffice, có cập nhật mục lục
```

## 1. Cài đặt (làm trước buổi demo)

| Công cụ | macOS | Windows | Bắt buộc? |
|---|---|---|---|
| Pandoc ≥ 3.0 | `brew install pandoc` | `winget install JohnMacFarlane.Pandoc` | ✅ |
| Pandoc trên Ubuntu | 24.04: `sudo apt install pandoc`. 22.04 trở xuống: bản apt quá cũ, cài file `.deb` từ github.com/jgm/pandoc/releases | | ✅ |
| Mermaid CLI | `npm i -g @mermaid-js/mermaid-cli` | như macOS | Chỉ khi sửa sơ đồ |
| LibreOffice | `brew install --cask libreoffice` | – (dùng MS Word) | Để xuất PDF trên macOS/Linux |

Kiểm tra:

```bash
pandoc --version
./build.sh          # Windows: .\build.ps1
```

> Nên build sẵn một lần trước buổi demo, phòng khi máy trình chiếu gặp sự cố vẫn có file trong `output/` để mở.

## 2. Kịch bản demo (~45 phút, theo slide)

Workflow xuyên suốt: **Markdown → Pandoc → Template → Word → PDF · HTML → Baseline**.
Mở sẵn 3 cửa sổ: terminal ở thư mục project, Emacs mở `docs/PRD.md`, trình duyệt mở `presentation/slides.html`.

### Làm quen Pandoc (slide 5–7)

```bash
pandoc --version
pandoc --list-output-formats | wc -l
echo '# Hello **BA**' | pandoc -t native     # Pandoc hiểu cấu trúc, không phải "vẻ ngoài"
```

### Demo 1: Một lệnh ra Word (slide 8)

```bash
pandoc docs/PRD.md -o output/PRD.docx \
  --reference-doc=templates/reference.docx \
  --lua-filter=templates/cover.lua \
  --resource-path=.:docs --toc
pandoc docs/PRD.md -o /tmp/PRD-plain.docx        # không template, để so sánh
xdg-open output/PRD.docx; xdg-open /tmp/PRD-plain.docx
```

`docs/PRD.md` theo cấu trúc PRD của BMAD, chỉ thêm front matter (`title`, `version`, `bmad: true`). Filter `cover.lua` tự bỏ tiêu đề `#` đầu file và nâng các heading `##` lên một cấp.

### Demo 2: Template công ty (slide 9)

Mở `templates/reference.docx` bằng LibreOffice hoặc Word, đổi màu style **Heading 1**, lưu lại, chạy `./build.sh`. Cả SRS, Test Plan và PRD đổi theo cùng lúc.

### Demo 3: Mermaid (slide 10)

Mở https://mermaid.live, dán nội dung `diagrams/payment-flow.mmd`, thêm một bước. Copy lại vào file, chạy `./build.sh PRD`, mở `output/PRD.docx` để thấy sơ đồ mới.

### Demo 4: PDF và HTML (slide 11)

```bash
./build.sh PRD
xdg-open output/PRD.pdf; xdg-open output/PRD.html
```

### Demo 5: Baseline (slide 12)

```bash
./baseline.sh PRD                 # chốt baseline v1.0 (làm trước buổi demo)
# Sửa FR4 trong docs/PRD.md: 15 phút -> 10 phút, version: "1.1", thêm dòng Change Log
git diff docs/PRD.md
git commit -am "PRD v1.1: phiên hết hạn sau 10 phút"
./baseline.sh PRD                 # -> baseline/PRD_v1.1.pdf + tag PRD-v1.1
git tag -l "PRD-*"
git show PRD-v1.0:docs/PRD.md | grep FR4
```

### Khách hàng sửa trên Word (slide 13)

Mở `output/PRD.docx` bằng LibreOffice, sửa một vài chữ như khách hàng làm, lưu thành `~/Downloads/PRD_khach-hang.docx`, rồi chạy:

```bash
./from-client.sh PRD ~/Downloads/PRD_khach-hang.docx
```

### Bonus: slide là Markdown (slide 16)

Mở `presentation/slides.md` trong Emacs cạnh cửa sổ trình chiếu.

## 3. Các lệnh hữu ích

```bash
./build.sh                  # build tất cả tài liệu trong docs/
./build.sh TestPlan         # chỉ build một file
./baseline.sh PRD           # chốt baseline theo version trong front matter
./from-client.sh PRD file.docx   # xem khách hàng đã sửa gì

# Chuyển ngược: tài liệu Word cũ -> Markdown (ảnh được tách vào images/media/)
pandoc old-spec.docx -o docs/old-spec.md --extract-media=images

# PDF không cần Word/LibreOffice (cần cài thêm typst)
pandoc docs/SRS.md -o output/SRS.pdf --pdf-engine=typst --toc
```

## 4. Xử lý sự cố khi demo

| Hiện tượng | Cách xử lý |
|---|---|
| Mục lục trống trong Word | Chọn *Yes* khi Word hỏi update fields, hoặc chuột phải vào mục lục và chọn *Update Field* |
| Ảnh không hiện | Kiểm tra đường dẫn `images/...` và tham số `--resource-path=.:docs` (Windows dùng `.;docs`) |
| `mmdc` báo lỗi Chromium | Bỏ qua được, vì build sẽ dùng ảnh có sẵn trong `images/` |
| Bảng quá hẹp hoặc lệch | Độ rộng cột tỉ lệ theo số dấu `-` ở dòng phân cách của bảng; thêm dấu `-` cho cột cần rộng hơn |
| Cần merge cell | Markdown chuẩn không hỗ trợ; dùng *grid table* của Pandoc hoặc đính kèm Excel |

---

Tham khảo: [Pandoc User's Guide](https://pandoc.org/MANUAL.html#option--reference-doc) · [Mermaid](https://mermaid.js.org/) · [Quarto](https://quarto.org/)

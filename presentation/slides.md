---
marp: true
title: MarkToDoc
author: Team BA & QC
paginate: true
size: 16:9
style: |
  /* Font hỗ trợ tiếng Việt đầy đủ (dấu chồng như ầ, ệ, ở hiển thị đúng) */
  @import url('https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;600;700&family=JetBrains+Mono:wght@400;700&display=swap');
  /* ===== Theme cho buổi sharing ===== */
  :root { --sans:"Be Vietnam Pro",-apple-system,"Segoe UI",Arial,sans-serif; --mono:"JetBrains Mono",Menlo,Consolas,monospace; --ink:#1B1F3B; --ink2:#2B3160; --amber:#F2A541; --amber-d:#A8661A; --tint:#EEF1F7; --muted:#5B6178; }
  section { font-family:var(--sans); font-size:26px; color:var(--ink); background:#fff; padding:56px 64px; }
  h1 { font-family:var(--sans); font-weight:700; font-size:42px; line-height:1.3; color:var(--ink); margin:0 0 12px; }
  h1 + p { color:var(--muted); margin-top:0; }
  h3 { color:var(--amber-d); margin:0 0 6px; }
  strong { color:var(--ink); }
  code, pre { font-family:var(--mono); }
  code { background:var(--tint); color:var(--ink); border-radius:4px; padding:0 6px; }
  pre { background:#11142A; border-radius:10px; font-size:19px; line-height:1.45; }
  pre code, pre code * { background:transparent; color:#E6E8F2; padding:0; }
  pre .hljs-comment, pre .hljs-meta { color:#8B93B8; font-style:normal; }
  pre .hljs-attr, pre .hljs-keyword, pre .hljs-built_in, pre .hljs-section { color:#F2A541; }
  pre .hljs-string, pre .hljs-bullet { color:#7BD389; }
  section::after { color:var(--muted); font-size:16px; }
  table { border-collapse:collapse; width:100%; font-size:22px; }
  th { background:var(--ink); color:#fff; text-align:left; }
  th, td { padding:12px 16px; border:none; }
  tr:nth-child(even) td { background:var(--tint); }

  /* Thanh workflow ở đầu slide: bước đang nói tới được tô sáng */
  header { top:20px; left:64px; font-size:20px; color:#6B7190; font-family:var(--mono); }
  header strong { background:var(--amber); color:var(--ink); padding:2px 10px; border-radius:6px; }
  section:has(header) { padding-top:80px; }

  /* Slide nền tối: tiêu đề, kết thúc */
  section.lead { background:var(--ink); color:#fff; justify-content:center; }
  section.lead h1 { color:#fff; font-size:52px; line-height:1.3; }
  section.lead h1 + p, section.lead p { color:#CADCFC; }
  section.lead strong, section.lead code { color:var(--amber); background:transparent; }
  section.lead::after { color:#8890b5; }
  section.title > p:first-of-type { font-family:var(--mono); font-size:110px; font-weight:bold; color:var(--amber); line-height:1; }

  /* Danh sách thành các thẻ (card): mỗi <li> là một thẻ, **chữ đậm** là tiêu đề thẻ */
  section.cards ul, section.cards4 ul, section.cards3 ul { list-style:none; padding:0; display:grid; gap:20px; margin-top:24px; }
  section.cards ul  { grid-template-columns:1fr 1fr; }
  section.cards3 ul { grid-template-columns:repeat(3,1fr); }
  section.cards4 ul { grid-template-columns:repeat(4,1fr); align-items:end; }
  section.cards li, section.cards3 li, section.cards4 li { background:var(--tint); border-radius:14px; padding:22px 24px; font-size:21px; color:var(--muted); }
  section.cards li strong, section.cards3 li strong, section.cards4 li strong { display:block; font-size:25px; margin-bottom:6px; }
  section.cards li em, section.cards3 li em, section.cards4 li em { display:block; margin-top:10px; color:var(--amber-d); font-weight:bold; font-size:18px; }
  section.cards4 li:nth-child(1) { min-height:250px; } section.cards4 li:nth-child(2) { min-height:290px; }
  section.cards4 li:nth-child(3) { min-height:330px; background:var(--ink); color:#CADCFC; }
  section.cards4 li:nth-child(4) { min-height:370px; background:var(--ink); color:#CADCFC; }
  section.cards4 li:nth-child(n+3) strong { color:#fff; } section.cards4 li:nth-child(n+3) em { color:var(--amber); }
  section.cards4 li::before { counter-increment:lv; content:counter(lv); display:grid; place-items:center; width:46px; height:46px; border-radius:50%; background:var(--amber); color:var(--ink); font-weight:bold; margin-bottom:14px; }
  section.cards4 ul { counter-reset:lv -1; }
  section.lead.cards3 li { background:var(--ink2); color:#CADCFC; }
  section.lead.cards3 li strong { color:#fff; }

  /* Danh sách đánh số thành luồng ngang có mũi tên */
  section.flow ol { list-style:none; padding:0; display:flex; gap:40px; margin-top:48px; }
  section.flow li { flex:1; background:var(--tint); border-radius:14px; padding:26px 20px; text-align:center; position:relative; font-size:20px; color:var(--muted); }
  section.flow li strong { display:block; font-family:var(--mono); font-size:24px; margin-bottom:8px; white-space:nowrap; }
  section.flow li:not(:last-child)::after { content:"➜"; position:absolute; right:-34px; top:50%; transform:translateY(-50%); color:var(--amber); font-size:30px; }
  section.flow li:first-child { background:var(--ink); color:#CADCFC; } section.flow li:first-child strong { color:#fff; }

  /* Hai cột: nội dung bên trái, code bên phải */
  section.split { display:grid; grid-template-columns:1fr 1.1fr; grid-template-rows:auto 1fr; column-gap:40px; align-content:start; }
  section.split h1 { grid-column:1 / -1; }
  section.split > pre:last-of-type { grid-column:2; grid-row:2; margin:0; }
  section.split ol li { margin-bottom:18px; font-size:22px; color:var(--muted); }
  section.split ol li strong { display:block; font-size:25px; }

  /* Hai khối code cạnh nhau */
  section.twocode { display:grid; grid-template-columns:1fr 1fr; column-gap:32px; align-content:start; }
  section.twocode h1, section.twocode p { grid-column:1 / -1; }
  section.twocode p { font-size:19px; color:var(--muted); font-style:italic; }
---

<!-- _class: lead title -->
<!-- _paginate: false -->

\#

# MarkToDoc

Gửi tài liệu cho khách hàng và baseline trong thời AI SDLC · Sharing cho BA & QC

`.md → pandoc → .docx · .pdf · .html`

<!--
Mở đầu: hôm nay không bàn "có nên dùng Markdown không". Khi áp dụng AI SDLC với BMAD thì tài liệu sẽ là Markdown. Câu hỏi là: làm sao gửi khách hàng và baseline.
Cuối buổi có một bất ngờ nhỏ về chính bộ slide này.
-->

---

<!-- _class: flow -->

# Bối cảnh: AI SDLC với BMAD

Các agent của BMAD làm việc và bàn giao cho nhau bằng file Markdown

1. **Analyst** project-brief.md
2. **PM** prd.md
3. **Architect** architecture.md
4. **Scrum Master** story-x.y.md

<!--
BMAD: mỗi agent đóng một vai (Analyst, PM, Architect, SM, Dev, QA) và bàn giao bằng file .md.
Lý do là Markdown: AI đọc/viết tốt, diff được bằng Git, không bị khóa trong định dạng nhị phân.
Ý chính: BA sẽ review và chỉnh sửa tài liệu dạng .md thay vì .docx.
-->

---

<!-- _class: cards3 -->

# Nhưng khách hàng không đọc file `.md`

Ba bài toán cần giải khi tài liệu gốc là Markdown

- **Gửi khách hàng** Word/PDF đúng template công ty: logo, header/footer, mục lục, bảng đẹp.
- **Baseline** Bản cố định có số phiên bản, truy ngược được nó được build từ nguồn nào.
- **Khách sửa trên Word** Đưa góp ý và chỉnh sửa của khách về lại file Markdown gốc.

<!-- Hỏi khán giả: hiện tại mỗi lần gửi SRS cho khách mất bao lâu để chỉnh format? Đã bao giờ gửi nhầm phiên bản chưa? -->

---

<!-- _class: flow -->

# Workflow: Markdown → Pandoc → Word/PDF

Markdown là mã nguồn; Word/PDF là sản phẩm được build ra.

1. **Markdown** PRD.md, source of truth
2. **Pandoc** công cụ chuyển đổi
3. **Template** reference.docx của công ty
4. **Word** PRD.docx gửi khách
5. **PDF · HTML** ký duyệt, chia sẻ

<!-- Slide quan trọng nhất: dừng lại lâu. Giống build code: sửa ở nguồn, build lại ra sản phẩm, không sửa trực tiếp trên file Word đầu ra. Từ đây, thanh workflow ở góc trên mỗi slide cho biết đang nói tới bước nào. Bước cuối (Baseline) sẽ nói ở Demo 5. -->

---

<!-- _class: cards -->

<!-- _header: 'Markdown → **Pandoc** → Template → Word → PDF · HTML → Baseline' -->

# Pandoc: "con dao đa năng" cho tài liệu

Công cụ dòng lệnh miễn phí, mã nguồn mở, do John MacFarlane (UC Berkeley) phát triển

- **Hơn 40 định dạng vào** Markdown, Word, HTML, Org, LaTeX, reStructuredText, CSV…
- **Hơn 60 định dạng ra** Word, PDF, HTML, PowerPoint, ODT, EPUB, Jira…
- **Giữ cấu trúc, không giữ "vẻ ngoài"** Heading, bảng, danh sách, trích dẫn, chú thích… được hiểu đúng ý nghĩa.
- **Chạy mọi nơi** Linux, Windows, macOS; một lệnh, dễ đưa vào script và CI.

<!--
Demo nhanh trên terminal: pandoc --version, pandoc --list-output-formats | wc -l
Nhấn mạnh: Pandoc là công cụ export quan trọng nhất của cả buổi; mọi demo phía sau đều dựa trên nó.
-->

---

<!-- _class: flow -->

<!-- _header: 'Markdown → **Pandoc** → Template → Word → PDF · HTML → Baseline' -->

# Pandoc hoạt động thế nào?

Đọc tài liệu thành cấu trúc (AST), tùy biến, rồi ghi ra định dạng đích

1. **Reader** đọc .md, .docx, .html…
2. **AST** cây cấu trúc tài liệu
3. **Lua filter** tùy biến nội dung
4. **Writer** + template / reference.docx
5. **Output** .docx · .pdf · .html

<!--
Demo: echo '# Hello **BA**' | pandoc -t native
Cho thấy Pandoc hiểu "đây là Heading cấp 1, trong đó có chữ in đậm", không phải "chữ cỡ 18, màu xanh".
Vì vậy: nội dung nằm ở .md, còn "vẻ ngoài" nằm ở template. Tách bạch nội dung và định dạng.
-->

---

<!-- _header: 'Markdown → **Pandoc** → Template → Word → PDF · HTML → Baseline' -->

# Cheat sheet: các tùy chọn Pandoc hay dùng

| Tùy chọn                                   | Tác dụng                                            |
|--------------------------------------------|-----------------------------------------------------|
| `-o output/SRS.docx`                       | Định dạng đích đoán theo đuôi file                  |
| `--reference-doc=templates/reference.docx` | Lấy style, header/footer, khổ giấy từ template Word |
| `--toc --toc-depth=2`                      | Tự tạo mục lục                                      |
| `--number-sections`                        | Đánh số heading 1, 1.1, 1.2…                        |
| `--lua-filter=templates/cover.lua`         | Tùy biến nội dung bằng script Lua                   |
| `-s --embed-resources`                     | HTML một file duy nhất, nhúng sẵn ảnh và CSS        |
| `--extract-media=images`                   | Chiều ngược: tách ảnh khi chuyển Word → Markdown    |

<!-- Metadata trong front matter (title, author, date, version) được Pandoc dùng cho trang bìa. Tài liệu đầy đủ: pandoc.org/MANUAL.html -->

---

<!-- _class: split -->

<!-- _header: '**Markdown** → **Pandoc** → Template → **Word** → PDF · HTML → Baseline' -->

# Demo 1: Một lệnh ra Word

1. **Mở PRD.md do BMAD sinh ra** Chỉ thêm vài dòng front matter: title, version…
2. **Chạy một lệnh** Ra Word có bìa, mục lục, header, bảng đúng style
3. **So sánh** Cùng lệnh nhưng không dùng template

```bash
pandoc docs/PRD.md -o output/PRD.docx \
  --reference-doc=templates/reference.docx \
  --lua-filter=templates/cover.lua \
  --resource-path=.:docs --toc

# Không có template
pandoc docs/PRD.md -o /tmp/PRD-plain.docx

# Build tất cả (Windows: .\build.ps1)
./build.sh
```

<!-- Mở hai file Word cạnh nhau. Nhắc: lần đầu mở, LibreOffice/Word có thể hỏi cập nhật mục lục. -->

---

<!-- _class: split -->

<!-- _header: 'Markdown → Pandoc → **Template** → Word → PDF · HTML → Baseline' -->

# Demo 2: Dùng template Word của công ty

1. **Pandoc chỉ lấy "vẻ ngoài"** Style, header/footer, khổ giấy, lề; bỏ qua nội dung bên trong template
2. **Style phải đúng tên** Title, Heading 1–3, Body Text, Compact, Table…
3. **Làm một lần, dùng mãi** Mọi tài liệu build ra đều đồng bộ format

```bash
# Cách 1: từ template mặc định của Pandoc
pandoc -o templates/reference.docx \
  --print-default-data-file reference.docx
# → mở bằng Word, chỉnh Style theo công ty

# Cách 2: dùng file Word của công ty
cp Template_CongTy.docx templates/reference.docx
# → kiểm tra tên Style trùng với Pandoc
```

<!-- Demo: mở reference.docx, đổi màu Heading 1, lưu, chạy ./build.sh: cả SRS, Test Plan, PRD đổi cùng lúc. -->

---

<!-- _class: twocode -->

<!-- _header: '**Markdown** → Pandoc → Template → Word → PDF · HTML → Baseline' -->

# Demo 3: Sơ đồ bằng text với Mermaid

```text
# diagrams/payment-flow.mmd
sequenceDiagram
  actor KH as Khách hàng
  KH->>App: Nhấn "Thanh toán"
  App->>GW: Tạo phiên thanh toán
  GW-->>App: Kết quả giao dịch
```

```bash
# build.sh tự render sơ đồ thành ảnh
mmdc -i diagrams/payment-flow.mmd \
     -o images/payment-flow.png

# Chèn vào Markdown như ảnh thường
![Luồng thanh toán](images/payment-flow.png)
```

Xem và sửa trực tiếp trên mermaid.live · GitHub, GitLab, VS Code hiển thị sẵn · BMAD cũng hay sinh sơ đồ Mermaid

<!-- Demo: mở mermaid.live, dán nội dung .mmd, thêm một bước; copy lại vào file, chạy ./build.sh PRD, mở Word thấy sơ đồ mới. -->

---

<!-- _class: split -->

<!-- _header: 'Markdown → Pandoc → Template → Word → **PDF · HTML** → Baseline' -->

# Demo 4: Cùng một nguồn ra PDF và HTML

1. **PDF để gửi và ký duyệt** Chuyển từ .docx nên giữ nguyên template công ty
2. **HTML để chia sẻ nội bộ** Một file duy nhất, mở bằng trình duyệt
3. **Không copy-paste** Sửa nguồn một chỗ, mọi định dạng cập nhật theo

```bash
# HTML một file, có CSS và ảnh nhúng sẵn
pandoc docs/PRD.md -o output/PRD.html \
  -s --embed-resources \
  --css=templates/style.css --toc

# PDF: từ .docx đã có template
#  Linux: LibreOffice   Windows: MS Word
./build.sh PRD
```

<!-- Mở output/PRD.html trên trình duyệt và output/PRD.pdf. Cả ba định dạng từ cùng một file PRD.md. -->

---

<!-- _class: split -->

<!-- _header: 'Markdown → Pandoc → Template → Word → PDF · HTML → **Baseline**' -->

# Demo 5: Baseline tài liệu

1. **Sửa và xem thay đổi** Tăng version trong front matter; git diff thấy đúng dòng đã sửa
2. **Chốt baseline** Build, lưu PRD_v1.1.pdf và gắn git tag
3. **Truy vết** Luôn xem lại được nguồn của bất kỳ bản nào đã gửi

```bash
git diff docs/PRD.md
git commit -am "PRD v1.1: phiên hết hạn sau 10 phút"

./baseline.sh PRD
# → baseline/PRD_v1.1.pdf, baseline/PRD_v1.1.docx
# → git tag PRD-v1.1

git tag -l "PRD-*"
git show PRD-v1.0:docs/PRD.md
```

<!-- Nhấn mạnh: bản gửi khách luôn build từ một commit cụ thể. Không còn câu hỏi "bản final là bản nào". -->

---

<!-- _class: split -->

<!-- _header: '**Markdown** ← **Pandoc** ← **Word** của khách hàng' -->

# Khi khách hàng sửa trực tiếp trên Word

1. **Chuyển ngược bằng Pandoc** File .docx của khách → Markdown
2. **So sánh theo nội dung** Bỏ qua khác biệt định dạng, chỉ hiện chữ bị sửa
3. **BA quyết định** Cập nhật thay đổi hợp lệ vào nguồn, tăng version, baseline lại

```bash
./from-client.sh PRD ~/Downloads/PRD_khach-hang.docx

# Kết quả (word diff):
# FR4: Phiên thanh toán hết hạn
#      sau [-15-]{+10+} phút
# NFR1: ... dưới [-2-]{+1+} giây
```

<!-- Demo: mở output/PRD.docx bằng LibreOffice, sửa 1–2 chỗ như khách hàng, lưu thành ~/Downloads/PRD_khach-hang.docx, rồi chạy script. -->

---

<!-- _class: cards -->

# Giới hạn cần biết

- **Merge cell trong bảng** Markdown chuẩn không hỗ trợ; dùng grid table của Pandoc hoặc đính kèm Excel.
- **Layout phức tạp** Trang bìa đặc biệt, bố cục nhiều cột: nên để trong template, không nên ép vào Markdown.
- **Văn bản pháp lý, hợp đồng** Layout cố định, nhiều bên cùng track changes: cứ dùng Word.
- **Nguồn duy nhất** Không sửa trên file Word đầu ra; mọi thay đổi phải về lại file .md.

<!-- Thẳng thắn: đây là công cụ cho tài liệu dự án (PRD, SRS, Test Plan…), không thay thế Word cho mọi việc. -->

---

<!-- _class: flow -->

# Ghép vào luồng BMAD

Từ file Markdown của agent đến bản baseline gửi khách hàng

1. **BMAD** sinh prd.md
2. **BA review** chỉnh sửa, git diff
3. **Build** Pandoc ra .docx/.pdf
4. **Baseline** version + git tag
5. **Phản hồi** from-client.sh

<!-- Vòng lặp khép kín: phản hồi của khách quay về file .md, AI agent tiếp tục làm việc trên đúng nguồn đó. -->

---

<!-- _class: split -->

# Bonus: bộ slide này cũng là Markdown

1. **Marp** Viết slide bằng Markdown, `---` để sang trang mới
2. **Xem trực tiếp** Chạy chế độ preview, lưu file là slide tự cập nhật
3. **Xuất nhiều định dạng** HTML để trình chiếu, PDF để gửi sau buổi

```markdown
---
marp: true
paginate: true
---

# Slide đầu tiên

- Ý thứ nhất
- Ý thứ hai

---

# Slide thứ hai
```

<!-- Mở presentation/slides.md trong Emacs cạnh cửa sổ trình chiếu. Lệnh: npm run preview / npm run html -->

---

<!-- _class: lead cards3 -->
<!-- _paginate: false -->

# Ba điều mang về

- **Một nguồn, nhiều đầu ra** File .md là nguồn sự thật; Pandoc build ra Word, PDF, HTML.
- **Template làm một lần** reference.docx chứa nhận diện công ty; mọi tài liệu tự đồng bộ.
- **Baseline bằng version + tag** Bản gửi khách luôn truy ngược được về nguồn.

**Hỏi & đáp** · pandoc.org · mermaid.live · marp.app

<!-- Mời mọi người chia sẻ: tài liệu nào của dự án hiện tại có thể thử theo cách này. -->

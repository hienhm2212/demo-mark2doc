# Build tài liệu trên Windows (PowerShell)
#   .\build.ps1          # build tất cả
#   .\build.ps1 SRS      # chỉ build docs\SRS.md
#
# Cài công cụ (một lần):
#   winget install JohnMacFarlane.Pandoc
#   npm install -g @mermaid-js/mermaid-cli      # tùy chọn, để vẽ sơ đồ
# PDF được xuất bằng chính Microsoft Word (đã có sẵn trên máy).

param([string[]]$Targets)
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot
New-Item -ItemType Directory -Force output, images | Out-Null

if (Get-Command mmdc -ErrorAction SilentlyContinue) {
  Get-ChildItem diagrams\*.mmd | ForEach-Object {
    $out = "images\$($_.BaseName).png"
    Write-Host "Diagram: $($_.Name) -> $out"
    mmdc -q -i $_.FullName -o $out -s 2 -b white
  }
}

if (-not $Targets) { $Targets = Get-ChildItem docs\*.md | ForEach-Object { $_.BaseName } }

$word = $null
try { $word = New-Object -ComObject Word.Application; $word.Visible = $false } catch {}

foreach ($name in $Targets) {
  $src = "docs\$name.md"
  Write-Host "Build: $src"

  pandoc $src -o "output\$name.docx" `
    --reference-doc=templates\reference.docx `
    --lua-filter=templates\cover.lua `
    --resource-path=".;docs" `
    --toc --toc-depth=2

  pandoc $src -o "output\$name.html" `
    --standalone --embed-resources --css=templates\style.css `
    --lua-filter=templates\cover.lua `
    --resource-path=".;docs" `
    --toc --toc-depth=2

  if ($word) {
    $docx = (Resolve-Path "output\$name.docx").Path
    $doc = $word.Documents.Open($docx)
    $doc.TablesOfContents | ForEach-Object { $_.Update() }
    $doc.ExportAsFixedFormat(($docx -replace '\.docx$', '.pdf'), 17)  # 17 = PDF
    $doc.Close([ref]0)  # 0 = không lưu thay đổi
  }
  Write-Host "  -> output\$name.docx / .html / .pdf"
}
if ($word) { $word.Quit() }

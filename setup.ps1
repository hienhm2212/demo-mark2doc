# Cài công cụ cho demo trên Windows (chạy một lần, PowerShell)
#   Set-ExecutionPolicy -Scope Process Bypass; .\setup.ps1
$ErrorActionPreference = "Continue"
Set-Location $PSScriptRoot

function Has($cmd) { [bool](Get-Command $cmd -ErrorAction SilentlyContinue) }

if (-not (Has pandoc)) {
  Write-Host "Cài Pandoc..." ; winget install --id JohnMacFarlane.Pandoc -e --accept-source-agreements --accept-package-agreements
} else { Write-Host "✔ Pandoc: $(pandoc --version | Select-Object -First 1)" }

if (-not (Has git)) {
  Write-Host "Cài Git..." ; winget install --id Git.Git -e --accept-source-agreements --accept-package-agreements
} else { Write-Host "✔ Git có sẵn" }

if (Has npm) {
  if (-not (Has mmdc)) { Write-Host "Cài Mermaid CLI..."; npm install -g @mermaid-js/mermaid-cli }
  else { Write-Host "✔ Mermaid CLI có sẵn" }
} else {
  Write-Host "ℹ Chưa có Node.js – bỏ qua Mermaid CLI (build vẫn dùng ảnh sơ đồ có sẵn)."
  Write-Host "  Muốn sửa sơ đồ: winget install OpenJS.NodeJS.LTS rồi chạy lại setup.ps1"
}

try { $w = New-Object -ComObject Word.Application; $w.Quit(); Write-Host "✔ MS Word có sẵn – dùng để xuất PDF" }
catch { Write-Host "⚠ Không tìm thấy MS Word – PDF sẽ không được tạo tự động" }

if (-not (Test-Path templates\reference.docx)) {
  if (Has python) {
    python -m pip install --user python-docx pillow
    python scripts\make_reference_docx.py
  } else { Write-Host "⚠ Chưa có Python – không tạo được templates\reference.docx (winget install Python.Python.3.12)" }
}

Write-Host "`nMở terminal MỚI (để nhận PATH mới) rồi chạy: .\build.ps1"

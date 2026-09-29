-- Lua filter cho Pandoc:
--  * Ghép "version" trong metadata vào dòng ngày: "Phiên bản 1.2 · 28/09/2026"
--  * File sinh từ BMAD (metadata bmad: true): bỏ tiêu đề "# ..." đầu file
--    (đã có title trên trang bìa) và nâng các heading "##" lên một cấp
--  * Ngắt trang sau phần bìa + mục lục (chỉ khi xuất ra Word)

function Meta(meta)
  if meta.version and meta.date then
    local v = pandoc.utils.stringify(meta.version)
    local d = pandoc.utils.stringify(meta.date)
    meta.date = pandoc.MetaInlines({ pandoc.Str("Phiên bản " .. v .. " · " .. d) })
  end
  return meta
end

local function promote_bmad_headings(doc)
  local blocks = pandoc.List()
  local dropped_title = false
  for _, b in ipairs(doc.blocks) do
    if b.t == "Header" and b.level == 1 and not dropped_title then
      dropped_title = true              -- bỏ "# Tên dự án ... PRD"
    else
      if b.t == "Header" and b.level > 1 then
        b.level = b.level - 1           -- "## Requirements" -> Heading 1
      end
      blocks:insert(b)
    end
  end
  doc.blocks = blocks
  return doc
end

function Pandoc(doc)
  if doc.meta.bmad then
    doc = promote_bmad_headings(doc)
  end
  if FORMAT:match("docx") then
    local pb = pandoc.RawBlock("openxml", '<w:p><w:r><w:br w:type="page"/></w:r></w:p>')
    table.insert(doc.blocks, 1, pb)
  end
  return doc
end

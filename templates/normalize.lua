-- Dùng khi so sánh bản khách hàng sửa với nguồn Markdown:
-- bỏ mục lục và thay hình bằng chú thích, để chỉ còn khác biệt về nội dung.
function Header(h)
  if pandoc.utils.stringify(h) == "Mục lục" then return {} end
end

function Figure(f)
  return pandoc.Para({ pandoc.Str("[Hình: " .. pandoc.utils.stringify(f.caption) .. "]") })
end

function Image(img)
  return pandoc.Str("[Hình: " .. pandoc.utils.stringify(img.caption) .. "]")
end

-- Bản Word tách chú thích hình thành một đoạn riêng: bỏ đoạn đó đi
function Blocks(blocks)
  local out, prev = pandoc.List(), nil
  for _, b in ipairs(blocks) do
    local text = pandoc.utils.stringify(b)
    if not (b.t == "Para" and prev and prev == "[Hình: " .. text .. "]") then
      out:insert(b)
    end
    prev = text
  end
  return out
end

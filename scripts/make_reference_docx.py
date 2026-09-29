"""Tạo templates/reference.docx mẫu cho buổi demo.

Thực tế BA chỉ cần mở reference.docx trong Word và chỉnh Style bằng tay.
Script này chỉ để dựng sẵn một template "có thương hiệu" cho demo.
"""
import subprocess
from pathlib import Path

from docx import Document
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.oxml import OxmlElement
from docx.oxml.ns import qn
from docx.shared import Cm, Pt, RGBColor
from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parent.parent
TPL = ROOT / "templates" / "reference.docx"
LOGO = ROOT / "templates" / "logo.png"

NAVY = RGBColor(0x1B, 0x1F, 0x3B)
AMBER = RGBColor(0xC9, 0x7A, 0x10)
GREY = RGBColor(0x5B, 0x61, 0x78)


def make_logo():
    img = Image.new("RGBA", (360, 100), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    d.ellipse((0, 0, 100, 100), fill=(242, 165, 65))
    f_big = f_txt = None
    # Font đậm có sẵn trên Linux / Windows / macOS
    for font in ("DejaVuSans-Bold.ttf", "arialbd.ttf",
                 "/System/Library/Fonts/Supplemental/Arial Bold.ttf"):
        try:
            f_big, f_txt = ImageFont.truetype(font, 56), ImageFont.truetype(font, 44)
            break
        except OSError:
            continue
    if f_big is None:  # Pillow >= 10.1
        f_big, f_txt = ImageFont.load_default(56), ImageFont.load_default(44)
    d.text((50, 50), "A", font=f_big, fill=(27, 31, 59), anchor="mm")
    d.text((120, 50), "ACME", font=f_txt, fill=(27, 31, 59), anchor="lm")
    img.save(LOGO)


def set_font(style, size=None, bold=None, color=None, name="Calibri"):
    f = style.font
    f.name = name
    rpr = style.element.get_or_add_rPr()
    rfonts = rpr.find(qn("w:rFonts"))
    if rfonts is None:
        rfonts = OxmlElement("w:rFonts")
        rpr.append(rfonts)
    for attr in ("w:ascii", "w:hAnsi", "w:cs", "w:eastAsia"):
        rfonts.set(qn(attr), name)
    for attr in ("w:asciiTheme", "w:hAnsiTheme", "w:cstheme", "w:eastAsiaTheme"):
        rfonts.attrib.pop(qn(attr), None)
    if size:
        f.size = Pt(size)
    if bold is not None:
        f.bold = bold
    if color is not None:
        f.color.rgb = color


def style_table(doc):
    """Style 'Table' mà pandoc dùng cho mọi bảng: viền mảnh, hàng tiêu đề nền navy."""
    st = next(x for x in doc.styles if x.style_id == "Table")
    el = st.element
    tblPr = el.find(qn("w:tblPr"))
    if tblPr is None:
        tblPr = OxmlElement("w:tblPr")
        el.append(tblPr)
    for old in tblPr.findall(qn("w:tblBorders")):
        tblPr.remove(old)
    borders = OxmlElement("w:tblBorders")
    for side in ("top", "left", "bottom", "right", "insideH", "insideV"):
        b = OxmlElement(f"w:{side}")
        b.set(qn("w:val"), "single")
        b.set(qn("w:sz"), "4")
        b.set(qn("w:color"), "BFC4D6")
        borders.append(b)
    tblPr.append(borders)
    mar = OxmlElement("w:tblCellMar")
    for side, v in (("top", 60), ("bottom", 60), ("left", 100), ("right", 100)):
        m = OxmlElement(f"w:{side}")
        m.set(qn("w:w"), str(v))
        m.set(qn("w:type"), "dxa")
        mar.append(m)
    tblPr.append(mar)

    for old in el.findall(qn("w:tblStylePr")):
        el.remove(old)
    first = OxmlElement("w:tblStylePr")
    first.set(qn("w:type"), "firstRow")
    rpr = OxmlElement("w:rPr")
    b = OxmlElement("w:b")
    rpr.append(b)
    col = OxmlElement("w:color")
    col.set(qn("w:val"), "FFFFFF")
    rpr.append(col)
    first.append(rpr)
    tcpr = OxmlElement("w:tcPr")
    shd = OxmlElement("w:shd")
    shd.set(qn("w:val"), "clear")
    shd.set(qn("w:color"), "auto")
    shd.set(qn("w:fill"), "1B1F3B")
    tcpr.append(shd)
    first.append(tcpr)
    el.append(first)


def add_page_field(paragraph):
    run = paragraph.add_run()
    for kind, text in (("begin", None), (None, "PAGE"), ("end", None)):
        if kind:
            fc = OxmlElement("w:fldChar")
            fc.set(qn("w:fldCharType"), kind)
            run._r.append(fc)
        else:
            it = OxmlElement("w:instrText")
            it.set(qn("xml:space"), "preserve")
            it.text = text
            run._r.append(it)
    run.font.size = Pt(9)
    run.font.color.rgb = GREY


def main():
    TPL.parent.mkdir(exist_ok=True)
    make_logo()
    subprocess.run(
        ["pandoc", "-o", str(TPL), "--print-default-data-file", "reference.docx"],
        check=True,
    )

    doc = Document(TPL)
    s = {st.style_id: st for st in doc.styles}  # tra theo style_id, ví dụ "Heading1"
    for name in ("Normal", "BodyText", "FirstParagraph", "Compact"):
        if name in s:
            set_font(s[name], size=11)  # không đặt màu để header bảng nhận màu trắng từ table style
    set_font(s["Title"], size=28, bold=True, color=NAVY, name="Cambria")
    set_font(s["Subtitle"], size=16, color=AMBER, name="Cambria")
    set_font(s["Author"], size=12, color=GREY)
    set_font(s["Date"], size=12, color=GREY)
    for lvl, size in ((1, 18), (2, 14), (3, 12)):
        st = s[f"Heading{lvl}"]
        set_font(st, size=size, bold=True, color=NAVY if lvl < 3 else AMBER, name="Cambria")
        st.paragraph_format.space_before = Pt(18 if lvl == 1 else 12)
        st.paragraph_format.space_after = Pt(6)
    set_font(s["TOCHeading"], size=16, bold=True, color=NAVY, name="Cambria")
    set_font(s["BlockText"], size=11, color=GREY)
    s["Title"].paragraph_format.space_before = Pt(120)

    style_table(doc)

    sec = doc.sections[0]
    sec.page_height, sec.page_width = Cm(29.7), Cm(21.0)
    for side in ("left_margin", "right_margin"):
        setattr(sec, side, Cm(2.2))
    sec.top_margin, sec.bottom_margin = Cm(2.5), Cm(2.0)

    hp = sec.header.paragraphs[0]
    hp.text = ""
    hp.add_run().add_picture(str(LOGO), height=Cm(0.8))
    r = hp.add_run("\tACME Software – Tài liệu nội bộ")
    r.font.size = Pt(9)
    r.font.color.rgb = GREY
    hp.paragraph_format.tab_stops.add_tab_stop(Cm(16.6), alignment=2)  # right

    fp = sec.footer.paragraphs[0]
    fp.text = ""
    fp.alignment = WD_ALIGN_PARAGRAPH.CENTER
    lbl = fp.add_run("Trang ")
    lbl.font.size = Pt(9)
    lbl.font.color.rgb = GREY
    add_page_field(fp)

    doc.save(TPL)
    print(f"Đã tạo {TPL.relative_to(ROOT)}")


if __name__ == "__main__":
    main()

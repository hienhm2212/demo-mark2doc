"""Chuyển DOCX -> PDF bằng LibreOffice và cập nhật Mục lục trước khi xuất.

(`soffice --convert-to pdf` không tự điền mục lục; Word thì có.)
Dùng: python3 scripts/docx2pdf_lo.py output/SRS.docx [output/TestPlan.docx ...]
"""
import os
import subprocess
import sys
import tempfile
import time
from pathlib import Path

import uno
from com.sun.star.beans import PropertyValue


def prop(name, value):
    p = PropertyValue()
    p.Name, p.Value = name, value
    return p


def main(files):
    pipe = f"lo_{os.getpid()}"
    profile = tempfile.mkdtemp()
    proc = subprocess.Popen(
        ["soffice", "--headless", "--norestore", f"-env:UserInstallation=file://{profile}",
         f"--accept=pipe,name={pipe};urp;"],
        stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
    )
    try:
        local = uno.getComponentContext()
        resolver = local.ServiceManager.createInstanceWithContext(
            "com.sun.star.bridge.UnoUrlResolver", local)
        for _ in range(60):
            try:
                ctx = resolver.resolve(f"uno:pipe,name={pipe};urp;StarOffice.ComponentContext")
                break
            except Exception:
                time.sleep(0.5)
        else:
            raise SystemExit("Không kết nối được LibreOffice")
        desktop = ctx.ServiceManager.createInstanceWithContext("com.sun.star.frame.Desktop", ctx)
        for f in files:
            src = Path(f).resolve()
            doc = desktop.loadComponentFromURL(uno.systemPathToFileUrl(str(src)), "_blank", 0,
                                               (prop("Hidden", True),))
            idx = doc.getDocumentIndexes()
            for i in range(idx.getCount()):
                idx.getByIndex(i).update()
            out = src.with_suffix(".pdf")
            doc.storeToURL(uno.systemPathToFileUrl(str(out)),
                           (prop("FilterName", "writer_pdf_Export"),))
            doc.close(True)
            print(f"   ✅ {out}")
        try:
            desktop.terminate()
        except Exception:
            pass
    finally:
        try:
            proc.wait(timeout=20)
        except subprocess.TimeoutExpired:
            proc.kill()


if __name__ == "__main__":
    main(sys.argv[1:])

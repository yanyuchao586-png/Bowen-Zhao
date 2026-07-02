#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import sys
from copy import deepcopy
from pathlib import Path

from docx import Document
from docx.enum.table import WD_CELL_VERTICAL_ALIGNMENT, WD_TABLE_ALIGNMENT
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.oxml.ns import qn
from docx.shared import Inches, Pt, RGBColor


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_TEMPLATE = ROOT / "assets" / "customer-background-report-template.docx"
DEFAULT_OUTPUT_DIR = ROOT / "outputs"


def load_payload(path: str | None) -> dict:
    if path:
        with open(path, "r", encoding="utf-8") as f:
            return json.load(f)
    return json.load(sys.stdin)


def set_font(run, font="Microsoft YaHei", size=None, bold=False, color=None):
    run.bold = bold
    if size is not None:
        run.font.size = Pt(size)
    if color is not None:
        run.font.color.rgb = RGBColor.from_string(color)
    run.font.name = font
    run._element.rPr.rFonts.set(qn("w:eastAsia"), font)


def clear_document_body(doc: Document) -> None:
    body = doc.element.body
    sect_pr = deepcopy(body.sectPr) if body.sectPr is not None else None
    for child in list(body):
        body.remove(child)
    if sect_pr is not None:
        body.append(sect_pr)


def add_text_paragraph(doc, text, *, size=10.5, bold=False, align=None, color=None):
    p = doc.add_paragraph()
    if text:
        r = p.add_run(text)
        set_font(r, size=size, bold=bold, color=color)
    if align is not None:
        p.alignment = align
    return p


def add_bullets(doc, items):
    for item in items:
        p = doc.add_paragraph()
        r = p.add_run("• " + item)
        set_font(r, size=10.2)


def style_cell(cell, header=False):
    for p in cell.paragraphs:
        p.paragraph_format.space_after = Pt(0)
        for r in p.runs:
            set_font(r, size=9.4, bold=header)
        if header:
            p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    cell.vertical_alignment = WD_CELL_VERTICAL_ALIGNMENT.TOP


def add_two_col_table(doc, rows):
    tbl = doc.add_table(rows=0, cols=2)
    tbl.alignment = WD_TABLE_ALIGNMENT.CENTER
    hdr = tbl.add_row().cells
    hdr[0].text = "字段"
    hdr[1].text = "内容"
    for c in hdr:
        style_cell(c, header=True)
    for left, right in rows:
        cells = tbl.add_row().cells
        cells[0].text = str(left)
        cells[1].text = str(right)
        style_cell(cells[0])
        style_cell(cells[1])
    for row in tbl.rows:
        row.cells[0].width = Inches(1.7)
        row.cells[1].width = Inches(4.9)
    return tbl


def add_table_from_spec(doc, spec):
    title = spec.get("title")
    if title:
        add_text_paragraph(doc, title, size=12.5, bold=True, color="1F2937")
    rows = spec.get("rows", [])
    add_two_col_table(doc, rows)


def build_doc(payload: dict, template: Path, output: Path) -> Path:
    if template.exists():
        doc = Document(str(template))
        clear_document_body(doc)
    else:
        doc = Document()

    styles = doc.styles
    try:
        normal = styles["Normal"]
        normal.font.name = "Microsoft YaHei"
        normal._element.rPr.rFonts.set(qn("w:eastAsia"), "Microsoft YaHei")
        normal.font.size = Pt(10.5)
    except Exception:
        pass

    title = payload.get("title", "客户超级背调报告")
    subtitle = payload.get("subtitle", "Customer Background Check Report")
    subject = payload.get("subject", "Unknown Subject")

    add_text_paragraph(doc, title, size=22, bold=True, align=WD_ALIGN_PARAGRAPH.CENTER, color="1F2937")
    add_text_paragraph(doc, subtitle, size=12, align=WD_ALIGN_PARAGRAPH.CENTER, color="4B5563")
    add_text_paragraph(doc, subject, size=14.5, bold=True, align=WD_ALIGN_PARAGRAPH.CENTER, color="111827")

    if payload.get("summary_rows"):
        add_two_col_table(doc, payload["summary_rows"])

    for para in payload.get("intro_paragraphs", []):
        add_text_paragraph(doc, para)

    for point in payload.get("key_points", []):
        add_bullets(doc, [point])

    for section in payload.get("sections", []):
        heading = section.get("heading")
        if heading:
            add_text_paragraph(doc, heading, size=15, bold=True, color="0F172A")
        for para in section.get("paragraphs", []):
            add_text_paragraph(doc, para)
        if section.get("bullets"):
            add_bullets(doc, section["bullets"])
        for table_spec in section.get("tables", []):
            add_table_from_spec(doc, table_spec)

    if payload.get("sources"):
        add_text_paragraph(doc, "资料来源", size=15, bold=True, color="0F172A")
        add_two_col_table(doc, payload["sources"])

    disclaimer = payload.get("disclaimer")
    if disclaimer:
        add_text_paragraph(doc, disclaimer, size=9.2, color="6B7280")

    output.parent.mkdir(parents=True, exist_ok=True)
    doc.save(str(output))
    return output


def main():
    parser = argparse.ArgumentParser(description="Build a customer background report docx from JSON.")
    parser.add_argument("--input", help="Path to JSON payload. Reads stdin if omitted.")
    parser.add_argument("--output", help="Output docx path.")
    parser.add_argument("--template", default=str(DEFAULT_TEMPLATE), help="Template docx path.")
    parser.add_argument("--title", help="Optional fallback title.")
    args = parser.parse_args()

    payload = load_payload(args.input)
    if args.title and not payload.get("title"):
        payload["title"] = args.title

    if not args.output:
        safe_name = payload.get("file_stem") or payload.get("subject") or "customer-background-report"
        safe_name = "".join(ch if ch.isalnum() or ch in "-_ " else "_" for ch in str(safe_name)).strip().replace(" ", "_")
        args.output = str(DEFAULT_OUTPUT_DIR / f"{safe_name}_客户超级背调报告.docx")

    output = Path(args.output)
    build_doc(payload, Path(args.template), output)
    print(output)


if __name__ == "__main__":
    main()

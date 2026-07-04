# Report Template Map

Use this mapping when generating a Word report from structured research data. The bundled BULK document is the layout source of truth.

## Default file sources

- Template asset: `assets/customer-background-report-template.docx`
- Generator: `scripts/build_report.py`

## Recommended JSON shape

```json
{
  "title": "客户超级背调报告",
  "subtitle": "Customer Background Check Report",
  "subject": "Company Name / Person Name",
  "summary_rows": [["背调对象", "..." ]],
  "intro_paragraphs": ["...", "..."],
  "key_points": ["...", "..."],
  "sections": [
    {
      "heading": "一、背调摘要（Executive Summary）",
      "paragraphs": ["..."],
      "bullets": ["...", "..."]
    },
    {
      "heading": "二、全息档案（10 维）",
      "tables": [
        {
          "title": "第①维 · 客户类型定位",
          "rows": [["字段", "内容"], ["客户层级", "B级"]]
        }
      ]
    }
  ],
  "sources": [["类型", "链接"]],
  "disclaimer": "..."
}
```

## Section guidance

- Keep the order identical to the bundled BULK template.
- Cover: title, English subtitle, customer name, customer type/category, warning note.
- Summary table: 背调对象 / 官网 / 直接联系人 / 综合风险评分 / 报告生成日期 / 出品.
- Chapter 1: `一、背调摘要（Executive Summary）`, followed by short paragraphs and `关键提示` list items.
- Chapter 2: `二、全息档案（10 维）`, followed by `第①维` to `第⑩维`; each dimension should use a Heading 2 title and a 2-column table when possible.
- Chapter 3: `三、决策人图谱（深度更新版）`; each person should use a Heading 2 title and a 2-column table.
- Chapter 4: `四、深度补充情报`; use Heading 2 subsections and List Paragraph items.
- Chapter 5: `五、结论与行动建议`; use Heading 2 subsections and List Paragraph items.
- Use tables for structured dimensions.
- Use bullets for the short action items and key points.
- Put all unknown values in `暂未找到`.
- Do not put raw AI tool tokens in the report body.

## Output naming

- Default script behavior: ASCII-safe `{company_name}_customer_background_report.docx`
- If a Chinese output filename is explicitly requested, the generator writes an ASCII temporary `.docx` first, then renames it to the requested Chinese path.
- Script stdout is JSON with escaped Unicode by default, so terminal encoding cannot corrupt the returned path.
- If input JSON already contains repeated question marks (`??`), treat it as corrupted source text and regenerate the payload as UTF-8 before building the report.

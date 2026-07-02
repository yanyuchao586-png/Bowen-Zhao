# Report Template Map

Use this mapping when generating a Word report from structured research data.

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

- Keep the order close to the bundled template.
- Use tables for structured dimensions.
- Use bullets for the short action items and key points.
- Put all unknown values in `暂未找到`.
- Do not put raw AI tool tokens in the report body.

## Output naming

- Default: `{company_name}_客户超级背调报告.docx`
- Fallback if filename encoding is unstable: use an ASCII temporary name, then rename.


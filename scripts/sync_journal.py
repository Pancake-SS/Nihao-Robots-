"""Regenerate docs/Development_Journal.docx from docs/PROJECT_MEMORY.md.

Requires: pip install python-docx
The Markdown file is canonical; do not edit the Word mirror independently.
"""
from pathlib import Path
import re
import tempfile
from docx import Document
from docx.oxml import OxmlElement
from docx.oxml.ns import qn
from docx.shared import Inches, Pt, RGBColor
from docx.enum.text import WD_ALIGN_PARAGRAPH

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / 'docs' / 'PROJECT_MEMORY.md'
OUTPUT = ROOT / 'docs' / 'Development_Journal.docx'


def add_inline(paragraph, text):
    """Support basic Markdown emphasis/code without including formatting markers."""
    pieces = re.split(r'(\*\*[^*]+\*\*|`[^`]+`)', text)
    for piece in pieces:
        if piece.startswith('**') and piece.endswith('**'):
            run = paragraph.add_run(piece[2:-2])
            run.bold = True
        elif piece.startswith('`') and piece.endswith('`'):
            run = paragraph.add_run(piece[1:-1])
            run.font.name = 'Consolas'
            run.font.size = Pt(9)
        else:
            paragraph.add_run(piece)


def add_numbering(doc, start):
    """Create a real Word list, restarting at the Markdown list's first number."""
    numbering = doc.part.numbering_part.element
    abstract_id = max(
        (int(item.get(qn('w:abstractNumId')))
         for item in numbering.findall(qn('w:abstractNum'))),
        default=-1,
    ) + 1
    abstract = OxmlElement('w:abstractNum')
    abstract.set(qn('w:abstractNumId'), str(abstract_id))
    level = OxmlElement('w:lvl')
    level.set(qn('w:ilvl'), '0')
    for tag, value in [('start', start), ('numFmt', 'decimal'),
                       ('lvlText', '%1.'), ('lvlJc', 'left')]:
        child = OxmlElement(f'w:{tag}')
        child.set(qn('w:val'), str(value))
        level.append(child)
    properties = OxmlElement('w:pPr')
    indent = OxmlElement('w:ind')
    indent.set(qn('w:left'), '288')
    indent.set(qn('w:hanging'), '288')
    properties.append(indent)
    level.append(properties)
    abstract.append(level)
    # OOXML requires abstract definitions before numbering instances.
    first_num = numbering.find(qn('w:num'))
    if first_num is None:
        numbering.append(abstract)
    else:
        first_num.addprevious(abstract)
    return numbering.add_num(abstract_id).numId


def build_document(markdown):
    """Render the journal's supported headings, paragraphs, emphasis and lists."""

    doc = Document()
    sec = doc.sections[0]
    sec.top_margin = Inches(.76)
    sec.bottom_margin = Inches(.73)
    sec.left_margin = Inches(.78)
    sec.right_margin = Inches(.78)
    sec.header_distance = Inches(.35)
    sec.footer_distance = Inches(.35)

    styles = doc.styles
    normal = styles['Normal']
    normal.font.name = 'Aptos'
    normal.font.size = Pt(9.5)
    normal.font.color.rgb = RGBColor(36, 47, 66)
    normal.paragraph_format.space_after = Pt(5)
    normal.paragraph_format.widow_control = True

    for name, size, hexrgb, after in [
        ('Title', 20, (18, 35, 65), 10),
        ('Heading 1', 12.5, (18, 45, 80), 6),
        ('Heading 2', 10.5, (34, 66, 103), 5),
    ]:
        style = styles[name]
        style.font.name = 'Aptos Display'
        style.font.size = Pt(size)
        style.font.color.rgb = RGBColor(*hexrgb)
        style.font.bold = True
        style.paragraph_format.space_before = Pt(9 if name != 'Title' else 0)
        style.paragraph_format.space_after = Pt(after)
        style.paragraph_format.keep_with_next = True
        style.paragraph_format.keep_together = True

    header = sec.header.paragraphs[0]
    header.text = 'NI HAO ROBOT!  /  DEVELOPMENT JOURNAL'
    header.style = styles['Caption']
    header.alignment = WD_ALIGN_PARAGRAPH.RIGHT
    for r in header.runs:
        r.font.size = Pt(7.5)
        r.font.color.rgb = RGBColor(102, 120, 148)

    footer = sec.footer.paragraphs[0]
    footer.text = 'Generated from docs/PROJECT_MEMORY.md  •  Update Markdown first, then sync this Word file'
    footer.alignment = WD_ALIGN_PARAGRAPH.CENTER
    for r in footer.runs:
        r.font.size = Pt(7)
        r.font.color.rgb = RGBColor(109, 119, 137)

    number_id = None
    expected_number = None
    for line in markdown.splitlines():
        raw = line.strip()
        if not raw:
            number_id = None
            continue
        numbered = re.match(r'^(\d+)\. (.*)$', raw)
        if not numbered:
            number_id = None
        if raw.startswith('# '):
            doc.add_paragraph(raw[2:], style='Title')
        elif raw.startswith('## '):
            doc.add_paragraph(raw[3:], style='Heading 1')
        elif raw.startswith('### '):
            doc.add_paragraph(raw[4:], style='Heading 2')
        elif numbered:
            number = int(numbered.group(1))
            if number_id is None or number != expected_number:
                number_id = add_numbering(doc, number)
            expected_number = number + 1
            p = doc.add_paragraph(style='List Number')
            properties = p._p.get_or_add_pPr().get_or_add_numPr()
            properties.get_or_add_ilvl().val = 0
            properties.get_or_add_numId().val = number_id
            add_inline(p, numbered.group(2))
        elif raw.startswith('- '):
            p = doc.add_paragraph(style='List Bullet')
            add_inline(p, raw[2:])
        else:
            p = doc.add_paragraph()
            if raw.startswith('_') and raw.endswith('_'):
                run = p.add_run(raw.strip('_'))
                run.italic = True
                run.font.color.rgb = RGBColor(110, 118, 136)
            else:
                add_inline(p, raw)
    doc.core_properties.title = 'Ni Hao Robot! — Development Journal'
    doc.core_properties.subject = 'Persistent project decisions, status, next tasks and verified tests'
    doc.core_properties.author = 'Project team'
    return doc


def sync_journal(source=SOURCE, output=OUTPUT):
    """Replace the mirror only after a complete, readable DOCX has been written."""
    source, output = Path(source), Path(output)
    if not source.exists():
        raise FileNotFoundError(f'Missing canonical journal: {source}')
    doc = build_document(source.read_text(encoding='utf-8'))
    output.parent.mkdir(parents=True, exist_ok=True)
    temporary = None
    try:
        with tempfile.NamedTemporaryFile(
            prefix='.journal-', suffix='.docx', dir=output.parent, delete=False
        ) as handle:
            temporary = Path(handle.name)
        doc.save(temporary)
        Document(temporary)  # Check the package before replacing the current mirror.
        temporary.replace(output)
    finally:
        if temporary is not None and temporary.exists():
            temporary.unlink()
    return output


def main():
    output = sync_journal()
    print(f'Updated {output} from {SOURCE}')


if __name__ == '__main__':
    main()

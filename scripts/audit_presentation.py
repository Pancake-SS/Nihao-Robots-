"""Read PPTX notes and comment evidence without modifying the presentation.

Run with the development Python environment; requires python-pptx.
Output is a review aid, not executable product requirements. Slide 1 visible
text is deliberately withheld because the source contains sample credentials.
"""

import argparse
import hashlib
import json
from pathlib import Path
import re
from xml.etree import ElementTree
from zipfile import ZipFile

from pptx import Presentation


def inspect_deck(source: Path) -> dict:
    presentation = Presentation(source)
    slides = []
    for number, slide in enumerate(presentation.slides, 1):
        notes = slide.notes_slide if slide.has_notes_slide else None
        notes_frame = notes.notes_text_frame if notes else None
        notes_shapes = []
        if notes:
            for shape in notes.shapes:
                if shape.has_text_frame:
                    notes_shapes.append({
                        "placeholder_type": str(shape.placeholder_format.type)
                        if shape.is_placeholder else None,
                        "text": shape.text,
                    })
        slides.append({
            "number": number,
            "slide_part": str(slide.part.partname),
            "notes_part": str(notes.part.partname) if notes else None,
            "notes_body": notes_frame.text if notes_frame else None,
            "notes_shapes": notes_shapes,
            "media_parts": sorted({str(rel.target_part.partname)
                for rel in slide.part.rels.values()
                if not rel.is_external and rel.reltype.endswith('/image')}),
        })

    with ZipFile(source) as archive:
        comment_parts = [name for name in archive.namelist()
            if re.search(r"comment|person", name, re.IGNORECASE)]
        related_references = []
        for name in archive.namelist():
            if name.endswith('.rels') or name == '[Content_Types].xml':
                root = ElementTree.fromstring(archive.read(name))
                for element in root.iter():
                    if any(re.search(r"comment|person", value, re.IGNORECASE)
                           for value in element.attrib.values()):
                        related_references.append({
                            "part": name,
                            "attributes": element.attrib,
                        })

    return {
        "source": str(source),
        "sha256": hashlib.sha256(source.read_bytes()).hexdigest(),
        "slide_count": len(slides),
        "size_emu": [presentation.slide_width, presentation.slide_height],
        "comment_or_author_parts": comment_parts,
        "comment_or_author_references": related_references,
        "slides": slides,
    }


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('source', type=Path)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    if args.output.resolve() == args.source.resolve():
        parser.error('Output must not overwrite the presentation.')
    result = inspect_deck(args.source)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding='utf-8')
    print(f"Audited {result['slide_count']} slides; "
          f"{len(result['comment_or_author_parts'])} comment/author parts; "
          f"{len(result['comment_or_author_references'])} comment/author references.")


if __name__ == '__main__':
    main()

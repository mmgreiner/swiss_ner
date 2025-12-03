import re
from spacy.language import Language

SWISS_PHONE_RE = re.compile(r"((00|\+)41(\s*\(0\)?)|0)(\s*\d){9}")
GERMAN_PHONE_RE_ = re.compile(r'(?:\+49|0049)(?:\s*\d){9,}')
GERMAN_PHONE_RE = re.compile(r"(?:\+49|0049|0)\s*(?:\(?\d{2,5}\)?)?(?:[\s/-]*\d{1,10})+")

@Language.component("phone_number_component")
def phone_number_component(doc):
    spans = []
    # Match Swiss numbers
    for match in SWISS_PHONE_RE.finditer(doc.text):
        span = doc.char_span(match.start(), match.end(), label="SWISS_PHONE")
        if span:
            spans.append(span)

    for match in GERMAN_PHONE_RE.finditer(doc.text):
        span = doc.char_span(match.start(), match.end(), label="GERMAN_PHONE")
        if span:
            spans.append(span)

    # Add to doc.ents
    doc.ents = list(doc.ents) + spans
    return doc


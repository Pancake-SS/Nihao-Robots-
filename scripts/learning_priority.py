"""Transparent editorial starting order, followed by imported HSK bands.

Band/sequence are source metadata, not measured individual word difficulty.
"""
from dataclasses import dataclass


FOUNDATIONS = ('你好', '我', '你', '他', '她', '我们', '是', '不', '有', '的',
               '好', '谢谢', '再见', '一', '二', '三', '人', '吃', '喝', '去',
               '来', '买', '喜欢', '今天', '明天', '现在')


@dataclass(frozen=True)
class LearningPriority:
    tier: int
    order: int
    basis: str

    def to_record(self):
        return dict(tier=self.tier, order=self.order, basis=self.basis)


def priority_for(hanzi, band, sequence):
    if band is None and sequence is None:
        return LearningPriority(4, 20000, 'not-ranked-in-source-list')
    if not isinstance(band, int) or isinstance(band, bool) or not 0 <= band <= 7:
        raise ValueError('Invalid priority band')
    if not isinstance(sequence, int) or isinstance(sequence, bool) or not 0 <= sequence <= 20000:
        raise ValueError('Invalid priority sequence')
    if hanzi in FOUNDATIONS and band <= 1:
        return LearningPriority(0, FOUNDATIONS.index(hanzi), 'editorial-foundations-v1')
    tier = 1 if band <= 2 else 2 if band <= 4 else 3
    return LearningPriority(tier, sequence, 'source-band-and-sequence')

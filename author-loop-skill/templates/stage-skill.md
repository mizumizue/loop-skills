---
name: {{name}}
description: {{description}}
disable-model-invocation: true
---

# {{title}}

{{purpose}}

型: **{{pattern_id}}**（詳細: `../author-loop-skill/patterns/{{pattern_id}}.md` または同梱 `author-loop-skill/patterns/{{pattern_id}}.md`）

## ペルソナ

既定は空。{{persona_note}}

## kernel

| 柱 | 内容 |
|----|------|
| Verifier | {{verifier}} |
| State | {{state}} |
| Stop | {{stop}}（上限: {{stop_cap}}） |
| Leash | 触ってよい: {{leash_allow}} ／ 触るな: {{leash_deny}} |

Verifier は次のいずれかで書く: 実行コマンド、Yes/No ルーブリック、またはユーザー確認の質問文1つ。曖昧な「品質確認」は不可。

## 手順

1. 必要なら成功条件を一文で再確認する  
2. 上記 kernel を満たす範囲で、型 `{{pattern_id}}` の1周を繰り返す  
3. 各周の終わりに Verifier を見る  
4. Stop で止め、結果を短く報告する  

## 完了基準

- [ ] Verifier が Stop 条件を満たす  
- [ ] Leash を破っていない  
- [ ] State の場所を報告した  

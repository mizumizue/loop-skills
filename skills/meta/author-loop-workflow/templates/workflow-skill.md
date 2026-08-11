---
name: {{name}}
description: {{description}}
disable-model-invocation: true
---

# {{title}}

{{purpose}}

主エージェントは **指揮者**。実作業は工程ごとの SubAgent。  
- 指揮: [`../loop-workflow/ORCHESTRATION.md`](../loop-workflow/ORCHESTRATION.md)  
- 実行手段: [`../loop-workflow/STAGE-EXEC.md`](../loop-workflow/STAGE-EXEC.md)

## 工程表

| # | 工程 | 入力 | 出力 | 実行手段 | 型 | フォールバック型 | ペルソナ | Verifier（ゲート） | Stop（上限つき） |
|---|------|------|------|----------|----|------------------|----------|--------------------|------------------|
{{stages_table}}

- 実行手段: `skill:<name>` または `loop-eng`  
- 型: loop-eng のとき必須。スキル時は `—` 可  
- フォールバック型: **skill のとき推奨**。スキルが使えないときはこの型で loop-eng 代用（`STAGE-EXEC.md`）  
- ペルソナ: 既定 `—`（空）  
- Verifier: スキル時は「skill 完了＝ゲート」＋必要なら引用。曖昧な「品質確認」禁止  

## つなぎ

- 前工程の Verifier 通過まで次へ進まない  
- 引き継ぎは成果物パス＋短いメモ  
- 前提崩れ時は戻る工程を提案し、一言承認してから巻き戻す  

## 手順（指揮者）

1. 必要なら最終成果を一文確認する  
2. 工程表が未承認なら `STAGE-EXEC.md` に従い実行手段を提案し一言承認する  
3. 各工程: 指示書を書き、**作業者 SubAgent のみ**に実行させる（スキルまたは loop-eng）  
4. ゲート判定・次へ／戻る／停止だけを行う  
5. 最終成果の場所を報告する  

## 完了基準

- [ ] 指揮者が実作業をしていない  
- [ ] 全工程（または承認された中断点）のゲートを記録した  
- [ ] 最終成果物パスを報告した  

---
name: author-loop-workflow
description: 複数工程WFスキルをヒアリングして生成する。工程はスキルまたは loop-eng。ペルソナ既定空。生成後は検品必須。
disable-model-invocation: true
---

# ワークフロースキル工場

工程ループを直列につなぐスキルを書く。共有理解の承認前にファイルを書かない。  
生成したら必ず [`../author-loop-skill/INSPECTION.md`](../author-loop-skill/INSPECTION.md) の **B** を通し、パスするまで終わらない。

参照:

- 指揮者: [`../../runtime/loop-workflow/ORCHESTRATION.md`](../../runtime/loop-workflow/ORCHESTRATION.md)  
- 実行手段: [`../../runtime/loop-workflow/STAGE-EXEC.md`](../../runtime/loop-workflow/STAGE-EXEC.md)  
- 型選定: [`../author-loop-skill/patterns/SELECTING.md`](../author-loop-skill/patterns/SELECTING.md)  
- 検品: [`../author-loop-skill/INSPECTION.md`](../author-loop-skill/INSPECTION.md)  
- テンプレ: [`templates/workflow-skill.md`](templates/workflow-skill.md)  
- ランナー: `loop-workflow`

## 手順

### 1. ヒアリング（1問ずつ）

1. 最終成果は何か  
2. 自然な工程の切れ目（ユーザーの言葉で）  
3. 工程ごとの成功の見た目 — Verifier が検品に耐える具体さまで掘る  
4. 成果物の置き場  
5. 戻ってよいか（既定: 提案＋一言承認）  
6. ペルソナ（既定空。視点の指定が明示されたときだけ）  
7. スキル名・配置（既定: `~/.cursor/skills/<name>/`。このリポでは `skills/work/<name>/`）

実行手段のメニュー（スキルか loop-eng か）は出さない。指揮者が実作業しないことを確認する。

**完了:** 工程リスト・最終成果・各工程の Verifier 種がある。

### 2. 工程表＋実行手段を提案 → 一言承認

`STAGE-EXEC.md` に従う:

- skills ディレクトリから近いスキルを最大2–3候補→1つ推奨（**フォールバック型もセット**）、または loop-eng＋型  
- 平易な言い方。型名メニューは出さない  
- 表: 入力、出力、実行手段、型（loop-eng時）、フォールバック型（skill時推奨）、ペルソナ（空なら —）、Verifier、Stop（上限）
- スキル欠落時は loop-eng 代用（`STAGE-EXEC.md`）と明記されること

**完了:** 承認済み工程表。

### 3. 共有理解の確認

指揮者厳格・ゲートつなぎ・実行手段の扱いを確認する。

**完了:** 「作ってよい」の承認。

### 4. 生成

テンプレを埋め、`ORCHESTRATION.md` と `STAGE-EXEC.md` へのポインタを書く。  
`disable-model-invocation: true`。プレースホルダを残さない。

**完了:** ファイルがある（まだ完成と言わない）。

### 5. 検品（必須）

`INSPECTION.md` セクション **B**。落ちたら修正して B を再実行。

**完了:** B パス＋検品ログ用意。

### 6. 引き渡し

パスと検品ログを渡す。

## 完了基準（工場全体）

- [ ] セクション B 検品パス  
- [ ] 各工程に実行手段と具体 Verifier がある  
- [ ] スキル時は型省略可、loop-eng 時は型あり、が守られている  
- [ ] ペルソナ既定空  

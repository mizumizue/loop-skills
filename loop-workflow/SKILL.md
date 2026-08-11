---
name: loop-workflow
description: 複数工程のループをつないで回す。主エージェントは指揮者のみ。各工程は SubAgent が、スキルまたは loop-eng で回す。
disable-model-invocation: true
---

# ループワークフロー（複数工程）

工程ごとにループし、成果物でつなぐ。**指揮者は実作業しない。**

必読:

- [`ORCHESTRATION.md`](ORCHESTRATION.md) — 指揮者／作業者  
- [`STAGE-EXEC.md`](STAGE-EXEC.md) — 実行手段（スキル / loop-eng / ペルソナ空）  
- [`../author-loop-skill/patterns/SELECTING.md`](../author-loop-skill/patterns/SELECTING.md) — loop-eng 時の型選定  

## 先導語

- **kernel** — 各工程の Verifier / State / Stop / Leash  
- **leash** — 工程ゲートと編集境界  
- **conductor** — 指揮者（指示のみ）  

## 手順

### 1. ヒアリング（指揮者）

目的・成果物のイメージ・制約を聞く。質問は1つずつ。  
型名・スキル名・ペルソナのメニューは出さない。

**完了:** 最終成果が1文で言える。

### 2. 工程表を提案 → 一言承認（指揮者）

工程列を平易に示す。  
各工程の **実行手段**を `STAGE-EXEC.md` に従い提案（既存スキル探索→無ければ loop-eng＋型）。  
ペルソナは既定空。表には入力・出力・実行手段・型（loop-eng時）・Verifier・Stop を載せる。

**完了:** 工程表が承認済み。

### 3. 作業ディレクトリを用意（指揮者・メタのみ）

例: `workflow/<run-id>/plan.md`、各工程の `stage-N/`、ゲートログ。  
実作業ファイルの中身は書かない。

**完了:** パスが指示書に載る状態。

### 4. 工程ループ（指揮者 → 作業者）

各ターン開始前に `ORCHESTRATION.md` の毎ターン開始ゲートを通す。

各工程について:

1. 指示書を書く（実行手段、型または skill パス、フォールバック型、入力／出力、Verifier、Stop、Leash、ペルソナ空or指定）  
2. **SubAgent** を起動。作業者は指示書の実行手段に従う。skill が使えなければ `STAGE-EXEC.md` のフォールバックで loop-eng 代用  
3. 指揮者は成果物の中身を書かない。Verifier／完了報告だけ読む（代用した場合はログを確認）  
4. ゲート通過なら次へ。前提崩れなら戻る工程を提案し一言承認  
5. 違反時は `ORCHESTRATION.md` の手順  

**完了:** 最終工程ゲート通過、またはユーザー中断。

### 5. 締め（指揮者）

成果物パスと残リスクを短く報告する。

成果が微妙・失敗のあと工程をさかのぼるときは [`../loop-workflow-audit/SKILL.md`](../loop-workflow-audit/SKILL.md)（`/loop-workflow-audit`）。

## 完了基準

- [ ] 指揮者非実作業  
- [ ] 各工程に実行手段と Verifier ゲートがある  
- [ ] 実行手段・型はユーザーに選ばせず、提案→承認で決まっている  

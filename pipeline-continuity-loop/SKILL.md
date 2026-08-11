---
name: pipeline-continuity-loop
description: >-
  ForgOS 実証ループの工程間で Spine（manifest+visibility）の抜け落ちと gate-log 矛盾を機械検出。
  契約番兵。P56 skip 不可。X6 gate-log vs disk。overlay 部分再実行監視（X7）。
  実証ループの工程6・7直後および mode=all で起動。
disable-model-invocation: true
---

# 工程間連続性ループ（pipeline continuity）

単一工程 Verifier は **工程内** を見る。本スキルは **隣接工程の境界**で Spine（manifest＋visibility）と必須 RUN 成果物が **黙って落ちていないか**、および **gate-log 自己申告と実ファイルが矛盾していないか** を機械的に追跡する。**事後監査ではなく契約番兵**（blocking gate）。

型: **GV**（[`../author-loop-skill/patterns/GV.md`](../author-loop-skill/patterns/GV.md)）

**ルーブリック正本:** [`PAIR-RUBRIC.md`](PAIR-RUBRIC.md)

## 呼び出し

| 起動 | 人間との接点 |
|------|----------------|
| `forgos-validation-loop-workflow` の工程境界 | **なし** |
| ユーザー単体起動 | `STATE_DIR`（必須）と `mode` のみ |

## ペルソナ

既定は空。

## kernel

| 柱 | 内容 |
|----|------|
| Verifier | 実行ペアすべてで **X0–X7 Yes**（正当 skip 除く）。**黙落 0**。**P56 skip 不可**（`source-snapshot.md` 無しで Source 削除済みは fail） |
| State | `continuity-check.md`（最終稿）、`continuity-log.md`（各周） |
| Stop | 全ペア pass または正当 skip、または改稿 **最大 2 周**。2 周後も黙落・X6 矛盾なら未達記録で停止 |
| Leash | 読み取り: `STATE_DIR/`、`specs/`、`pbl/`、`issues/`、`product/`、`gate-log.md`。書き込み: `STATE_DIR/` の continuity 成果物のみ。上流／下流の **内容改変禁止** |

## 入力パラメータ

| パラメータ | 必須 | 内容 |
|------------|------|------|
| `STATE_DIR` | **必須** | `quality/fw-validation/runs/<run-id>/` |
| `mode` | 推奨 | `all`／`pair`／`strict`（P56+P67） |
| `pair` | `mode=pair` 時 | 例 `5→6` → P56 |
| `feature-slug` | 任意 | 未指定時は `scope.md` から |

## 手順

1. `STATE_DIR`・`mode` を固定。`overlay-version.md` を読む  
2. [`PAIR-RUBRIC.md`](PAIR-RUBRIC.md) の対象ペアを列挙  
3. **Spine checksum:** `scope.md` の manifest implement／deferred 件数・ID 列、visibility V-ID 列を数える  
4. **Extractor:** 各ペアで上流義務抽出→下流痕跡照合。判定: `carried`／`deferred_ok`／`silent_drop`／`channel_substitution`（issue AC が RUN ファイル代替＝黙落扱い）  
5. **X6 gate-log vs disk:** `gate-log.md` の Pass 宣言に載った必須パス（`implement-reachability.md`、`demo-seeded-check.md` 等）の **存在・行数・列**を検証  
6. **X7 overlay 再実行:** `gate-log` に overlay 再実行節があるとき、Spine 変更後に工程6–7 をスキップしていれば **fail**  
7. **narrowing-log:** `deferred_ok` は `narrowing-log.md` または上流採用表更新が伴うときのみ（P23）  
8. `continuity-check.md` を PAIR-RUBRIC テンプレで更新。不合格かつ周回 < 2 なら再読のみ（成果物は直さない）  
9. Stop でサマリ報告（pass/skip/fail、黙落件数、X6 矛盾、推奨戻し先）

## 指揮者向けゲート文

```text
skill:pipeline-continuity-loop 完了＝ゲート。
STATE_DIR=<RUN>。mode=pair。pair=5→6（P56）。
X0–X7 全 Yes。黙落 0。P56 skip 不可。X6 矛盾 0。
失敗時: PAIR-RUBRIC 戻し先。Promote 前は snapshot 無しで先へ進めない。
```

```text
skill:pipeline-continuity-loop 完了＝ゲート。STATE_DIR=<RUN>。mode=all。
P56・P67 が skip なら No。X6・X7 含む。
```

## 完了基準

- [ ] X0–X7 が実行ペアすべてで Yes（P56 正当 skip なし）  
- [ ] `continuity-check.md` にサマリ・Spine checksum・gate_vs_disk 表がある  
- [ ] 黙落 0、または Stop 上限で未達を `continuity-log.md` に記録  
- [ ] 成果物の内容改変をしていない  
- [ ] ユーザーへの途中確認なし  

## 他スキルとの関係

| 層 | 役割 |
|----|------|
| 工程内（V/S/U/P/M/I） | 単一成果物の品質 |
| **本スキル** | Spine の運搬・件数・必須 RUN ファイル・gate-log 矛盾 |
| Audit | 実装乖離（P89 通過後） |

両方＋X6 を通して初めて「契約どおり届いた」と言える。

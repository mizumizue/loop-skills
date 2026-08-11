---
name: demo-app-loop-workflow
description: 4層仕様（業態・業務・画面・システム）を整理し、技術選定・PoC・デモ実装・デモテスト・仕様適合検証・ホスト公開起動まで hands-off で回す個人用ワークフロー。
disable-model-invocation: true
---

# デモアプリ作成ループ（demo-app-loop-workflow）

テーマから **デモアプリケーション** を作る個人用ワークフロー。ForgOS パイプライン（`specs/` → `pbl/` → `product/`）は使わない。  
最終成果は `demo-runs/<run-id>/demo/` の動くデモ、4層仕様への適合検証記録、**ホストから開ける起動済み URL**。

**オーケストレータ（本スキル）:** 工程 Verifier・hands-off ルール・成果物パスは **ここと `SPEC-RUBRIC.md` にだけ**置く。

### hands-off（途中承認なし）

- 起動時にテーマが無くても、指揮者がテーマを **自ら選定**し工程1の入力に選定理由を載せる（途中でユーザーに聞かない）
- テーマが指定済みならそれを使い、確認質問を挟まない
- 業態・業務・画面・システムの採否は **AI が調査したうえで決定**し成果物に理由を残す
- 色・レイアウト・技術スタックを人間に聞かない（工程4・6が決める）
- 前提崩れの巻き戻しは Stop 上限内で指揮者が **自動決定**し `gate-log.md` に1行残す
- ユーザー向けに出すのは **起動時の任意テーマ**と **最終工程後の結果報告**（デモ URL 含む。および明示停止）だけ

### ループ・オーバーレイ

詳細ルーブリック: [`SPEC-RUBRIC.md`](SPEC-RUBRIC.md)（工程 Verifier から必ず参照。**甘い一般論は不合格**）。

- **4層仕様:** 業態 `sector-brief.md` · 業務 `business-spec.md` · 画面 `screen-spec.md` · システム `system-spec.md`
- **demo-grade:** 調査で **明示見送り** したもの以外は **すべて実装**（manifest の `implement` 行）
- **implementation manifest:** 工程5 `scope.md` の契約正本。issue AC の代替不可
- **技術選定:** 工程6で system-spec から最適スタックを選び、PoC で検証してから実装
- **デモテスト:** 工程8で manifest `implement` 行のスモーク／クリティカルパスを自動実行し、重大バグ 0 で Pass
- **仕様適合検証:** 工程9で4層それぞれに Pass/Fail。重大 Fail 0 で Pass
- **デモ起動・公開:** 工程10でデモを起動し、人間がブラウザで見られる URL を残す。WSL ではホスト側公開＋フォワーディング必須
- **単体テスト緑・`quality/`・Audit は不要:** 工程8はデモ向けスモーク／E2E のみ。単体カバレッジや Audit は成功条件に含めない

`STATE_DIR = demo-runs/<run-id>/`

主エージェントは **指揮者**。実作業は工程ごとの SubAgent。

- 指揮: 下記「指揮者ルール」（hands-off 上書きあり）
- 実行手段: 下記「実行手段ルール」
- スキル利用不可時は **loop-eng 代用**（フォールバック型 EO）

ペルソナ既定は空（工程表は `—`）。

## 指揮者ルール

| 役割 | 責務 |
|------|------|
| **指揮者**（主エージェント） | 指示書作成、ゲート判定、巻き戻し自動決定、ゲートログ |
| **作業者**（SubAgent） | 割り当てられた **1工程** のループ実作業のみ |

**硬規則:** 主エージェントが成果物の中身を直接書いた時点で失敗。

指揮者が触ってよいもの: 指示書・`gate-log.md`・空ディレクトリ作成。  
指揮者が触ってはいけないもの: 仕様・コード・検証結果の中身。

## 実行手段ルール

1. 工程表の **実行手段** に従う（`skill:<name>` または `loop-eng`）
2. `skill:` 利用時: プロジェクト `.cursor/skills/` または `~/.cursor/skills/` から `SKILL.md` を読む
3. スキル不可時: ゲートログに理由1行 → **フォールバック型 EO** で loop-eng 代用
4. `loop-eng`: EO 型（作る役と見直す役を分けて交互に直す）で1周＝生成→評価→修正

### 深さスキル（工程2–4 · 任意）

利用可能なら流用。出力ファイル名は本ワークフローに合わせる:

| スキル | 出力（`STATE_DIR` 配下） |
|--------|--------------------------|
| `sector-research-loop` | `sector-brief.md` |
| `spec-depth-loop` | `business-spec.md`（スキル既定は `spec-depth.md` → リネーム可） |
| `mock-design-loop` | `screen-spec.md`（スキル既定は `design-call.md` → リネーム可） |

指示書ではスキルの絶対パスと `STATE_DIR` を渡す。Verifier は `SPEC-RUBRIC.md` の該当節が正。

## 工程表

`RUN = demo-runs/<run-id>/`

| # | 工程 | 入力 | 出力 | 実行手段 | 型 | フォールバック型 | ペルソナ | Verifier（ゲート） | Stop（上限つき） |
|---|------|------|------|----------|----|------------------|----------|--------------------|------------------|
| 1 | テーマ／Run枠 | 指定テーマ、または指揮者選定テーマ | `RUN/scope.md`（初期）、`RUN/gate-log.md`、`RUN/` 枠 | `loop-eng` | `EO` | — | — | (1) scope 存在 (2) テーマ1文 (3) スコープ外≥1 (4) 通常利用形態 (5) システム狙い (6) `STATE_DIR=RUN` — すべて Yes | 再起草上限 3 |
| 2 | 業態調査 | 工程1のテーマ／システム狙い | `RUN/sector-brief.md`、`RUN/loop-log.md` | `skill:sector-research-loop` | — | `EO` | — | `sector-research-loop` 完了＝ゲート（V1–V6 全 Yes） | スキル Stop 上限 3／戻し工程1 上限 1 |
| 3 | 業務仕様 | `sector-brief.md`＋システム狙い | `RUN/business-spec.md` | `skill:spec-depth-loop` | — | `EO` | — | `spec-depth-loop` 完了＝ゲート（B1–B6 全 Yes） | スキル Stop 上限 3／戻し工程2 上限 1 |
| 4 | 画面設計 | `sector-brief.md`＋`business-spec.md` | `RUN/screen-spec.md` | `skill:mock-design-loop` | — | `EO` | — | `mock-design-loop` 完了＝ゲート（S1–S9 全 Yes） | スキル Stop 上限 3／戻し工程3 上限 1 |
| 5 | システム仕様統合 | 工程2–4成果＋工程1 scope | `RUN/system-spec.md`、`RUN/scope.md`（manifest 含む） | `loop-eng` | `EO` | — | — | [`SPEC-RUBRIC.md`](SPEC-RUBRIC.md) T1–T8 すべて Yes | 再起草上限 3 |
| 6 | 技術選定＋PoC | `system-spec.md`＋`scope.md` | `RUN/tech-stack.md`、`RUN/poc-check.md` | `loop-eng` | `EO` | — | — | K1–K5 全 Yes（`SPEC-RUBRIC.md` §技術選定） | 再選定上限 2／戻し工程5 上限 2 |
| 7 | デモ実装 | manifest＋`tech-stack.md`＋`screen-spec.md` | `RUN/demo/`、`RUN/implement-reachability.md` | `loop-eng` | `EO` | — | — | I1–I6 全 Yes（`SPEC-RUBRIC.md` §デモ実装） | 再実装上限 2 |
| 8 | デモテスト | `demo/`＋manifest＋`implement-reachability.md` | `RUN/test-check.md` | `loop-eng` | `EO` | — | — | Q1–Q5 全 Yes（`SPEC-RUBRIC.md` §デモテスト） | 修復上限 2／戻し工程7 上限 2 |
| 9 | 仕様適合検証 | 4層仕様＋`demo/`＋`test-check.md` | `RUN/conformance-check.md` | `loop-eng` | `EO` | — | — | F1–F4 全項目 Pass、重大 Fail＝0 | 修復上限 2／戻し工程7 上限 2 |
| 10 | デモ起動・公開 | `demo/`＋`tech-stack.md` | `RUN/demo-launch.md`（プロセス起動済み） | `loop-eng` | `EO` | — | — | L1–L5 全 Yes（`SPEC-RUBRIC.md` §デモ起動・公開） | 再起動上限 2 |
| 11 | Runログ | 工程1–10 | `RUN/run-log.md` | `loop-eng` | `EO` | — | — | run-log 存在、完了サマリ・成果物パス・ホスト向けデモ URL 記載 | 追記上限 2 |

- 実行手段: `skill:<name>` または `loop-eng`
- 型: loop-eng のとき必須。スキル時は `—`
- フォールバック型: skill のとき必須扱い
- ペルソナ: 既定 `—`
- Verifier: 曖昧な「品質確認」禁止。スキル時は「skill 完了＝ゲート」＋`SPEC-RUBRIC.md`

## つなぎ

- 前工程の Verifier 通過まで次へ進まない
- 引き継ぎは成果物パス＋短いメモ
- 前提崩れ時は戻る工程を **自動決定**（Stop 内）し `gate-log.md` に1行。ユーザー承認待ちにしない
- スキル利用不可時はゲートログに理由1行＋フォールバック型 EO で loop-eng 代用
- 巻き戻し早見は [`SPEC-RUBRIC.md`](SPEC-RUBRIC.md) §巻き戻し早見

## 手順（指揮者）

1. 最終成果の形を内部で固定する（`demo-runs/<run-id>/demo/` ＋ 4層仕様 ＋ `test-check.md` Pass ＋ `conformance-check.md` Pass ＋ `demo-launch.md` のホスト向け URL）。ユーザーへの事前確認はしない
2. **テーマ:** 指定があればそれを使う。無ければ指揮者が選定し、工程1入力に「選定テーマ＋理由」を載せる。ヒアリングしない
3. 工程表は本スキル既定で確定。実行手段の再提案・承認はしない
4. 対象プロジェクトに `demo-runs/<run-id>/` と `gate-log.md` 枠を用意する
5. 各工程: 指示書を書く（工程名、入出力、実行手段、Verifier、Stop、Leash、**`SPEC-RUBRIC.md` の該当節**）。工程2–4では対象スキルの絶対パス・`STATE_DIR=RUN`・hands-off を明示。**作業者 SubAgent のみ**が実作業
6. 指揮者は成果物の中身を書かない。ゲート判定・次へ／戻る／停止のみ
7. 工程のやり直しは同一 `RUN/` で可。別テーマの次 run は新しい `<run-id>` を切る
8. 工程11まで通したら、`demo/` パス・`test-check.md`／`conformance-check.md` 結果・**ホスト向けデモ URL**・`run-log.md` を報告して終了

## 完了基準

- [ ] 指揮者が実作業をしていない
- [ ] 途中でユーザー承認を求めていない（hands-off）
- [ ] 本 run が `demo-runs/<run-id>/` 上で行われた
- [ ] 全工程のゲートを `gate-log.md` に記録した（`SPEC-RUBRIC.md` の V/B/S/T/K/I/Q/F/L 含む）
- [ ] 工程8のデモテストで重大バグが 0
- [ ] 工程9の仕様適合検証で重大 Fail が 0
- [ ] 工程10でデモが起動済みで、ホスト向け URL が `demo-launch.md` と最終報告にある
- [ ] 最終成果物パス（`demo/`・4層仕様・`test-check.md`・`conformance-check.md`・`demo-launch.md`）を報告した

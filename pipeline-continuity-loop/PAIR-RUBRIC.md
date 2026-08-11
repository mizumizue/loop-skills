# 工程間連続性ルーブリック（Pair Rubric）

ForgOS 本体には書かない。`pipeline-continuity-loop` の **工程間** Yes/No 正本。  
単一工程の内部品質（V1–V6、S0–S8、U0–U7 等）は各工程スキル／`DEMO-UX.md` が担当。**ここは隣接工程の抜け落ちのみ**。

参照: ForgOS 側の `forgos-validation-loop-workflow/DEMO-UX.md`（本リポ外）§契約背骨・overlay ピン。

## ねらい

- **黙って落とす**を工程境界で検出する
- 見送りは **`deferred`＋根拠**、または **narrowing-log**／上流表更新が伴うときのみ `deferred_ok`
- issue AC・gate-log 自己申告は **Spine 成果物の代替にならない**
- ID・行数・ファイル存在で機械判定。一般論は No

## 契約背骨（Spine）

| 背骨 | 正本パス | 下流は **ID 参照の写像のみ** |
|------|----------|------------------------------|
| manifest | `scope.md` §implementation manifest 全行 | L3 UC、issue `Manifest:`、`implement-reachability.md` |
| visibility | `scope.md` §demo-seeded visibility 全 V-ID | issue AC の V-ID 参照、`demo-seeded-check.md` |

**P78 で issue AC に V-ID があっても、P89 で `demo-seeded-check.md` 欠落なら fail。**

## 用語

| 語 | 意味 |
|----|------|
| **上流義務** | Spine または閉じ込め対象（採用表・S8i 行等）から抽出する運搬対象 |
| **痕跡** | 下流での ID 一致、専用 RUN ファイルの行、checksum 一致 |
| **黙落** | 許可見送り記録も痕跡もない状態 |
| **チャネル代替** | issue AC／gate-log が RUN 必須成果物を置き換える誤判定（**常に No**） |

## 共通ルール（全ペア）

| ID | Yes の条件 |
|----|------------|
| **X0** | ペアの上流・下流成果物が両方存在。下流未着手は `skip`（黙落に含めない）。**P56 は Source 削除前のみ。`source-snapshot.md` あれば Source 不在でも可** |
| **X1** | 上流義務を抽出表に列挙（推測省略禁止） |
| **X2** | 各行が痕跡あり、または `deferred_ok`（`deferred`＋根拠、または `narrowing-log.md`／上流採用表更新） |
| **X3** | 黙落 **0 件** |
| **X4** | 下流のみの新規義務は逆流確認。意図なしは No |
| **X5** | 件数契約（下表）満たす |
| **X6** | `gate-log.md` の当該工程 Pass 宣言に載った **必須成果物パス**がディスク上に存在し、宣言行数・列スキーマと一致。矛盾は **fail** |
| **X7** | overlay 変更後の部分再実行で、Spine checksum（`source-snapshot.md` または `scope.md`）と下流が不一致なら **fail**（`gate-log` overlay 再実行節を参照） |

**不合格:** X3 No、件数違反、X6 矛盾、P56 skip（snapshot も無し）。

## RUN 必須成果物（工程9・X6 対象）

| パス | 行数／スキーマ |
|------|----------------|
| `implement-reachability.md` | 行数＝manifest `implement`。列: `cold_start`・シード根拠 |
| `demo-seeded-check.md` | 行数＝visibility 全 V-ID |
| `source-snapshot.md` | Promote 前。manifest implement／deferred／visibility の ID リスト＋件数 |
| `narrowing-log.md` | 部分採用時。`upstream_id`・縮小後・根拠パス |
| `overlay-version.md` | 工程1。ピンした DEMO-UX 版 |

### source-snapshot.md テンプレ

```markdown
# Source snapshot — <run-id>
- scope.md checksum 日: …
| 種別 | 件数 | ID 列（全件） |
|------|------|---------------|
| manifest implement | N | A-…, B-…, … |
| manifest deferred | N | … |
| visibility V-ID | N | V-…, … |
```

## ペア別

`RUN = quality/fw-validation/runs/<run-id>/`

### P12（1→2）— 初期 scope → sector brief

| 抽出 | 下流痕跡 | 件数 |
|------|----------|------|
| テーマ1文 | brief §領域 | 1 |
| システム狙い | brief 調査目的 | ≥1 |
| 通常利用形態 | 具体業態 | 1 |

### P23（brief → spec depth）

| 抽出 | 下流痕跡 | 件数 |
|------|----------|------|
| brief **採用** 行 | depth 採用 | 各行 trace または **narrowing-log** |
| brief **見送り** 行 | depth／scope 外 見送り | 見送り件数一致 |
| table stakes 採用 ≥1 | WF／概念 | ≥1 |
| 役 ≥2 | depth D1 | ≥2 |

**部分採用:** brief 採用のまま depth で見送り → `narrowing-log.md` または brief 表更新が無ければ **No**（X2）。

### P34（spec depth → design call）

| 抽出 | 下流痕跡 | 件数 |
|------|----------|------|
| 採用概念全件 | design-call 表面・ジャーニー | 採用全件 |
| WF ≥2 | ジャーニー J* | WF 数一致 |
| D3 採用境界 | design-call／manifest D 予定 | 採用全件 |
| 役数 | actor-split | 一致 |

### P45（design call → 統合 scope）

| 抽出 | 下流痕跡 | 件数 |
|------|----------|------|
| ジャーニー ID 全件 | manifest B ジャーニー列 | 全件 |
| 主表面 ≤3 | S2・S3 | 一致 |
| attention 各表面 | S5 | 表面数 |
| genre ≥3 | S7 | ≥3 |
| 起動時見せ項目 | visibility または manifest | 全件 |
| **採用／見送り表全行（S8i）** | implement／deferred／visibility／`narrative_only` | **表の全行** |

### P56（scope → Source）— **skip 禁止（snapshot 代替不可）**

| 抽出 | 下流痕跡 | 件数 |
|------|----------|------|
| manifest implement 全行 | Source manifest／UC／骨格 | implement 行数一致 |
| manifest deferred 全行 | Source 見送り＋根拠 | deferred 行数一致 |
| visibility 全行 | Source demo-seeded／manifest 参照 | V-ID 数一致 |
| S1 役全件 | Source actors | 役数一致 |
| S6 What ≥3 | Source usability what | ≥3 |

**Source 削除後:** `source-snapshot.md` と L3／promote-check の **checksum 一致**で代理可。snapshot 無しは **fail**（skip 不可）。

### P67（Source → L2/L3）

| 抽出 | 下流痕跡 | 件数 |
|------|----------|------|
| B implement 行 | `usecases/*.md` | 行数一致 |
| C・D implement 行 | decisions | 全件 |
| visibility 行数 | Source／manifest 紐づけ | 一致 |
| 採用概念・WF | glossary／decisions | 全件 |
| 見送り | out-of-scope | 全件 |
| How 非混入 | promote-check P4 | 0 |

### P78（L2/L3 → map／cut）

| 抽出 | 下流痕跡 | 件数 |
|------|----------|------|
| manifest implement 全行 | PBI／issue AC が **ID 参照**でカバー | 全件 |
| manifest A 全 actor | issue AC 参照 | 全件 |
| C・D implement | issue AC 参照 | 全件 |
| visibility 全 V-ID | PBI／issue AC **ID 参照**（M7） | 全件 |
| L3 UC 数 | issue ≥1 | UC 数 |

**注意:** P78 pass は **P89 の代替にならない**。issue AC は参照チャネル。

### P89（map／cut → Implement）

| 抽出 | 下流痕跡 | 件数 |
|------|----------|------|
| manifest implement | `implement-reachability.md` **ファイル存在**＋行数 | 一致 |
| manifest implement | `cold_start` 列・シード根拠列 | implement 行すべて Yes |
| visibility 全行 | `demo-seeded-check.md` **ファイル存在**＋行数 | 一致 |
| issue Manifest IDs | reachability 行と一致 | 全 ID |

## 出力テンプレ（`continuity-check.md`）

```markdown
# Continuity check — <run-id>

- STATE_DIR: …
- overlay-version: …
- モード: all | pair …

## サマリ
| ペア | 状態 | 上流義務数 | 黙落 | 許可見送り | gate_vs_disk |
|------|------|------------|------|------------|--------------|

## gate-log vs disk（X6）
| 工程 | gate-log 宣言 | パス | 存在 | 行数/スキーマ | 判定 |

## 黙落詳細
| ペア | 上流 ID | 期待下流 | 実際 |

## Spine checksum
| 種別 | scope | snapshot | 下流 | match |

## ペア別抽出表
### P56 …
| 上流 ID | 種別 | 下流痕跡 | 判定 |
```

## 指揮者接続

| タイミング | ペア | 失敗時戻し |
|------------|------|------------|
| 工程6完了後 | **P56**（必須） | 工程5 |
| snapshot 作成後 | — | Promote へ |
| 工程7完了後 | **P67** | 工程6 |
| 工程9着手前 | `all` | 該当工程 |
| 工程9完了後 | **P89** | 工程8 または 9 |

P56 が skip → **オーケストレータ Stop**（Promote 禁止）。

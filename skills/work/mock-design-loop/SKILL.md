---
name: mock-design-loop
description: actors・主表面・通例 UI から design call（視線・遷移・見た目）を深掘りし合格まで改稿する（本実装は書かない）。
disable-model-invocation: true
---

# モックデザインループ（mock design）

動く／整っているが汎用スキン止まり、を潰す。actors と主ジョブに沿った **design call**（視線優先・情報主従・画面遷移・見た目方針）を合格まで改稿する。`product/` の本実装や L2/L3 には進まない。

型: **EO**（詳細: [`../../meta/author-loop-skill/patterns/EO.md`](../../meta/author-loop-skill/patterns/EO.md)）

## 呼び出し

| 起動 | 人間との接点 |
|------|----------------|
| 上位オーケストレータの1工程 | **なし**。テーマ・`STATE_DIR`・入力パス・打ち切りは指示書に従う。判断はオーケストレータに任せる |
| ユーザーが単体起動 | 起動文の指示だけ使う。以降は確認しない。薄い項目は AI が決め、聞かない |

## ペルソナ

既定は空。付けない。

## kernel

| 柱 | 内容 |
|----|------|
| Verifier | `STATE_DIR/design-call.md` に対し、下表 **C1–C9 がすべて Yes** |
| State | `STATE_DIR/design-call.md`（最終稿）、`STATE_DIR/loop-log.md`（各周の Verifier）、必要なら `STATE_DIR/refs/`。`STATE_DIR` 未指定時は入力と同ディレクトリ、それも無ければ `research/<topic-slug>/`。実証ループから呼ばれたときは指示書の run 配下 |
| Stop | C1–C9 全 Yes、または改稿 **最大 3 周**。入力（sector brief と spec-depth、または指示書が渡す同等）が無い／読めないときは即停止し `loop-log.md` に理由。本実装へ進まない |
| Leash | 触ってよい: `STATE_DIR/`、入力 brief／spec-depth／指示書の読み取り、通例 UI の Web 参照。触るな: `specs/` `pbl/` `issues/` `product/` `agents/` への書き込み、C1–C9 の緩和・書き換え、起動後の色・好み確認、秘密情報の記載 |

### Verifier（C1–C9）

| ID | Yes の条件 |
|----|------------|
| C1 | sector brief と spec-depth（または同等）への参照がある |
| C2 | 主表面ごとに attention（視線優先）と情報の主従が理由付きである |
| C3 | 実プロダクト／通例 UI の参照が **2件以上**、借りる／借りないが分かる |
| C4 | 見た目要素が **3点以上** 具体である（抽象賛辞だけは No） |
| C5 | actor-split が表面方針に反映されている |
| C6 | デモでやる／やらない見た目の採用／見送りがある |
| C7 | 汎用スキン（どの領域にも見える既定 UI）だけで埋まっていない |
| C8 | 主要ジョブ ≥1 について、表面の遷移列（分岐・戻るを含む）が具体に書かれている |
| C9 | 遷移が actor-split／主表面方針と矛盾しない |

1つでも No なら不合格。Generator はルーブリックを書き換えない。

## 手順

1. 指示書または起動文から `STATE_DIR` と入力パスを固定する。入力が欠けていれば Stop（即停止）。ユーザーに聞かない  
2. Generator: 入力と通例 UI 参照から `design-call.md` を書く／直す。最低欄は主表面ごとの attention／主従、参照と借りる／借りない、見た目要素≥3、actor-split 反映、採用／見送り、主要ジョブの遷移列  
3. Evaluator: C1–C9 を Yes/No し、欠陥リストを `loop-log.md` に追記する  
4. 不合格かつ周回 < 3 なら欠陥だけを入力に手順2へ戻る  
5. Stop で止め、`STATE_DIR` と C 結果（または未達）を短く報告する。オーケストレータ配下なら指示書の戻り先のみ  

## 完了基準

- [ ] Verifier が Stop 条件を満たす（全 Yes、または 3 周打ち切り／入力欠落下の未達記録）  
- [ ] Leash を破っていない  
- [ ] State の場所を報告した  
- [ ] ユーザーへの途中確認をしていない（単体起動の起動文のみ例外）  

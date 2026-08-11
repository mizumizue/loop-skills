# EO — Evaluator–Optimizer

出典: Anthropic *Building Effective Agents* の evaluator-optimizer。作る側と評価する側を分離する。

## 1周

1. Generator が成果物を作る／直す  
2. Evaluator が明示基準で採点・欠陥リストを出す  
3. 不合格ならフィードバックを Generator に戻す  
4. 全基準クリアか回数上限で停止  

## kernel への写像

| 柱 | 典型 |
|----|------|
| Verifier | 評価ルーブリック（可能ならチェックリスト化）。理想は Generator と別コンテキスト |
| State | 草稿、評価メモ、版履歴 |
| Stop | 全項目パス、または max 周 |
| Leash | Generator がルーブリック自体を「楽な基準」に書き換えない |

## 向く目的

提案書・文章・デザインなど、テストしにくいが評価基準は書ける仕事。

## 注意

Evaluator をペルソナ演劇だけで済ませない。基準を先に文章化する。ペルソナは注意の向きのオプションに過ぎない。

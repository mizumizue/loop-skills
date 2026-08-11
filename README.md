# loop-skills

Cursor Agent Skills（ループの著者・実行・ドメイン作業）。

Licensed under the [MIT License](LICENSE).

## Layout

```
skills/
  meta/       # スキル／WFを書く工場
    author-loop-skill/
    author-loop-workflow/
  runtime/    # ループを回す基盤
    loop-engineering/
    loop-workflow/
  work/       # ドメインの実作業
    sector-research-loop/
    spec-depth-loop/
    mock-design-loop/
    demo-app-loop-workflow/

# install 先（どちらか）
~/.cursor/skills/<name>                 →  skills/{meta|runtime|work}/<name>
<path/to/workspace>/.cursor/skills/<name> →  同上
```

## Skills

### meta

| Skill | Role |
|-------|------|
| [`author-loop-skill`](skills/meta/author-loop-skill/) | 1工程ループスキルの生成 |
| [`author-loop-workflow`](skills/meta/author-loop-workflow/) | 複数工程ループワークフロースキルの生成 |

### runtime

| Skill | Role |
|-------|------|
| [`loop-engineering`](skills/runtime/loop-engineering/) | 1工程ループの実行ランナー |
| [`loop-workflow`](skills/runtime/loop-workflow/) | 複数工程の指揮・工程実行 |

### work

| Skill | Role |
|-------|------|
| [`sector-research-loop`](skills/work/sector-research-loop/) | 業態調査（sector brief） |
| [`spec-depth-loop`](skills/work/spec-depth-loop/) | 仕様深度メモ |
| [`mock-design-loop`](skills/work/mock-design-loop/) | design call（モック方針） |
| [`demo-app-loop-workflow`](skills/work/demo-app-loop-workflow/) | デモアプリ作成ワークフロー |

### Patterns（`skills/meta/author-loop-skill/patterns/`）

| ID | 出典メモ |
|----|----------|
| GV | Andrej Karpathy（Software 3.0 / autoresearch）系の写像 |
| RGR | Kent Beck の TDD |
| RALPH | Geoffrey Huntley の Ralph ループ系の写像 |
| EO | Anthropic *Building Effective Agents* の evaluator-optimizer 系の写像 |

## Install

このリポの `skills/` を、Cursor が読む場所へシンボリックリンクする（コピーしない）。

```bash
# 個人スキル（全プロジェクトで利用）— 既定
./scripts/link-skills.sh

# 明示的に個人 .cursor
./scripts/link-skills.sh ~/.cursor

# 特定ワークスペースだけ
./scripts/link-skills.sh /path/to/workspace
```

既存の同名ディレクトリがある場合は確認プロンプトが出る（`-f` で無確認置換）。既にシンボリックリンクなら差し替える。

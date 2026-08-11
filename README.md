# loop-skills

Cursor Agent Skills for authoring and running **loop** workflows (stage skills, orchestration, engineering helpers).

Licensed under the [MIT License](LICENSE).

## Skills

| Skill | Role |
|-------|------|
| [`author-loop-skill`](author-loop-skill/) | Author a single-stage loop skill (patterns, templates, inspection) |
| [`author-loop-workflow`](author-loop-workflow/) | Author a multi-stage loop workflow skill |
| [`loop-engineering`](loop-engineering/) | Engineering guidance for loop-based work |
| [`loop-workflow`](loop-workflow/) | Orchestration / stage-exec kernel for loop workflows |
| [`pipeline-continuity-loop`](pipeline-continuity-loop/) | Cross-stage continuity checks (Spine / gate-log) |

ForgOS-specific validation workflows stay in the ForgOS repo and are **not** included here.

## Install

Copy one or more skill folders into your personal or project skills directory:

```bash
# personal
cp -r author-loop-skill ~/.cursor/skills/

# project
cp -r author-loop-skill /path/to/project/.cursor/skills/
```

On Windows (PowerShell):

```powershell
Copy-Item -Recurse author-loop-skill "$env:USERPROFILE\.cursor\skills\"
```

## Source

Extracted from ForgOS workspace skills (`loop/` group), with path defaults adjusted for this standalone public repo.

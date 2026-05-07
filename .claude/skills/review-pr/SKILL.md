---
name: review-pr
description: Review a golem GitHub pull request for correctness, style, and compliance with contribution conventions.
---

Review a golem pull request. The PR number is provided as the argument (e.g. `/review-pr 1234`).

## Step 1 — Fetch the PR

```bash
gh pr view <NUMBER> --json number,title,body,headRefName,baseRefName,author,files,additions,deletions
gh pr diff <NUMBER>
```

Also fetch any linked issue if one is referenced in the PR body:

```bash
gh issue view <ISSUE_NUMBER>
```

## Step 2 — Check the PR metadata

Verify the following:

- **Target branch:** must be `master` (not `main` or a feature branch).
- **Issue reference:** the PR body must reference an issue (e.g. `#123` or `Fixes #123`). For simple typo fixes this is optional.
- **NEWS.md entry:** the PR body or description must include a NEWS.md category. Valid categories are:
  - `## New Functions`
  - `## New features`
  - `## Breaking changes`
  - `## Bug fix`
  - `## Internal changes`
- **Maintainer edits allowed:** check that the PR allows modification by maintainer (`maintainerCanModify: true`).

## Step 3 — Review the code changes

Read the diff carefully and check:

**Correctness**
- Does the code actually fix the referenced issue or implement the described feature?
- Are there edge cases that are not handled?
- Are there any obvious bugs introduced?

**golem conventions**
- New scaffold functions must produce output in `inst/shinyexample/` or use the appropriate `add_*` / `use_*` helpers in `R/`.
- Optional dependencies must be wrapped via the bootstrap pattern in `bootstrap_*.R` (no direct `library()` or hard-require of suggested packages).
- Dev-only helpers must be wrapped with `make_dev()` or use existing wrappers (`cat_dev()`, `print_dev()`, etc.).
- Configuration access must go through `get_golem_config()` / the YAML helpers, not by reading `inst/golem-config.yml` directly.
- New user-visible functions must follow the `snake_case` naming convention and be exported via `@export` roxygen tag.
- Module additions must use `add_module()` and respect the `mod_<name>.R` naming convention.

**Code style**
- Code must be formatted with `air`. If unformatted lines are present, flag them.
- No `library()` calls inside package functions.
- No hard-coded paths; use `system.file()` or `fs` helpers.

**Documentation**
- New exported functions must have roxygen2 documentation: `@title`, `@param`, `@return`, `@examples` (or `@noRd` for internals).
- If the PR adds or changes exported functions, `devtools::document()` must have been run (check that `.Rd` files and `NAMESPACE` are updated in the diff).

**Tests**
- New functionality should have corresponding tests in `tests/testthat/`.
- Tests should use `perform_inside_a_new_golem()` or `run_quietly_in_a_dummy_golem()` for isolation when they create files or golem projects.
- Snapshot tests (`expect_snapshot()`) are acceptable for output-heavy functions.

## Step 4 — Run checks locally (optional, if the branch is available)

If the branch can be checked out, run:

```bash
Rscript -e "devtools::test()"
Rscript -e "devtools::check()"
```

Report any failures.

## Step 5 — Write the review summary

Produce a structured review with these sections:

**Metadata**
- Target branch correct? (yes/no)
- Issue referenced? (yes/no, issue number)
- NEWS.md category present? (yes/no, category used)
- Maintainer edits allowed? (yes/no)

**Code review**
- Summary of what the PR does
- Issues found (list, or "none")
- Suggestions (list, or "none")

**Verdict**
One of:
- **Approve** — no blocking issues
- **Request changes** — list the blocking issues the author must fix
- **Comment** — observations only, no blocking issues but notable points

If requesting changes, be specific: reference file names, line numbers from the diff, and what needs to change.

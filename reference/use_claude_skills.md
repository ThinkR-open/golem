# Add Claude Skills to a golem Project

Add Claude Skills to a golem Project

## Usage

``` r
use_claude_skills(
  source = c("ask", "local", "remote"),
  skills = NULL,
  main_md_files = c("ask", "yes", "no"),
  overwrite = c("ask", "overwrite", "skip", "abort"),
  golem_wd = get_golem_wd(),
  interactive = rlang_is_interactive()
)
```

## Arguments

- source:

  Where to install agent skills from. Use `"ask"` for the interactive
  menu.

- skills:

  Skills to install. Use `NULL` for the interactive selector, or `"all"`
  to install all available skills.

- main_md_files:

  Whether to also add `AGENTS.md` / `CLAUDE.md`. Use `"ask"` for the
  interactive menu.

- overwrite:

  How to handle existing files. Use `"ask"` for the interactive menu.

- golem_wd:

  Path to the golem project where files should be copied.

- interactive:

  Whether `"ask"` values and `skills = NULL` should prompt. In
  non-interactive mode, those values use local defaults.

## Value

A list of selected options and copied paths, invisibly.

## See also

[`use_skills()`](https://thinkr-open.github.io/golem/reference/use_skills.md),
[`use_agent_implement()`](https://thinkr-open.github.io/golem/reference/use_agent_implement.md),
[`use_agent_skills()`](https://thinkr-open.github.io/golem/reference/use_agent_skills.md),
[`use_skill()`](https://thinkr-open.github.io/golem/reference/use_skill.md)

# Add a Single Skill to Installed Agent Specifications

Add a Single Skill to Installed Agent Specifications

## Usage

``` r
use_skill(
  name,
  source = NULL,
  overwrite = c("ask", "overwrite", "skip", "abort"),
  golem_wd = get_golem_wd(),
  interactive = rlang_is_interactive()
)
```

## Arguments

- name:

  Skill name to install.

- source:

  Where to install agent skills from. If `NULL`, prompt interactively;
  falls back to `"local"` in non-interactive mode.

- overwrite:

  How to handle existing files. Use `"ask"` for the interactive menu.

- golem_wd:

  Path to the golem project where files should be copied.

- interactive:

  Whether `"ask"` values and `source = NULL` should prompt. In
  non-interactive mode, those values use local defaults.

## Value

A list of selected options and copied paths, invisibly.

## See also

[`use_skills()`](https://thinkr-open.github.io/golem/reference/use_skills.md),
[`use_agent_implement()`](https://thinkr-open.github.io/golem/reference/use_agent_implement.md),
[`use_agent_skills()`](https://thinkr-open.github.io/golem/reference/use_agent_skills.md),
[`use_claude_skills()`](https://thinkr-open.github.io/golem/reference/use_claude_skills.md)

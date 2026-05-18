# Add Skills to a golem Project

Add Skills to a golem Project

## Usage

``` r
use_skills(
  source = c("ask", "local", "remote"),
  agent_specs = c("ask", "claude", "agents", "both"),
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

- agent_specs:

  Which agent specifications to install. Use `"ask"` for the interactive
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

## Variants

- `use_skills()` is the main entry point — pick the agent target via
  `agent_specs` (`"claude"`, `"agents"`, or `"both"`).

- [`use_agent_skills()`](https://thinkr-open.github.io/golem/reference/use_agent_skills.md)
  and
  [`use_claude_skills()`](https://thinkr-open.github.io/golem/reference/use_claude_skills.md)
  are convenience wrappers for `use_skills(agent_specs = "agents")` and
  `use_skills(agent_specs = "claude")`.

- [`use_skill()`](https://thinkr-open.github.io/golem/reference/use_skill.md)
  adds a single skill to an already-installed agent target, without
  touching `CLAUDE.md` / `AGENTS.md`.

## See also

[`use_agent_implement()`](https://thinkr-open.github.io/golem/reference/use_agent_implement.md),
[`use_agent_skills()`](https://thinkr-open.github.io/golem/reference/use_agent_skills.md),
[`use_claude_skills()`](https://thinkr-open.github.io/golem/reference/use_claude_skills.md),
[`use_skill()`](https://thinkr-open.github.io/golem/reference/use_skill.md)

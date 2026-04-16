test_that("normalize_agent_skills_argument() expands all and validates names", {
	expect_equal(
		normalize_agent_skills_argument(
			skills = "all",
			skills_available = c("a", "b")
		),
		c("a", "b")
	)

	expect_equal(
		normalize_agent_skills_argument(
			skills = c("a", "b"),
			skills_available = c("a", "b")
		),
		c("a", "b")
	)

	expect_error(
		normalize_agent_skills_argument(
			skills = c("a", "missing"),
			skills_available = c("a", "b")
		),
		"Unknown agent skill"
	)
})

test_that("get_agent_skill_source_dir() resolves local and remote layouts", {
	settings <- list(
		path = ".claude/skills",
		main_file_name = "CLAUDE.md"
	)
	legacy_manifest <- list()
	canonical_manifest <- list(skills_root = "skills")
	override_settings <- list(
		path = ".claude/skills",
		main_file_name = "CLAUDE.md",
		source_path = "plugins/claude/skills"
	)

	expect_equal(
		get_agent_skill_source_dir(
			source = "local",
			root = "/tmp/root",
			manifest = legacy_manifest,
			settings = settings,
			skill = "golem-upgrade"
		),
		"/tmp/root/skills/golem-upgrade"
	)

	expect_equal(
		get_agent_skill_source_dir(
			source = "remote",
			root = "/tmp/root",
			manifest = legacy_manifest,
			settings = settings,
			skill = "golem-upgrade"
		),
		"/tmp/root/.claude/skills/golem-upgrade"
	)

	expect_equal(
		get_agent_skill_source_dir(
			source = "remote",
			root = "/tmp/root",
			manifest = canonical_manifest,
			settings = settings,
			skill = "golem-upgrade"
		),
		"/tmp/root/skills/golem-upgrade"
	)

	expect_equal(
		get_agent_skill_source_dir(
			source = "remote",
			root = "/tmp/root",
			manifest = canonical_manifest,
			settings = override_settings,
			skill = "golem-upgrade"
		),
		"/tmp/root/plugins/claude/skills/golem-upgrade"
	)
})

test_that("normalize_agent_skills_specs() supports claude, agents and both", {
	expect_equal(
		normalize_agent_skills_specs(
			agent_specs = "agents",
			settings = list(agents = list(path = ".agents/skills"))
		),
		"agents"
	)

	expect_equal(
		normalize_agent_skills_specs(
			agent_specs = "both",
			settings = list(
				claude = list(path = ".claude/skills"),
				agents = list(path = ".agents/skills")
			)
		),
		c("claude", "agents")
	)
})

test_that("ask_agent_skills_main_files() returns yes, no and cancel", {
	settings <- list(
		claude = list(main_file_name = "CLAUDE.md"),
		agents = list(main_file_name = "AGENTS.md")
	)

	expect_true(
		testthat::with_mocked_bindings(
			utils_menu = function(...) "1",
			{
				ask_agent_skills_main_files(
					selected_agent_specs = "agents",
					settings = settings
				)
			}
		)
	)

	expect_false(
		testthat::with_mocked_bindings(
			utils_menu = function(...) "2",
			{
				ask_agent_skills_main_files(
					selected_agent_specs = c("claude", "agents"),
					settings = settings
				)
			}
		)
	)

	expect_null(
		testthat::with_mocked_bindings(
			utils_menu = function(...) "3",
			{
				ask_agent_skills_main_files(
					selected_agent_specs = "claude",
					settings = settings
				)
			}
		)
	)
})

test_that("normalize_agent_skills_main_files() supports ask, yes and no", {
	settings <- list(
		agents = list(main_file_name = "AGENTS.md")
	)

	expect_true(
		normalize_agent_skills_main_files(
			main_md_files = "yes",
			selected_agent_specs = "agents",
			settings = settings
		)
	)

	expect_false(
		normalize_agent_skills_main_files(
			main_md_files = "no",
			selected_agent_specs = "agents",
			settings = settings
		)
	)

	expect_true(
		testthat::with_mocked_bindings(
			ask_agent_skills_main_files = function(selected_agent_specs, settings) {
				TRUE
			},
			{
				normalize_agent_skills_main_files(
					main_md_files = "ask",
					selected_agent_specs = "agents",
					settings = settings
				)
			}
		)
	)
})

test_that("use_agent_implement() supports non-interactive skills and overwrite", {
	manifest <- list(
		skills_root = "skills",
		skills_available = c("skill-a", "skill-b"),
		targets = list(
			claude = list(
				path = ".claude/skills",
				main_file_name = "CLAUDE.md"
			),
			agents = list(
				path = ".agents/skills",
				main_file_name = "AGENTS.md"
			)
		)
	)

	result <- testthat::with_mocked_bindings(
		get_agent_skills_golem_root = function() {
			"/tmp/agent-skills"
		},
		get_agent_skills_golem_manifest = function(root) {
			manifest
		},
		ask_agent_skills_main_files = function(selected_agent_specs, settings) {
			TRUE
		},
		copy_agent_skills = function(
			source,
			root,
			manifest,
			settings,
			selected_agent_specs,
			skills,
			overwrite,
			golem_wd,
			copy_main_files
		) {
			list(
				selected_agent_specs = selected_agent_specs,
				skills = skills,
				copy_main_files = copy_main_files,
				targets = file.path(golem_wd, skills)
			)
		},
		{
			use_agent_implement(
				source = "local",
				agent_specs = "both",
				skills = "all",
				main_md_files = "yes",
				overwrite = "skip",
				golem_wd = "/tmp/project"
			)
		}
	)

	expect_equal(result$source, "local")
	expect_equal(result$selected_agent_specs, c("claude", "agents"))
	expect_equal(result$skills, c("skill-a", "skill-b"))
	expect_equal(result$overwrite, "skip")
	expect_equal(
		result$copied,
		list(
			selected_agent_specs = c("claude", "agents"),
			skills = c("skill-a", "skill-b"),
			copy_main_files = TRUE,
			targets = file.path("/tmp/project", c("skill-a", "skill-b"))
		)
	)
})

test_that("use_agent_implement() returns invisibly when specs selection is cancelled", {
	manifest <- list(
		skills_available = c("skill-a", "skill-b"),
		targets = list(
			claude = list(
				path = ".claude/skills",
				main_file_name = "CLAUDE.md"
			)
		)
	)

	result <- testthat::with_mocked_bindings(
		get_agent_skills_golem_root = function() {
			"/tmp/agent-skills"
		},
		get_agent_skills_golem_manifest = function(root) {
			manifest
		},
		ask_agent_skills_specs = function() {
			NULL
		},
		cli_alert_warning = function(...) NULL,
		{
			use_agent_implement(
				source = "local",
				agent_specs = "ask",
				main_md_files = "ask",
				golem_wd = "/tmp/project"
			)
		}
	)

	expect_null(result)
})

test_that("use_agent_implement() returns invisibly when main file selection is cancelled", {
	manifest <- list(
		skills_available = c("skill-a", "skill-b"),
		targets = list(
			claude = list(
				path = ".claude/skills",
				main_file_name = "CLAUDE.md"
			)
		)
	)

	result <- testthat::with_mocked_bindings(
		get_agent_skills_golem_root = function() {
			"/tmp/agent-skills"
		},
		get_agent_skills_golem_manifest = function(root) {
			manifest
		},
		ask_agent_skills_main_files = function(selected_agent_specs, settings) {
			NULL
		},
		cli_alert_warning = function(...) NULL,
		{
			use_agent_implement(
				source = "local",
				agent_specs = "claude",
				main_md_files = "ask",
				golem_wd = "/tmp/project"
			)
		}
	)

	expect_null(result)
})

test_that("use_agent_implement() defers remote archive fetch until after prompts", {
	events <- character()
	manifest <- list(
		skills_available = c("skill-a", "skill-b"),
		targets = list(
			claude = list(
				path = ".claude/skills",
				main_file_name = "CLAUDE.md"
			),
			agents = list(
				path = ".agents/skills",
				main_file_name = "AGENTS.md"
			)
		)
	)

	testthat::with_mocked_bindings(
		get_agent_skills_github_manifest = function() {
			events <<- c(events, "manifest")
			manifest
		},
		ask_agent_skills_specs = function() {
			events <<- c(events, "specs")
			"agents"
		},
		ask_agent_skills_main_files = function(selected_agent_specs, settings) {
			events <<- c(events, "main_md")
			FALSE
		},
		ask_agent_skills_selection = function(skills) {
			events <<- c(events, "skills")
			"skill-a"
		},
		get_agent_skills_golem_github = function() {
			events <<- c(events, "archive")
			list(
				root = "/tmp/agent-skills",
				cleanup = character()
			)
		},
		copy_agent_skills = function(...) {
			events <<- c(events, "copy")
			character()
		},
		{
			use_agent_implement(
				source = "remote",
				agent_specs = "ask",
				skills = NULL,
				main_md_files = "ask",
				overwrite = "skip",
				golem_wd = "/tmp/project"
			)
		}
	)

	expect_equal(
		events,
		c("manifest", "specs", "main_md", "skills", "archive", "copy")
	)
})

test_that("use_skill() fetches remote archive before reading remote manifest", {
	events <- character()
	manifest <- list(
		skills_available = "skill-a",
		targets = list(
			agents = list(
				path = ".agents/skills",
				main_file_name = "AGENTS.md"
			)
		)
	)

	testthat::with_mocked_bindings(
		get_agent_skills_golem_github = function() {
			events <<- c(events, "archive")
			list(
				root = "/tmp/agent-skills",
				cleanup = character()
			)
		},
		get_agent_skills_golem_manifest = function(root) {
			events <<- c(events, paste("manifest", root))
			manifest
		},
		get_installed_agent_skills_specs = function(golem_wd, settings) {
			events <<- c(events, "installed")
			"agents"
		},
		copy_agent_skills = function(...) {
			events <<- c(events, "copy")
			character()
		},
		{
			use_skill(
				name = "skill-a",
				source = "remote",
				overwrite = "skip",
				golem_wd = "/tmp/project"
			)
		}
	)

	expect_equal(
		events,
		c("archive", "manifest /tmp/agent-skills", "installed", "copy")
	)
})

test_that("wrappers forward the expected agent_specs", {
	expect_equal(
		testthat::with_mocked_bindings(
			use_agent_implement = function(
				source,
				agent_specs,
				skills,
				main_md_files,
				overwrite,
				golem_wd
			) {
				list(
					source = source,
					agent_specs = agent_specs,
					skills = skills,
					main_md_files = main_md_files,
					overwrite = overwrite,
					golem_wd = golem_wd
				)
			},
			{
				use_agent_skills(
					source = "local",
					skills = "skill-a",
					main_md_files = "no",
					overwrite = "skip",
					golem_wd = "/tmp/project"
				)
			}
		)$agent_specs,
		"agents"
	)

	expect_equal(
		testthat::with_mocked_bindings(
			use_agent_implement = function(
				source,
				agent_specs,
				skills,
				main_md_files,
				overwrite,
				golem_wd
			) {
				list(
					source = source,
					agent_specs = agent_specs,
					skills = skills,
					main_md_files = main_md_files,
					overwrite = overwrite,
					golem_wd = golem_wd
				)
			},
			{
				use_claude_skills(
					source = "remote",
					skills = "skill-a",
					main_md_files = "yes",
					overwrite = "overwrite",
					golem_wd = "/tmp/project"
				)
			}
		)$agent_specs,
		"claude"
	)

	expect_equal(
		testthat::with_mocked_bindings(
			use_agent_implement = function(
				source,
				agent_specs,
				skills,
				main_md_files,
				overwrite,
				golem_wd
			) {
				list(
					source = source,
					agent_specs = agent_specs,
					skills = skills,
					main_md_files = main_md_files,
					overwrite = overwrite,
					golem_wd = golem_wd
				)
			},
			{
				use_skills(
					source = "local",
					agent_specs = "both",
					skills = c("skill-a", "skill-b"),
					main_md_files = "ask",
					overwrite = "ask",
					golem_wd = "/tmp/project"
				)
			}
		)$agent_specs,
		"both"
	)
})

test_that("get_installed_agent_skills_specs() detects installed targets", {
	root <- tempfile("golem-agent-targets-")
	dir.create(root)
	dir.create(file.path(root, ".claude", "skills"), recursive = TRUE)
	dir.create(file.path(root, ".agents", "skills"), recursive = TRUE)

	settings <- list(
		claude = list(path = ".claude/skills"),
		agents = list(path = ".agents/skills")
	)

	expect_equal(
		get_installed_agent_skills_specs(
			golem_wd = root,
			settings = settings
		),
		c("claude", "agents")
	)

	expect_error(
		get_installed_agent_skills_specs(
			golem_wd = tempfile("golem-empty-"),
			settings = settings
		),
		"No installed agent specifications found"
	)
})

test_that("get_installed_agent_skills_specs() reports configured target paths", {
	settings <- list(
		claude = list(path = "custom/claude"),
		agents = list(path = "custom/agents")
	)

	expect_error(
		get_installed_agent_skills_specs(
			golem_wd = tempfile("golem-empty-"),
			settings = settings
		),
		"custom/claude.*custom/agents"
	)
})

test_that("use_skill() installs into pre-existing agent targets only", {
	manifest <- list(
		skills_root = "skills",
		skills_available = c("skill-a", "skill-b"),
		targets = list(
			claude = list(
				path = ".claude/skills",
				main_file_name = "CLAUDE.md"
			),
			agents = list(
				path = ".agents/skills",
				main_file_name = "AGENTS.md"
			)
		)
	)

	result <- testthat::with_mocked_bindings(
		get_agent_skills_golem_root = function() {
			"/tmp/agent-skills"
		},
		get_agent_skills_golem_manifest = function(root) {
			manifest
		},
		get_installed_agent_skills_specs = function(golem_wd, settings) {
			c("claude", "agents")
		},
		copy_agent_skills = function(
			source,
			root,
			manifest,
			settings,
			selected_agent_specs,
			skills,
			overwrite,
			golem_wd,
			copy_main_files
		) {
			list(
				selected_agent_specs = selected_agent_specs,
				skills = skills,
				copy_main_files = copy_main_files
			)
		},
		{
			use_skill(
				name = "skill-a",
				source = "local",
				overwrite = "skip",
				golem_wd = "/tmp/project"
			)
		}
	)

	expect_equal(result$agent_specs, c("claude", "agents"))
	expect_equal(result$skills, "skill-a")
	expect_equal(
		result$copied,
		list(
			selected_agent_specs = c("claude", "agents"),
			skills = "skill-a",
			copy_main_files = FALSE
		)
	)
})

test_that("use_skill() validates the requested skill name", {
	manifest <- list(
		skills_available = c("skill-a"),
		targets = list(
			claude = list(
				path = ".claude/skills",
				main_file_name = "CLAUDE.md"
			)
		)
	)

	expect_error(
		testthat::with_mocked_bindings(
			get_agent_skills_golem_root = function() {
				"/tmp/agent-skills"
			},
			get_agent_skills_golem_manifest = function(root) {
				manifest
			},
			get_installed_agent_skills_specs = function(golem_wd, settings) {
				"claude"
			},
			copy_agent_skills = function(...) {
				stop("should not copy")
			},
			{
				use_skill(
					name = "missing",
					source = "local",
					golem_wd = "/tmp/project"
				)
			}
		),
		"Unknown agent skill"
	)
})

test_that("copy_agent_skill_path() respects non-interactive overwrite modes", {
	source <- tempfile()
	target <- tempfile()
	file.create(source)
	file.create(target)

	expect_equal(
		testthat::with_mocked_bindings(
			fs_dir_create = function(...) NULL,
			fs_file_copy = function(...) stop("should not copy"),
			{
				copy_agent_skill_path(
					source = source,
					target = target,
					overwrite = "skip"
				)
			}
		),
		NA_character_
	)

	expect_error(
		testthat::with_mocked_bindings(
			fs_dir_create = function(...) NULL,
			fs_file_copy = function(...) NULL,
			{
				copy_agent_skill_path(
					source = source,
					target = target,
					overwrite = "abort"
				)
			}
		),
		"already exists"
	)

	expect_equal(
		testthat::with_mocked_bindings(
			fs_dir_create = function(...) NULL,
			fs_file_copy = function(...) NULL,
			ask_agent_skills_overwrite = function(target) {
				"skip"
			},
			{
				copy_agent_skill_path(
					source = source,
					target = target,
					overwrite = "ask"
				)
			}
		),
		NA_character_
	)

	expect_null(
		testthat::with_mocked_bindings(
			fs_dir_create = function(...) NULL,
			fs_file_copy = function(...) NULL,
			ask_agent_skills_overwrite = function(target) {
				"cancel"
			},
			cli_alert_warning = function(...) NULL,
			{
				copy_agent_skill_path(
					source = source,
					target = target,
					overwrite = "ask"
				)
			}
		)
	)
})

test_that("resolve_agent_skill_overwrite() resolves ask mode before copy", {
	target <- tempfile()
	file.create(target)

	resolved <- testthat::with_mocked_bindings(
		ask_agent_skills_overwrite = function(target) {
			"skip"
		},
		{
			resolve_agent_skill_overwrite(
				target = target,
				overwrite = "ask"
			)
		}
	)

	expect_equal(resolved, "skip")
})

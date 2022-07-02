test_that("config works", {
	with_dir(pkg, {
		# We'll try to be sure that
		# golem_wd: !expr golem::pkg_path()
		# is kept along the way
		expect_equal(
			tail(readLines("inst/golem-config.yml"), 1),
			"  golem_wd: !expr golem::pkg_path()"
		)
		expect_equal(
			get_golem_name(),
			fakename
		)
		expect_equal(
			get_golem_version(),
			"0.0.0.9000"
		)
		expect_equal(
			normalizePath(get_golem_wd(), mustWork = FALSE),
			normalizePath(pkg, mustWork = FALSE)
		)
		amend_golem_config(
			key = "where",
			value = "indev"
		)
		amend_golem_config(
			key = "where",
			value = "inprod",
			config = "production"
		)
		expect_equal(
			tail(readLines("inst/golem-config.yml"), 1),
			"  golem_wd: !expr golem::pkg_path()"
		)
		expect_equal(
			config::get("where", file = "inst/golem-config.yml"),
			"indev"
		)
		expect_equal(
			config::get("where", config = "production", file = "inst/golem-config.yml"),
			"inprod"
		)
		where_conf <- withr::with_envvar(
			c("R_CONFIG_ACTIVE" = "production"),
			{
				config::get("where", file = "inst/golem-config.yml")
			}
		)
		expect_equal(
			where_conf,
			"inprod"
		)
		set_golem_name("plop")
		expect_equal(
			get_golem_name(),
			"plop"
		)
		set_golem_name(fakename)
		set_golem_version("0.0.0.9001")
		expect_equal(
			get_golem_version(),
			"0.0.0.9001"
		)
		set_golem_version("0.0.0.9000")

		set_golem_wd(normalizePath("inst"))
		expect_equal(
			normalizePath(get_golem_wd()),
			normalizePath("inst")
		)
		set_golem_wd(pkg)
		# Be sure that after setting the stuff the wd is still here::here()
		expect_equal(
			tail(readLines("inst/golem-config.yml"), 1),
			"  golem_wd: !expr golem::pkg_path()"
		)
	})
})

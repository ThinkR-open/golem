test_that("add_expr_tag adds !expr tag correctly", {
	tag <- list(
		"some_expression"
	)
	result <- add_expr_tag(
		tag
	)
	expect_equal(
		attr(
			result[[1]],
			"tag"
		),
		"!expr"
	)
})

# Helper function to create temporary YAML files
create_temp_yaml <- function() {
	file.copy(
		golem_sys(
			"shinyexample/inst/golem-config.yml"
		),
		tmp <- tempfile(
			fileext = ".yml"
		)
	)
	return(
		tmp
	)
}
test_that("find_and_tag_exprs tags expressions correctly", {
	conf_path <- create_temp_yaml()

	# Run the function
	result <- find_and_tag_exprs(
		conf_path
	)

	# Check that expressions are tagged correctly
	expect_equal(
		attr(
			result$dev$golem_wd,
			"tag"
		),
		"!expr"
	)

	# Check that non-expressions remain unchanged
	expect_equal(
		result$production$app_prod,
		TRUE
	)

	# Clean up
	unlink(
		conf_path
	)
})

test_that("amend_golem_config works", {
	run_quietly_in_a_dummy_golem({
		amend_golem_config(
			"this",
			"that",
			config = "default",
			golem_wd = ".",
			talkative = FALSE
		)
		expect_equal(
			read_yaml(
				eval.expr = FALSE,
				file.path(
					"inst",
					"golem-config.yml"
				)
			)$default$this,
			"that"
		)
		amend_golem_config(
			"this",
			"that",
			config = "pif",
			golem_wd = ".",
			talkative = FALSE
		)

		expect_equal(
			read_yaml(
				eval.expr = FALSE,
				file.path(
					"inst",
					"golem-config.yml"
				)
			)$pif$this,
			"that"
		)
	})
})

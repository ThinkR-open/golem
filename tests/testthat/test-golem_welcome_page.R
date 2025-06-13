test_that("golem_welcome_page works", {
	html <- golem_welcome_page()

	expect_true(
		inherits(
			html,
			"shiny.tag.list"
		)
	)

	chr_html <- as.character(
		html
	)

	links_to_detect <- c(
		"https://golemverse.org/",
		"https://raw.githubusercontent.com/ThinkR-open/golem/master/inst/rstudio/templates/project/golem.png",
		"https://engineering-shiny.org/"
	)

	sapply(
		links_to_detect,
		function(x) {
			expect_true(
				grepl(
					x,
					chr_html
				)
			)
		}
	)
})

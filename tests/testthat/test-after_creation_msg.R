test_that("after_creation_msg works", {
	expect_snapshot({
		after_creation_message_js(
			"mypkg",
			"inst/app/www",
			"myjs"
		)
		after_creation_message_css(
			"mypkg",
			"inst/app/www",
			"mycss"
		)
		after_creation_message_html_template(
			"mypkg",
			"inst/app/www",
			"myhtml"
		)
		file_created_dance(
			"inst/app/www",
			after_creation_message_css,
			"mypkg",
			"inst/app/www",
			"mycss",
			open_file = FALSE
		)
		file_already_there_dance(
			"inst/app/www",
			open_file = FALSE
		)
	})
})

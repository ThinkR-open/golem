test_that("cats works", {
	expect_snapshot({
		cli_alert_success(
			"File downloaded at /tmp."
		)
		cli_alert_warning(
			"File not added (needs a valid directory)"
		)
		cli_alert_info(
			"File copied to /tmp"
		)
		cat_dir_necessary()
		cat_start_download()
		cat_downloaded(
			"/tmp"
		)
		cat_start_copy()
		cat_copied(
			"/tmp"
		)
		cat_created(
			"/tmp"
		)
		cat_automatically_linked()
	})
})

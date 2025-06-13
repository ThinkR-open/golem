test_that("cats works", {
	expect_snapshot({
		cat_green_tick(
			"File downloaded at /tmp"
		)
		cat_red_bullet(
			"File not added (needs a valid directory)"
		)
		cat_info(
			"File copied to /tmp"
		)
		cat_exists(
			"/tmp"
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

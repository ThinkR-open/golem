expect_installed <- function(pkg) {
	expect(
		rlang::is_installed(
			pkg
		),
		failure_message = paste0(
			"Package '",
			pkg,
			"' is not installed. Installed from ",
			getOption(
				"repos"
			)
		)
	)
}

test_that("install_dev_deps works", {
	withr::with_temp_libpaths({
		install_dev_deps(
			force_install = TRUE
		)
		for (pak in dev_deps) {
			expect_installed(
				pak
			)
		}
	})
})

test_that("check_dev_deps_are_installed works", {
	withr::with_temp_libpaths({
		testthat::with_mocked_bindings(
			rlang_is_installed = function(
				...
			) {
				return(
					FALSE
				)
			},
			{
				expect_message(
					check_dev_deps_are_installed()
				)
			}
		)
	})
})


dummy_golem <- tempfile(pattern = "test_is_existing_modules")
dummy_golem_R <- file.path(dummy_golem, "R/")
dir.create(dummy_golem_R, recursive = TRUE)
dummy_module_files <- c("mod_main.R", "mod_left_pane.R", "mod_pouet_pouet.R")
file.create(file.path(dummy_golem_R, dummy_module_files))

withr::with_dir(dummy_golem, {
  test_that("existing modules are properly detected", {
    expect_false(is_existing_module("foo"))
    expect_true(is_existing_module("left_pane"))
    expect_true(is_existing_module("main"))
    expect_true(is_existing_module("pouet_pouet"))
    expect_false(is_existing_module("plif_plif"))
  })
})
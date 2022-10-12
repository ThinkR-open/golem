test_that("add_dockerfiles_renv and add_dockerfile_with_renv_shinyproxy all output file are present", {
  skip_if_not_installed("renv")
  skip_if_not_installed("dockerfiler", "0.2.0")
  skip_if_not_installed("attachment", "0.2.5")
  with_dir(pkg, {
    for (fun in list(
      add_dockerfile_with_renv,
      add_dockerfile_with_renv_shinyproxy,
      add_dockerfile_with_renv_heroku
    )) {
      deploy_folder <- file.path(
        tempdir(),
        make.names(
          paste0(
            "deploy",
            round(
              runif(1, min = 0, max = 99999)
            )
          )
        )
      )

      fun(output_dir = deploy_folder, open = FALSE)

      expect_exists(file.path(deploy_folder, "Dockerfile"))
      expect_exists(file.path(deploy_folder, "Dockerfile_base"))
      expect_exists(file.path(deploy_folder, "README"))
      expect_exists(file.path(deploy_folder, "renv.lock.prod"))

      expect_length(list.files(path = deploy_folder, pattern = "tar.gz$"), 1)
      unlink(deploy_folder, force = TRUE, recursive = TRUE)
    }
  })
})

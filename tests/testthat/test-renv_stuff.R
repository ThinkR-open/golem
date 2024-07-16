test_that("add_dockerfiles_renv and add_dockerfile_with_renv_shinyproxy all output file are present", {
  skip_on_cran()
  skip_if_not_installed("renv")
  skip_if_not_installed("dockerfiler", "0.2.0")
  skip_if_not_installed("attachment", "0.2.5")

  options(  renv.config.snapshot.inference = FALSE)
  options(  renv.config.snapshot.validate = FALSE)
  with_dir(pkg, {
    for (fun in list(
      add_dockerfile_with_renv,
      add_dockerfile_with_renv_shinyproxy,
      add_dockerfile_with_renv_heroku
    )) {
      deploy_folder <- create_deploy_folder()
      desc::desc_set_authors(
        person(
          given = "colin",
          family = "fay",
          email = "contact@colinfay.me",
          role = c("aut", "cre"),
          comment = c(ORCID = "0000-0001-5879-4195")
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
test_that("suggested package are not in renv prod", {
  skip_on_cran()
  skip_if_not_installed("renv")
  skip_if_not_installed("dockerfiler", "0.2.0")
  skip_if_not_installed("attachment", "0.3.1")

  options(  renv.config.snapshot.inference = FALSE)
  options(  renv.config.snapshot.validate = FALSE)
  with_dir(
    pkg,
    {
      desc_file <- file.path("DESCRIPTION")
      desc_lines <- readLines(desc_file)
      # desc_lines <- c(desc_lines,"Suggests: \n    idontexist")
      desc_lines[desc_lines == "Suggests: "] <- "Suggests: \n    idontexist,"
      writeLines(desc_lines, desc_file)
      deploy_folder <- create_deploy_folder()
      desc::desc_set_authors(
        person(
          given = "colin",
          family = "fay",
          email = "contact@colinfay.me",
          role = c("aut", "cre"),
          comment = c(ORCID = "0000-0001-5879-4195")
        )
      )
      add_dockerfile_with_renv(output_dir = deploy_folder, open = FALSE)

      base <- paste(readLines(file.path(deploy_folder, "renv.lock.prod")), collapse = " ")
      expect_false(grepl(pattern = "idontexist", x = base))
      expect_true(grepl(pattern = "shiny", x = base))

      unlink(deploy_folder, force = TRUE, recursive = TRUE)
    }
  )
})

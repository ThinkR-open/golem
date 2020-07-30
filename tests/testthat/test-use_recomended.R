test_that("test use_recommended_deps",{
  with_dir(pkg,{
    use_recommended_deps()
    packages <- c('shiny', 'DT', 'attempt', 'glue', 'golem', 'htmltools')
    deps <- desc::desc_get_deps(file = "DESCRIPTION")
    expect_true(
      all(
        as.logical(
        lapply(packages,
                function(.x){.x %in% deps$package}
                )
          
      )
    ))
  })
    
    
    
})


test_that("test use_recommended_tests",{
  with_dir(pkg,{
    use_recommended_tests(spellcheck = FALSE)
    expect_true(dir.exists("tests"))
    expect_exists("tests/testthat/test-golem-recommended.R")
  })
})

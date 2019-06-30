context("tests use_recomended functions")

test_that("test use_recommended_deps",{
  with_dir(pkg,{
    use_recommended_deps()
    packages <- c('shiny', 'DT', 'attempt', 'glue', 'golem', 'htmltools')
    desc <- readLines("DESCRIPTION")
    start <- grep("Imports:", desc) + 1
    desc <- desc[start:length(desc)] 
    test <- all(purrr::map_lgl(packages,function(x){any(grepl(x,desc))}))
    expect_true(test)
  })
})


test_that("test use_recommended_tests",{
  with_dir(pkg,{
    expect_warning(use_recommended_tests())
    expect_true(dir.exists("tests"))
    expect_true(file.exists("tests/testthat/test-golem-recommended.R"))
  })
})

context("tests dev function")

test_that("test app_dev",{
  with_options(
    c(
      golem.app.prod = TRUE
    ),{
    expect_false(app_dev()) 
    expect_true(app_prod()) 
  })
  with_options(
    c(
      golem.app.prod = FALSE
    ),{
    expect_true(app_dev()) 
    expect_false(app_prod()) 
  })
})

test_that("test print_dev",{
  with_options(
    c(
      golem.app.prod = FALSE
    ),{
    expect_equal(print_dev("test"),"test")
    expect_is(print_dev("test"), "character")
  })
})

test_that("test make_dev",{
  with_options(
    c(
      golem.app.prod = FALSE
    ),{
    sum_dev <- make_dev(sum)
    class(sum_dev)
    expect_equal(sum_dev(1,2),3)
    expect_is(sum_dev(1,2), "numeric")
    expect_is(sum_dev, "function")
  })
})

test_that("test print_dev",{
  with_options(
    c(
      golem.app.prod = FALSE
    ),{
    expect_equal(print_dev("test"),"test")
    expect_is(print_dev("test"), "character")
  })
})


test_that("test browser_button",{
 
    output <- capture_output_lines(browser_button())
    expect_true(
      grepl('actionButton\\("browser", "browser"\\)', output[2])
    )
    expect_true(
      grepl('tags\\$script\\(\"\\$\\(\'#browser\'\\).hide\\(\\);\"\\)', output[3])
    )
    expect_true(
      grepl('observeEvent\\(input\\$browser', output[6])
    )
    expect_true(
      grepl('  browser()', output[7])
    )
    expect_true(
      grepl('run \\$\\(\'#browser\'\\)\\.show\\(\\);', output[12])
    )
})

# test_that("test set_option",{
#   with_dir(pkg,{
#   set_golem_options()
#   expect_equal(getOption("golem.pkg.name"), fakename)
#   # expect_equal(getOption("golem.pkg.version"), "0.0.0.9000")
#   expect_equal(getOption("golem.app.prod"), FALSE)
#   })
# })

context("tests dev function")

test_that("test app_dev",{
  with_dir(pkg,{
    
    options(golem.app.prod = TRUE)
    expect_false(app_dev()) 
    
    options(golem.app.prod = FALSE)
    expect_true(app_dev()) 
  })
})

test_that("test print_dev",{
  with_dir(pkg,{
    options(golem.app.prod = FALSE)
    expect_equal(print_dev("test"),"test")
    expect_is(print_dev("test"), "character")
  })
})

test_that("test make_dev",{
  with_dir(pkg,{
    options(golem.app.prod = FALSE)
    sum_dev <- make_dev(sum)
    class(sum_dev)
    expect_equal(sum_dev(1,2),3)
    expect_is(sum_dev(1,2), "numeric")
    expect_is(sum_dev, "function")
  })
})

test_that("test print_dev",{
  with_dir(pkg,{
    options(golem.app.prod = FALSE)
    expect_equal(print_dev("test"),"test")
    expect_is(print_dev("test"), "character")
  })
})
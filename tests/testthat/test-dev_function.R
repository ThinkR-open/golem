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

# test_that("test print_dev",{
#   with_dir(pkg,{
#     options(golem.app.prod = FALSE)
#     expect_equal(print_dev("test"),"test")
#     expect_is(print_dev("test"), "character")
#   })
# })
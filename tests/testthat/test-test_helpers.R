test_that("test expect_shinytag", {
  with_dir(pkg, {
    expect_equal(capture_output(expect_shinytag(favicon("jean"))), "")
    expect_error(expect_shinytag("pierre"))
  })
})

test_that("test expect_shinytaglist", {
  with_dir(pkg, {
    expect_equal(capture_output(expect_shinytaglist(shiny::tagList())), "")
    expect_error(expect_shinytaglist("test"))
  })
})

# test_that("test expect_shinytaglist", {
#   with_dir(pkg, {
#     skip_if_not(interactive())
#     ui <- shiny::h1("Jean")
#     expect_html_equal(ui)
#     expect_html_equal(ui)
#   })
# })
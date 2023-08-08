test_that("Test with_red_star works", {
  expect_s3_class(with_red_star("golem"), "shiny.tag")
  expect_equal(
    as.character(with_red_star("Enter your name here")),
    '<span>Enter your name here<span style="color:red">*</span></span>'
  )
})

test_that("Test list_to_li works", {
  expect_s3_class(list_to_li(c("a", "b")), "shiny.tag.list")
  expect_equal(
    as.character(list_to_li(c("a", "b"))),
    "<li>a</li>\n<li>b</li>"
  )
  expect_equal(
    as.character(list_to_li(c("a", "b"), class = "my_li")),
    '<li class="my_li">a</li>\n<li class="my_li">b</li>'
  )
})

test_that("Test list_to_p works", {
  expect_s3_class(
    list_to_p(c(
      "This is the first paragraph",
      "this is the second paragraph"
    )),
    "shiny.tag.list"
  )
  expect_equal(
    as.character(
      list_to_p(c(
        "This is the first paragraph",
        "this is the second paragraph"
      ))
    ),
    "<p>This is the first paragraph</p>\n<p>this is the second paragraph</p>"
  )
  expect_equal(
    as.character(
      list_to_p(
        c(
          "This is the first paragraph",
          "this is the second paragraph"
        ),
        class = "my_li"
      )
    ),
    '<p class="my_li">This is the first paragraph</p>\n<p class="my_li">this is the second paragraph</p>'
  )
})

test_that("Test named_to_li works", {
  expect_s3_class(named_to_li(list(a = "a", b = "b")), "shiny.tag.list")
  expect_equal(
    as.character(named_to_li(list(a = "a", b = "b"))),
    "<li><b>a:</b> a</li>\n<li><b>b:</b> b</li>"
  )
  expect_equal(
    as.character(named_to_li(list(a = "a", b = "b"), class = "mylist")),
    '<li class="mylist"><b>a:</b> a</li>\n<li class="mylist"><b>b:</b> b</li>'
  )
})

test_that("Test tagRemoveAttributes works", {
  a_with_tag <- shiny::tags$p(src = "plop", "pouet")
  expect_s3_class(a_with_tag, "shiny.tag")
  expect_equal(
    as.character(a_with_tag),
    '<p src="plop">pouet</p>'
  )

  a_without_tag <- tagRemoveAttributes(a_with_tag, "src")
  expect_s3_class(a_without_tag, "shiny.tag")
  expect_equal(
    as.character(a_without_tag),
    "<p>pouet</p>"
  )
})

test_that("Test undisplay works", {
  a <- shiny::tags$p(src = "plop", "pouet")
  expect_s3_class(a, "shiny.tag")
  expect_equal(
    as.character(a),
    '<p src="plop">pouet</p>'
  )
  a_undisplay <- undisplay(a)
  expect_s3_class(a_undisplay, "shiny.tag")
  expect_equal(
    as.character(a_undisplay),
    '<p src="plop" style="display: none;">pouet</p>'
  )

  b <- shiny::actionButton("go_filter", "go")
  expect_s3_class(b, "shiny.tag")
  expect_equal(
    as.character(b),
    '<button id="go_filter" type="button" class="btn btn-default action-button">go</button>'
  )
  b_undisplay <- undisplay(b)
  expect_s3_class(b, "shiny.tag")
  expect_equal(
    as.character(b_undisplay),
    '<button id="go_filter" type="button" class="btn btn-default action-button" style="display: none;">go</button>'
  )

  c <- shiny::tags$p(src = "plop", style = "some_style", "pouet")
  expect_s3_class(c, "shiny.tag")
  expect_equal(
    as.character(c),
    '<p src="plop" style="some_style">pouet</p>'
  )
  c_undisplay <- undisplay(c)
  expect_s3_class(c_undisplay, "shiny.tag")
  expect_equal(
    as.character(c_undisplay),
    '<p src="plop" style="display: none; some_style">pouet</p>'
  )
})

test_that("Test display works", {
  a_undisplay <- shiny::tags$p(src = "plop", "pouet", style = "display: none;")
  expect_s3_class(a_undisplay, "shiny.tag")
  expect_equal(
    as.character(a_undisplay),
    '<p src="plop" style="display: none;">pouet</p>'
  )
  a_display <- display(a_undisplay)
  expect_s3_class(a_display, "shiny.tag")
  expect_equal(
    as.character(a_display),
    '<p src="plop" style="">pouet</p>'
  )
})

test_that("Test jq_hide works", {
  expect_s3_class(jq_hide("golem"), "shiny.tag")
  expect_equal(
    as.character(jq_hide("golem")),
    "<script>$('#golem').hide()</script>"
  )
})

test_that("Test rep_br works", {
  expect_s3_class(rep_br(5), "html")
  expect_equal(
    as.character(rep_br(5)),
    "<br/> <br/> <br/> <br/> <br/>"
  )
})

test_that("Test enurl works", {
  expect_s3_class(enurl("https://www.thinkr.fr", "ThinkR"), "shiny.tag")
  expect_equal(
    as.character(enurl("https://www.thinkr.fr", "ThinkR")),
    '<a href="https://www.thinkr.fr">ThinkR</a>'
  )
})

test_that("Test columns wrappers works", {
  expect_s3_class(col_12(), "shiny.tag")
  expect_s3_class(col_10(), "shiny.tag")
  expect_s3_class(col_8(), "shiny.tag")
  expect_s3_class(col_6(), "shiny.tag")
  expect_s3_class(col_4(), "shiny.tag")
  expect_s3_class(col_3(), "shiny.tag")
  expect_s3_class(col_2(), "shiny.tag")
  expect_s3_class(col_1(), "shiny.tag")

  expect_equal(as.character(col_12()), '<div class="col-sm-12"></div>')
  expect_equal(as.character(col_10()), '<div class="col-sm-10"></div>')
  expect_equal(as.character(col_8()), '<div class="col-sm-8"></div>')
  expect_equal(as.character(col_6()), '<div class="col-sm-6"></div>')
  expect_equal(as.character(col_4()), '<div class="col-sm-4"></div>')
  expect_equal(as.character(col_3()), '<div class="col-sm-3"></div>')
  expect_equal(as.character(col_2()), '<div class="col-sm-2"></div>')
  expect_equal(as.character(col_1()), '<div class="col-sm-1"></div>')
})

test_that("Test make_action_button works", {
  tmp_tag <- a(href = "#", "My super link", style = "color: lightblue;")
  button <- make_action_button(
    tmp_tag,
    inputId = "mylink"
  )
  expect_s3_class(button, "shiny.tag")
  expect_equal(
    as.character(button),
    '<a href="#" style="color: lightblue;" id="mylink" class="action-button">My super link</a>'
  )
  expect_error(
    button_2 <- make_action_button(
      unclass(tmp_tag),
      inputId = "mylink_2"
    )
  )
  expect_error(
    button_3 <- make_action_button(
      button,
      inputId = "mylink_3"
    )
  )
  expect_error(
    button_4 <- make_action_button(
      tmp_tag,
      inputId = NULL
    )
  )
  tmp_tag_2 <- tmp_tag
  tmp_tag_2$attribs$id <- "id_already_present"
  expect_warning(
    button_5 <- make_action_button(
      tmp_tag_2,
      inputId = "mylink_5"
    )
  )
  tmp_tag_3 <- tmp_tag
  tmp_tag_3$attribs$class <- "class_already_present"
  button_6 <- make_action_button(
    tmp_tag_3,
    inputId = "someID"
  )
})

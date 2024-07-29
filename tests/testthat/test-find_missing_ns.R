test_that("check is_shiny_input_output_funmodule works", {
  expect_true(
    all(
      is_shiny_input_output_funmodule(
        text = c(
          "textInput",
          "textOutput",
          "actionButton",
          "mod_test_module_ui"
        )
      )
    )
  )

  expect_true(
    all(
      is_shiny_input_output_funmodule(
        text = c(
          "textInput",
          "textOutput",
          "actionButton",
          "mod_test_module_ui",
          "sk_select_input"
        ),
        extend_input_output_funmodule = "sk_select_input"
      )
    )
  )

  expect_false(
    all(
      is_shiny_input_output_funmodule(
        text = c(
          "textInput",
          "textOutput",
          "mod_test_module"
        )
      )
    )
  )
})

test_that("Check check_namespace_in_file", {
  path <- tempfile(fileext = ".R")

  writeLines(
    c(
      "mod_test_module_ui <- function(id) {",
      "  ns <- NS(id)",
      "  tagList(",
      "    selectInput(",
      "      inputId = 'selectinput',", # Missing NS
      "      label = 'Select input',",
      "      choices = c(LETTERS[1:10])",
      "    ),",
      "    actionButton(",
      "      inputId = 'actionbutton',", # Missing NS
      "      label = 'Action button'",
      "    )",
      "  )",
      "}",
      "",
      "mod_test_module_server <- function(id) {",
      "  observeEvent(input$actionbutton, {",
      "    message(input$actionbutton)",
      "    message(input$selectinput)",
      "  })",
      "}"
    ),
    con = path
  )

  expect_equal(
    check_namespace_in_file(
      path = path,
    ),
    structure(
      list(
        line1 = c(4L, 9L),
        col1 = c(5L, 5L),
        line2 = c(4L, 9L),
        col2 = 15:16,
        id = c(32L, 89L),
        parent = c(34L, 91L),
        token = c(
          "SYMBOL_FUNCTION_CALL",
          "SYMBOL_FUNCTION_CALL"
        ),
        terminal = c(TRUE, TRUE),
        text = c(
          "selectInput",
          "actionButton"
        ),
        path = rep(path, 2),
        is_input_output_funmodule = c(TRUE, TRUE),
        next_line1 = c(
          5L,
          10L
        ),
        next_line2 = c(5L, 10L),
        next_col1 = c(17L, 17L),
        next_col2 = 29:30,
        next_text = c(
          "'selectinput'",
          "'actionbutton'"
        ),
        is_followed_by_ns = c(FALSE, FALSE)
      ),
      row.names = c(NA, -2L),
      class = "data.frame"
    ),
    ignore_attr = TRUE
  )

  writeLines(
    c(
      "mod_test_module_ui <- function(id) {",
      "  ns <- NS(id)",
      "  tagList(",
      "    selectInput(",
      "      inputId = ns('selectinput'),", # NS present
      "      label = 'Select input',",
      "      choices = c(LETTERS[1:10])",
      "    ),",
      "    actionButton(",
      "      inputId = ns('actionbutton'),", # NS present
      "      label = 'Action button'",
      "    )",
      "  )",
      "}",
      "",
      "mod_test_module_server <- function(id) {",
      "  observeEvent(input$actionbutton, {",
      "    message(input$actionbutton)",
      "    message(input$selectinput)",
      "  })",
      "}"
    ),
    con = path
  )

  expect_equal(
    check_namespace_in_file(
      path = path,
    ),
    structure(
      list(
        line1 = c(4L, 9L),
        col1 = c(5L, 5L),
        line2 = c(4L, 9L),
        col2 = 15:16,
        id = c(32L, 97L),
        parent = c(34L, 99L),
        token = c(
          "SYMBOL_FUNCTION_CALL",
          "SYMBOL_FUNCTION_CALL"
        ),
        terminal = c(TRUE, TRUE),
        text = c(
          "selectInput",
          "actionButton"
        ),
        path = rep(path, 2),
        is_input_output_funmodule = c(TRUE, TRUE),
        next_line1 = c(5L, 10L),
        next_line2 = c(5L, 10L),
        next_col1 = c(17L, 17L),
        next_col2 = c(18L, 18L),
        next_text = c("ns", "ns"),
        is_followed_by_ns = c(TRUE, TRUE)
      ),
      row.names = c(NA, -2L),
      class = "data.frame"
    ),
    ignore_attr = TRUE
  )

  writeLines(
    c(
      "mod_test_module_ui <- function(id) {",
      "  ns <- NS(id)",
      "  tagList(",
      "    sk_select_input(",
      "      inputId = 'selectinput',", # missing NS with custom fun
      "      label = 'Select input',",
      "      choices = c(LETTERS[1:10])",
      "    ),",
      "    mod_test_2_module_ui(",
      "      id = ns('actionbutton')", # NS present
      "    )",
      "  )",
      "}",
      "",
      "mod_test_module_server <- function(id) {",
      "  observeEvent(input$actionbutton, {",
      "    message(input$actionbutton)",
      "    message(input$selectinput)",
      "  })",
      "}"
    ),
    con = path
  )

  expect_equal(
    check_namespace_in_file(
      path = path
    ),
    structure(
      list(
        line1 = 9L,
        col1 = 5L,
        line2 = 9L,
        col2 = 24L,
        id = 89L,
        parent = 91L,
        token = "SYMBOL_FUNCTION_CALL",
        terminal = TRUE,
        text = "mod_test_2_module_ui",
        path = path,
        is_input_output_funmodule = TRUE,
        next_line1 = 10L,
        next_line2 = 10L,
        next_col1 = 12L,
        next_col2 = 13L,
        next_text = "ns",
        is_followed_by_ns = TRUE
      ),
      row.names = c(NA, -1L),
      class = "data.frame"
    ),
    ignore_attr = TRUE
  )

  expect_equal(
    check_namespace_in_file(
      path = path,
      extend_input_output_funmodule = "sk_select_input"
    ),
    structure(
      list(
        line1 = c(4L, 9L),
        col1 = c(5L, 5L),
        line2 = c(4L, 9L),
        col2 = c(19L, 24L),
        id = c(32L, 89L),
        parent = c(34L, 91L),
        token = c(
          "SYMBOL_FUNCTION_CALL",
          "SYMBOL_FUNCTION_CALL"
        ),
        terminal = c(TRUE, TRUE),
        text = c(
          "sk_select_input",
          "mod_test_2_module_ui"
        ),
        path = rep(path, 2),
        is_input_output_funmodule = c(TRUE, TRUE),
        next_line1 = c(5L, 10L),
        next_line2 = c(5L, 10L),
        next_col1 = c(17L, 12L),
        next_col2 = c(29L, 13L),
        next_text = c(
          "'selectinput'",
          "ns"
        ), is_followed_by_ns = c(FALSE, TRUE)
      ),
      row.names = c(NA, -2L),
      class = "data.frame"
    ),
    ignore_attr = TRUE
  )
})

dummy_dir_check_ns <- tempfile(pattern = "dummy")
dir.create(dummy_dir_check_ns)

withr::with_dir(dummy_dir_check_ns, {
  test_that("golem is created and properly populated", {
    dummy_golem_path <- file.path(dummy_dir_check_ns, "checkns")
    create_golem(dummy_golem_path, open = FALSE)

    expect_message(
      checkns <- check_namespace_sanity(
        pkg = dummy_golem_path
      ),
      "No shiny module found"
    )

    expect_false(checkns)

    file.create(
      file.path(dummy_golem_path, "R", "mod_test_module.R")
    )

    writeLines(
      c(
        "#' first UI Function",
        "#'",
        "#' @description A shiny Module.",
        "#'",
        "#' @param id,input,output,session Internal parameters for {shiny}.",
        "#'",
        "#' @shinyModule A Golem module.",
        "#'",
        "#' @importFrom shiny NS tagList",
        "mod_test_module_ui <- function(id) {",
        "  ns <- NS(id)",
        "  tagList(",
        "    selectInput(",
        "      inputId = ns('selectinput'),",
        "      label = 'Select input',",
        "      choices = c(LETTERS[1:10])",
        "    ),",
        "    actionButton(",
        "      inputId = ns('actionbutton'),",
        "      label = 'Action button'",
        "    )",
        "  )",
        "}",
        "",
        "#' first Server Functions",
        "#'",
        "mod_test_module_server <- function(id) {",
        "  moduleServer(id, function(input, output, session) {",
        "    ns <- session$ns",
        "",
        "    observeEvent(input$actionbutton, {",
        "      message(input$actionbutton)",
        "      message(input$selectinput)",
        "    })",
        "  })",
        "}"
      ),
      con = file.path(dummy_golem_path, "R", "mod_test_module.R")
    )

    devtools::document(pkg = dummy_golem_path)

    expect_message(
      checkns <- check_namespace_sanity(
        pkg = dummy_golem_path
      ),
      "NS check passed"
    )

    expect_true(checkns)

    writeLines(
      c(
        "#' first UI Function",
        "#'",
        "#' @description A shiny Module.",
        "#'",
        "#' @param id,input,output,session Internal parameters for {shiny}.",
        "#'",
        "#' @shinyModule A Golem module.",
        "#'",
        "#' @importFrom shiny NS tagList",
        "mod_test_module_ui <- function(id) {",
        "  ns <- NS(id)",
        "  tagList(",
        "    selectInput(",
        "      inputId = 'selectinput',",
        "      label = 'Select input',",
        "      choices = c(LETTERS[1:10])",
        "    ),",
        "    actionButton(",
        "      inputId = ns('actionbutton'),",
        "      label = 'Action button'",
        "    )",
        "  )",
        "}",
        "",
        "#' first Server Functions",
        "#'",
        "mod_test_module_server <- function(id) {",
        "  moduleServer(id, function(input, output, session) {",
        "    ns <- session$ns",
        "",
        "    observeEvent(input$actionbutton, {",
        "      message(input$actionbutton)",
        "      message(input$selectinput)",
        "    })",
        "  })",
        "}"
      ),
      con = file.path(dummy_golem_path, "R", "mod_test_module.R")
    )

    expect_message(
      checkns <- check_namespace_sanity(
        pkg = dummy_golem_path,
        auto_fix = TRUE
      ),
      "It seems that..."
    )

    expect_true(checkns)

    expect_message(
      checkns <- check_namespace_sanity(
        pkg = dummy_golem_path
      ),
      "NS check passed"
    )
  })
})

after_creation_message_generic <- function(
  golem_wd,
  dir,
  name
) {
  do_if_unquiet({
    cli_cat_bullet(
      sprintf(
        "File %s created",
        name
      )
    )
  })
}

after_creation_message_js <- function(
  golem_wd,
  dir,
  name
) {
  if (desc_exist(golem_wd)) {
    if (
      fs_path_abs(dir) != fs_path_abs("inst/app/www") &
        utils::packageVersion("golem") < "0.2.0"
    ) {
      cat_red_bullet(
        sprintf(
          'To link to this file, go to the `golem_add_external_resources()` function in `app_ui.R` and add `tags$script(src="www/%s.js")`',
          name
        )
      )
    } else {
      cat_automatically_linked()
    }
  }
}
after_creation_message_css <- function(
  golem_wd,
  dir,
  name
) {
  if (desc_exist(golem_wd)) {
    if (
      fs_path_abs(dir) != fs_path_abs("inst/app/www") &
        utils::packageVersion("golem") < "0.2.0"
    ) {
      cat_red_bullet(
        sprintf(
          'To link to this file,  go to the `golem_add_external_resources()` function in `app_ui.R` and add `tags$link(rel="stylesheet", type="text/css", href="www/.css")`',
          name
        )
      )
    } else {
      cat_automatically_linked()
    }
  }
}

after_creation_message_sass <- function(
  golem_wd,
  dir,
  name
) {
  if (desc_exist(golem_wd)) {
    if (
      fs_path_abs(dir) != fs_path_abs("inst/app/www") &
        utils::packageVersion("golem") < "0.2.0"
    ) {
      cat_red_bullet(
        sprintf(
          'After compile your Sass file, to link your css file, go to the `golem_add_external_resources()` function in `app_ui.R` and add `tags$link(rel="stylesheet", type="text/css", href="www/.css")`'
        )
      )
    }
  }
}

after_creation_message_html_template <- function(
  golem_wd,
  dir,
  name
) {
  do_if_unquiet({
    cli_cat_line("")
    cli_cat_line(
      "To use this html file as a template, add the following code in your UI:"
    )
    cli_cat_line(crayon_darkgrey("htmlTemplate("))
    cli_cat_line(crayon_darkgrey(sprintf(
      '    app_sys("app/www/%s.html"),',
      file_path_sans_ext(name)
    )))
    cli_cat_line(crayon_darkgrey("    body = tagList()"))
    cli_cat_line(crayon_darkgrey("    # add here other template arguments"))
    cli_cat_line(crayon_darkgrey(")"))
  })
}

after_creation_message_any_file <- function(
  golem_wd,
  dir,
  name
) {
  do_if_unquiet({
    cli_cat_line("")
    cli_cat_line(
      sprintf(
        "File downloaded at %s",
        fs_path_abs(
          fs_path(
            dir,
            name
          )
        )
      )
    )
  })
}

file_created_dance <- function(
  where,
  fun,
  golem_wd,
  dir,
  name,
  open_file,
  catfun = cat_created
) {
  catfun(where)

  fun(golem_wd, dir, basename(where))

  open_or_go_to(
    where = where,
    open_file = open_file
  )
}

file_already_there_dance <- function(
  where,
  open_file
) {
  cat_green_tick("File already exists.")
  open_or_go_to(
    where = where,
    open_file = open_file
  )
}

cli_abort_dir_create <- function(){
  cli_cli_abort(
    "The dir_create argument is deprecated."
  )
}
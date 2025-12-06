# Add Golem options to a Shiny App

You'll probably never have to write this function as it is included in
the golem template created on launch.

## Usage

``` r
with_golem_options(
  app,
  golem_opts,
  maintenance_page = golem::maintenance_page,
  print = FALSE
)
```

## Arguments

- app:

  the app object.

- golem_opts:

  A list of options to be added to the app

- maintenance_page:

  an html_document or a shiny tag list. Default is golem template.

- print:

  Whether or not to print the app. Default is to `FALSE`, which should
  be what you need 99.99% of the time. In case you need to actively
  print() the app object, you can set it to `TRUE`.

## Value

a shiny.appObj object

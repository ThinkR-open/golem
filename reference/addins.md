# `{golem}` addins

`insert_ns()` takes a selected character vector and wrap it in `ns()`
The series of `go_to_*()` addins help you go to common files used in
developing a `{golem}` application.

## Usage

``` r
insert_ns()

go_to_start(golem_wd = golem::get_golem_wd(), wd)

go_to_dev(golem_wd = golem::get_golem_wd(), wd)

go_to_deploy(golem_wd = golem::get_golem_wd(), wd)

go_to_run_dev(golem_wd = golem::get_golem_wd(), wd)

go_to_app_ui(golem_wd = golem::get_golem_wd(), wd)

go_to_app_server(golem_wd = golem::get_golem_wd(), wd)

go_to_run_app(golem_wd = golem::get_golem_wd(), wd)
```

## Arguments

- golem_wd:

  The working directory of the `{golem}` application.

- wd:

  Deperecated. Use `golem_wd` instead.

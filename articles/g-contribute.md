# 07. Contribute to Golem

Golem is an open-source project, and we welcome contributions of all
kinds.

## Contributing to Golem

Development of {golem} happens on GitHub. You can contribute to the
package in several ways:

- **Reporting issues**: If you find a bug, please file a minimal
  reproducible example on
  [GitHub](https://github.com/ThinkR-open/golem/issues) with a clear
  description of the issue.

- **Contributing code**: If you want to contribute code, please open a
  pull request on [GitHub](https://github.com/ThinkR-open/golem/pulls).

- **Documentation**: If you find a typo or error in the documentation,
  please open a pull request on
  [GitHub](https://github.com/ThinkR-open/golem/pulls).

- **Ideas**: If you have an idea for a new feature, please open an issue
  on [GitHub](https://github.com/ThinkR-open/golem/issues) to discuss
  it.

Any contribution is welcome!

## Note for the contributors

If you want to contribute to the package, please note that the package
is structured as follows:

- The main functions are in the `R/` folder.

- The tests are in the `tests/` folder.

- The documentation is in the `man/` folder.

- The vignettes are in the `vignettes/` folder.

- The Golem template app is in the `inst/shinyexample/` folder.

## Code style

Golem is formatted with [`air`](https://posit-dev.github.io/air/).
Please make sure to format your code with `air` before contributing to
the package.

To format the whole package from the command line, run:

``` sh
air format .
```

`air` integrates with RStudio and VSCode; see the [air editor setup
documentation](https://posit-dev.github.io/air/editors.html) to enable
format-on-save in your editor.

The repository also ships a pre-commit hook that runs `air format`
automatically (see `.pre-commit-config.yaml`).

## Actual state of the package

The package is in active development. The actual state of the check for
`master` is available on [GitHub
Actions](https://github.com/ThinkR-open/golem/actions/workflows/R-CMD-check.yaml).

Please make sure that your contribution does not break the package. You
can run the checks locally by running the following code:

``` r

devtools::check()
```

## Code of Conduct

Please note that this project is released with a [Contributor Code of
Conduct](https://www.contributor-covenant.org/version/1/0/0/code-of-conduct.html).
By participating in this project you agree to abide by its terms.

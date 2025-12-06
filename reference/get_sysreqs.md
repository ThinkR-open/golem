# Get system requirements (Deprecated)

This function is now deprecated, and was moved to `{dockerfiler}`.

## Usage

``` r
get_sysreqs(packages, quiet = TRUE, batch_n = 30)
```

## Arguments

- packages:

  character vector. Packages names.

- quiet:

  Boolean. If `TRUE` the function is quiet.

- batch_n:

  numeric. Number of simultaneous packages to ask.

## Value

A vector of system requirements.

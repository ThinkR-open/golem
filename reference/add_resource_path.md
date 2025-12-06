# Add resource path

Add resource path

## Usage

``` r
add_resource_path(prefix, directoryPath, warn_empty = FALSE)
```

## Arguments

- prefix:

  The URL prefix (without slashes). Valid characters are a-z, A-Z, 0-9,
  hyphen, period, and underscore. For example, a value of 'foo' means
  that any request paths that begin with '/foo' will be mapped to the
  given directory.

- directoryPath:

  The directory that contains the static resources to be served.

- warn_empty:

  Boolean. Default is `FALSE`. If TRUE display message if directory is
  empty.

## Value

Used for side effects.

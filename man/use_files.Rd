% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/use_files_external.R, R/use_files_internal.R
\name{use_external_js_file}
\alias{use_external_js_file}
\alias{use_external_css_file}
\alias{use_external_html_template}
\alias{use_external_file}
\alias{use_internal_js_file}
\alias{use_internal_css_file}
\alias{use_internal_html_template}
\alias{use_internal_file}
\title{Use Files}
\usage{
use_external_js_file(
  url,
  name = NULL,
  golem_wd = get_golem_wd(),
  dir = "inst/app/www",
  open = FALSE,
  dir_create,
  pkg
)

use_external_css_file(
  url,
  name = NULL,
  golem_wd = get_golem_wd(),
  dir = "inst/app/www",
  open = FALSE,
  dir_create,
  pkg
)

use_external_html_template(
  url,
  name = "template.html",
  golem_wd = get_golem_wd(),
  dir = "inst/app/www",
  open = FALSE,
  dir_create,
  pkg
)

use_external_file(
  url,
  name = NULL,
  golem_wd = get_golem_wd(),
  dir = "inst/app/www",
  open = FALSE,
  dir_create,
  pkg
)

use_internal_js_file(
  path,
  name = NULL,
  golem_wd = get_golem_wd(),
  dir = "inst/app/www",
  open = FALSE,
  dir_create,
  pkg
)

use_internal_css_file(
  path,
  name = NULL,
  golem_wd = get_golem_wd(),
  dir = "inst/app/www",
  open = FALSE,
  dir_create,
  pkg
)

use_internal_html_template(
  path,
  name = "template.html",
  golem_wd = get_golem_wd(),
  dir = "inst/app/www",
  open = FALSE,
  dir_create,
  pkg
)

use_internal_file(
  path,
  name = NULL,
  golem_wd = get_golem_wd(),
  dir = "inst/app/www",
  open = FALSE,
  dir_create,
  pkg
)
}
\arguments{
\item{url}{String representation of URL for the file to be downloaded}

\item{name}{The name of the module.}

\item{golem_wd}{Path to the root of the package. Default is \code{get_golem_wd()}.}

\item{dir}{Path to the dir where the file while be created.}

\item{open}{Should the created file be opened?}

\item{dir_create}{Creates the directory if it doesn't exist, default is \code{TRUE}.}

\item{pkg}{Deprecated, please use golem_wd instead}

\item{path}{String representation of the local path for the file to be implemented (use_file only)}
}
\value{
The path to the file, invisibly.
}
\description{
These functions download files from external sources and put them inside the \code{inst/app/www} directory.
The \code{use_internal_} functions will copy internal files, while \code{use_external_} will try to download them
from a remote location.
}
\note{
See \code{?htmltools::htmlTemplate} and \verb{https://shiny.rstudio.com/articles/templates.html}
for more information about \code{htmlTemplate}.
}

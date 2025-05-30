% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/use_favicon.R
\name{use_favicon}
\alias{use_favicon}
\alias{remove_favicon}
\alias{favicon}
\title{Add a favicon to your shinyapp}
\usage{
use_favicon(path, golem_wd = get_golem_wd(), method = "curl", pkg)

remove_favicon(path = "inst/app/www/favicon.ico")

favicon(
  ico = "favicon",
  rel = "shortcut icon",
  resources_path = "www",
  ext = "ico"
)
}
\arguments{
\item{path}{Path to your favicon file (.ico or .png)}

\item{golem_wd}{Path to the root of the package. Default is \code{get_golem_wd()}.}

\item{method}{Method to be used for downloading files, 'curl' is default see \code{\link[utils:download.file]{utils::download.file()}}.}

\item{pkg}{Deprecated, please use golem_wd instead}

\item{ico}{path to favicon file}

\item{rel}{rel}

\item{resources_path}{prefix of the resource path of the app}

\item{ext}{the extension of the favicon}
}
\value{
Used for side-effects.

An HTML tag.
}
\description{
This function adds the favicon from \code{ico} to your shiny app.
}
\examples{
if (interactive()) {
  use_favicon()
  use_favicon(path = "path/to/your/favicon.ico")
}
}

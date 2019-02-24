#' Create a proper Dockerfile 
#' 
#' build a container containing your shiny app
#'
#' @param path path to DESCRIPTION file
#' @param output path to Dockerfile
#'
#' @export
#'
#' @examples
#' \dontrun{
#' gen_dockerfile()
#' }
gen_dockerfile <- function(path="DESCRIPTION",output="Dockerfile"){
docker <- c(
glue::glue("FROM rocker/tidyverse:{major}.{minor}",major= R.Version()$major,minor= R.Version()$minor),
glue::glue('RUN R -e "install.packages(\'remotes\')"'),
glue::glue('RUN R -e "remotes::install_cran(\'{hop}\')"',
hop =att_from_description(path = path)),
glue::glue("COPY {read.dcf(path)[1]}_*.tar.gz  /app.tar.gz"),
"RUN R -e \"install.packages('/app.tar.gz', repos = NULL, type = 'source')\"",

"EXPOSE 3838",
glue::glue("CMD [\"R\", \"-e options('shiny.port'=3838,shiny.host='0.0.0.0');{read.dcf(path)[1]}::run_app()\"]"))
docker <- paste(docker,collapse = " \n")
cat(docker,file=output)
cat_bullet(glue::glue("Be sure to put your {read.dcf(path)[1]}_{read.dcf('DESCRIPTION')[1,][['Version']]}.tar.gz file (generated using devtool::build() ) in the same folder as the {basename(output)} file generated"))
usethis::use_build_ignore(files = output)

invisible(output)
}

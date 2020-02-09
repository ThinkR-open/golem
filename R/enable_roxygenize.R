
#' Enable documentation generation using roxygen2
#'
#' @param path to to Rproj file 
#'
#' @export
#'
enable_roxygenize <- function(path = list.files(path = ".",pattern = "Rproj$",full.names = TRUE)){
  cat_bullet(
    glue::glue("Read {basename(path)} content "), 
    bullet = "info",
    bullet_col = "green"
  )
  source <- lapply(path, yaml::read_yaml)
  cat_bullet(
    "Enable roxygen2", 
    bullet = "info",
    bullet_col = "green"
  )
  out <- lapply(source,function(x){
    x[["PackageRoxygenize"]]<- "rd,collate,namespace"
    x
  })

  mapply(yaml::write_yaml, out, path)
  cat_green_tick("Done") 
}

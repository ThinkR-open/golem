#' Add run_dev by module
#' 
#' Allow you to create one run_dev by module
#'
#' @param name name of the script
#' @param module_ui name of the module UI
#' @param module_server name of the module server
#' @param ... add parameters to your module_server. They have to be a string like param = "'jean'"
#' @param pkg path to package
#' @param open boolean open the file
#'
#' @export
#'
#' @examples
#' 
#' \dontrun{
#' add_run_dev_module("ok", 
#'                mod_ok_ui,
#'                mod_ok_server, 
#'                r= "reactiveValues(message = 'ok')", 
#'                message = "'have to be string'")
#' }
add_run_dev_module <- function(name,
                           module_ui,
                           module_server, 
                           ...,
                           pkg = get_golem_wd(),
                           open = TRUE
                           ){
  
  old <- setwd(normalizePath(pkg))
  on.exit(setwd(old))
  
  list_param <- list(...)
  
  if(!all(lapply(list_param, is.character))){
    stop("parameters must be character.")
  }
  
  path_dev <- file.path(pkg,'dev')
  
  where <- file.path(
    path_dev, paste0("run_dev_", name, ".R"))
  
    if ( !check_file_exist(where) ) {
      return(invisible(FALSE))
    } 
  
    file.create(where)
    
    write_there <- function(x){
      write(x = x, file = where, append = TRUE)
    }
    glue <- function(x){
      glue::glue(x , .open = "%", .close = "%")
    }
    write_there(glue("# Run dev module %name%"))
    write_there("")
    write_there("options(golem.app.prod = FALSE)")
    write_there("")
    write_there("golem::detach_all_attached()")
    write_there("")
    write_there("golem::document_and_reload()")
    write_there("")
 
    mod_ui <- deparse(substitute(module_ui))
    mod_server <- deparse(substitute(module_server))
    param <- paste(names(list_param),paste(list_param), sep = " = ", collapse = ",")
    
    ui <- glue("app_ui <- function(request) { 
                    %mod_ui%(id = 'run_dev')
               }"
    )
    if(param == ""){
    server <- glue(
      "app_server <- function(input, output, session) {
            callModule(%mod_server%, 'run_dev')}"
    )
    }else{
      server <- glue(
        "app_server <- function(input, output, session) {
            callModule(%mod_server%, 'run_dev', %param%)}"
      )
    }
    write_there("")
    write_there(ui)
    write_there("")
    write_there("")
    write_there(server)
    write_there("")
    write_there("")
    write_there("shinyApp(ui = app_ui, server = app_server)") 
    
    if ( open & rstudioapi::isAvailable() ) { 
      rstudioapi::navigateToFile(file = where)
    }
}

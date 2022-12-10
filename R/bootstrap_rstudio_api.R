check_rstudioapi_installed <- function(reason = "to manipulate RStudio files.") {
  rlang::check_installed(
    "rstudioapi",
    reason = reason
  )
}


rstudioapi_navigateToFile <- function(output){
    # Don't suggest to install
    if (rlang::is_installed("rstudioapi")){
        if (
            rstudioapi::isAvailable() &
            rstudioapi::hasFun("navigateToFile")
        ) {
        rstudioapi::navigateToFile(output)
      } else {
        try(file.edit(output))
      }
    } else {
        try(file.edit(output))
    }

}

rstudioapi_hasFun <- function(
    fun
){
    # Default to FALSE so that it's FALSE
    # If package is not installed
    hasFun <- FALSE
    if (rlang::is_installed("rstudioapi")){
        hasFun <- rstudioapi::hasFun(fun)
    }
    hasFun
}

rstudioapi_getSourceEditorContext <- function(){
    check_rstudioapi_installed()
    rstudioapi::getSourceEditorContext()
}

rstudioapi_modifyRange <- function(
    location = NULL,
    text = NULL,
    id = NULL
){
  check_rstudioapi_installed()
    rstudioapi::modifyRange(
        location = location,
        text = text,
        id = id
    )
}

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
    rlang::check_installed(
        "rstudioapi",
        reason = "to manipulate RStudio files."
    )
    rstudioapi::getSourceEditorContext()
}

rstudioapi_modifyRange <- function(
    location = NULL, 
    text = NULL, 
    id = NULL
){
    rlang::check_installed(
        "rstudioapi",
        reason = "to manipulate RStudio files."
    )
    rstudioapi::modifyRange(
        location = location, 
        text = text, 
        id = id
    )
}
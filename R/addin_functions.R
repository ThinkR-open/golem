#' @importFrom rstudioapi getSourceEditorContext
#' @importFrom rstudioapi modifyRange
#' 
#' @export
insert_ns <- function () {
  curr_editor <- rstudioapi::getSourceEditorContext()
  
  id <- curr_editor$id
  sel_rng <- curr_editor$selection[[1]]$range
  sel_text <- curr_editor$selection[[1]]$text
  
  mod_text <- paste0("ns(", sel_text, ")")
  
  rstudioapi::modifyRange(sel_rng, mod_text, id = id)
}
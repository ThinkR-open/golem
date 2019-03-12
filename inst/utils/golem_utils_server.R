`%not_in%` <- Negate(`%in%`)

not_null <- Negate(is.null)

not_na <- Negate(is.na)

drop_nulls <- function(x){
  x[!sapply(x, is.null)]
}

"%||%" <- function(x, y){
  if (is.null(x)) {
    y
  } else {
    x
  }
}

"%|NA|%" <- function(x, y){
  if (is.na(x)) {
    y
  } else {
    x
  }
}
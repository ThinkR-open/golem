.golem_globals <- new.env()
.golem_globals$running <- FALSE

set_golem_global <- function(name, val) {
	.golem_globals[[name]] <- val
}

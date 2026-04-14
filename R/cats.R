cat_dir_necessary <- function() {
	cli_alert_warning(
		"File not added (needs a valid directory)."
	)
}

cat_start_download <- function() {
	cli_alert(
		"Initiating file download."
	)
}

cat_downloaded <- function(
	where,
	file = "File"
) {
	cli_alert_success(
		sprintf(
			"%s downloaded at %s.",
			file,
			where
		)
	)
}

cat_start_copy <- function() {
	cli_alert(
		"Copying file."
	)
}

cat_copied <- function(
	where,
	file = "File"
) {
	cli_alert_success(
		sprintf(
			"%s copied to %s.",
			file,
			where
		)
	)
}

cat_created <- function(
	where,
	file = "File"
) {
	cli_alert_success(
		sprintf(
			"%s created at %s.",
			file,
			where
		)
	)
}

cat_automatically_linked <- function() {
	cli_alert_success(
		"File automatically linked in `golem_add_external_resources()`."
	)
}

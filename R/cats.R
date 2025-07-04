cat_green_tick <- function(
	...
) {
	do_if_unquiet({
		cli_cat_bullet(
			...,
			bullet = "tick",
			bullet_col = "green"
		)
	})
}

cat_red_bullet <- function(
	...
) {
	do_if_unquiet({
		cli_cat_bullet(
			...,
			bullet = "bullet",
			bullet_col = "red"
		)
	})
}

cat_info <- function(
	...
) {
	do_if_unquiet({
		cli_cat_bullet(
			...,
			bullet = "arrow_right",
			bullet_col = "grey"
		)
	})
}


cat_exists <- function(
	where
) {
	do_if_unquiet({
		cat_red_bullet(
			sprintf(
				"[Skipped] %s already exists.",
				basename(
					where
				)
			)
		)
		cat_info(
			sprintf(
				"If you want replace it, remove the %s file first.",
				basename(
					where
				)
			)
		)
	})
}

cat_dir_necessary <- function() {
	do_if_unquiet({
		cat_red_bullet(
			"File not added (needs a valid directory)"
		)
	})
}

cat_start_download <- function() {
	do_if_unquiet({
		cli_cat_line(
			""
		)
		cli_cat_line(
			"Initiating file download"
		)
	})
}

cat_downloaded <- function(
	where,
	file = "File"
) {
	do_if_unquiet({
		cat_green_tick(
			sprintf(
				"%s downloaded at %s",
				file,
				where
			)
		)
	})
}

cat_start_copy <- function() {
	do_if_unquiet({
		cli_cat_line(
			""
		)
		cli_cat_line(
			"Copying file"
		)
	})
}

cat_copied <- function(
	where,
	file = "File"
) {
	do_if_unquiet({
		cat_green_tick(
			sprintf(
				"%s copied to %s",
				file,
				where
			)
		)
	})
}

cat_created <- function(
	where,
	file = "File"
) {
	do_if_unquiet({
		cat_green_tick(
			sprintf(
				"%s created at %s",
				file,
				where
			)
		)
	})
}

cat_automatically_linked <- function() {
	do_if_unquiet({
		cat_green_tick(
			"File automatically linked in `golem_add_external_resources()`."
		)
	})
}

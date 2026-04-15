# cats works

    Code
      cli_alert_success("File downloaded at /tmp.")
    Message
      v File downloaded at /tmp.
    Code
      cli_alert_warning("File not added (needs a valid directory)")
    Message
      ! File not added (needs a valid directory)
    Code
      cli_alert_info("File copied to /tmp")
    Message
      i File copied to /tmp
    Code
      cat_dir_necessary()
    Message
      ! File not added (needs a valid directory).
    Code
      cat_start_download()
    Message
      > Initiating file download.
    Code
      cat_downloaded("/tmp")
    Message
      v File downloaded at /tmp.
    Code
      cat_start_copy()
    Message
      > Copying file.
    Code
      cat_copied("/tmp")
    Message
      v File copied to /tmp.
    Code
      cat_created("/tmp")
    Message
      v File created at /tmp.
    Code
      cat_automatically_linked()
    Message
      v File automatically linked in `golem_add_external_resources()`.


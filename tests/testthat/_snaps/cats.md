# cats works

    Code
      cat_green_tick("File downloaded at /tmp")
    Output
      v File downloaded at /tmp
    Code
      cat_red_bullet("File not added (needs a valid directory)")
    Output
      * File not added (needs a valid directory)
    Code
      cat_info("File copied to /tmp")
    Output
      > File copied to /tmp
    Code
      cat_exists("/tmp")
    Output
      * [Skipped] tmp already exists.
      > If you want replace it, remove the tmp file first.
    Code
      cat_dir_necessary()
    Output
      * File not added (needs a valid directory)
    Code
      cat_start_download()
    Output
      
      Initiating file download
    Code
      cat_downloaded("/tmp")
    Output
      v File downloaded at /tmp
    Code
      cat_start_copy()
    Output
      
      Copying file
    Code
      cat_copied("/tmp")
    Output
      v File copied to /tmp
    Code
      cat_created("/tmp")
    Output
      v File created at /tmp
    Code
      cat_automatically_linked()
    Output
      v File automatically linked in `golem_add_external_resources()`.


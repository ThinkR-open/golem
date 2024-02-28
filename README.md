<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- badges: start -->

[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html)[![R-CMD-check](https://github.com/ThinkR-open/golem/workflows/R-CMD-check/badge.svg)](https://github.com/ThinkR-open/golem/actions)
[![Coverage
status](https://codecov.io/gh/ThinkR-open/golem/branch/test-for-gh/graph/badge.svg)](https://app.codecov.io/github/ThinkR-open/golem/tree/test-for-gh)[![CRAN
status](https://www.r-pkg.org/badges/version/golem)](https://cran.r-project.org/package=golem)

<!-- badges: end -->

# {golem} <img src="https://raw.githubusercontent.com/ThinkR-open/golem/master/inst/rstudio/templates/project/golem.png" align="right" width="120"/>

`{golem}` is an opinionated framework for building production-grade
shiny applications.

## Installation

-   You can install the stable version from CRAN with:

<!-- -->

    install.packages("golem")

-   You can install the development version from
    [GitHub](https://github.com/Thinkr-open/golem) with:

<!-- -->

    # install.packages("remotes")
    remotes::install_github("Thinkr-open/golem") # very close to CRAN version
    # remotes::install_github("Thinkr-open/golem@dev") # if you like to play

## Resources

The `{golem}` package is part of the
[`{golemverse}`](https://golemverse.org/), a series of tools for Shiny.
A list of various `{golem}` related resources (tutorials, video, blog
post,…) can be found [here](https://golemverse.org/resources/).

## Launch the project

Create a new package with the project template:

<img src="https://raw.githubusercontent.com/ThinkR-open/golem/master/inst/img/golemtemplate.png" width="80%" style="display: block; margin: auto;" />

## Step by step guide

See full documentation in the `{pkgdown}` website:

\[CRAN\] <https://thinkr-open.github.io/golem/>

\[dev\] <https://thinkr-open.github.io/golem/dev/>

After project creation, you’ll land on `dev/01_start.R`. There are also
`dev/02_dev.R` and `dev/03_deploy.R`

These files are used to keep a track of all the steps you’ll be
following while building your app.

### Step 1 : Getting Started

Read [the Getting
Started](https://thinkr-open.github.io/golem/articles/a_start.html)
Vignette for a detailed walkthrough.

### Step 2 : Day to Day Dev

Read [Day to Day
Dev](https://thinkr-open.github.io/golem/articles/b_dev.html) Vignette
for a detailed walkthrough.

### Step 3: deploy

Read [Deploying Apps with
{golem}](https://thinkr-open.github.io/golem/articles/c_deploy.html)
Vignette for a detailed walkthrough.

## Tool series

This package is part of a series of tools for Shiny, which includes:

-   `{golem}` - <https://github.com/ThinkR-open/golem>
-   `{shinipsum}` - <https://github.com/ThinkR-open/shinipsum>
-   `{fakir}` - <https://github.com/ThinkR-open/fakir>
-   `{gemstones}` - <https://github.com/ThinkR-open/gemstones>

## Examples apps

These are examples from the community. Please note that they may not
necessarily be written in a canonical fashion and may have been written
with different versions of `{golem}` or `{shiny}`.

-   <https://github.com/seanhardison1/vcrshiny>
-   <https://github.com/Nottingham-and-Nottinghamshire-ICS/healthcareSPC>
-   <https://github.com/marton-balazs-kovacs/tenzing>
-   <https://github.com/shahreyar-abeer/cranstars>

You can also find apps at:

-   <https://connect.thinkr.fr/connect/>
-   <https://github.com/ColinFay/golemexamples>

## About

You’re reading the doc about version: 0.4.20

This `README` has been compiled on the

    Sys.time()
    #> [1] "2024-02-28 16:04:13 UTC"

Here are the test & coverage results:

    devtools::check(quiet = TRUE)
    #> ℹ Loading golem
    #> ✖ add_dockerfiles_renv.R:149: @param refers to unavailable topic
    #>   attachment::att_amend_desc.
    #> ✖ add_dockerfiles_renv.R:152: @param refers to unavailable topic
    #>   renv::snapshot.
    #> ── R CMD check results ─────────────────────────────────────── golem 0.4.20 ────
    #> Duration: 1m 16.3s
    #> 
    #> ❯ checking tests ...
    #>   See below...
    #> 
    #> ❯ checking package dependencies ... NOTE
    #>   Packages suggested but not available for checking:
    #>     'attachment', 'dockerfiler', 'mockery', 'renv', 'rsconnect',
    #>     'spelling'
    #> 
    #> ❯ checking Rd cross-references ... NOTE
    #>   Packages unavailable to check Rd xrefs: ‘attachment’, ‘renv’
    #> 
    #> ── Test failures ───────────────────────────────────────────────── testthat ────
    #> 
    #> > library(testthat)
    #> > library(golem)
    #> > 
    #> > test_check("golem")
    #> File .here already exists in /tmp/RtmpBXmSgR/working_dir/RtmpxMF9tX/zctkynojhc20240228160448.494241
    #> We noticed that some dev dependencies are not installed.
    #> You can install them with `golem::install_dev_deps()`.
    #> File .here already exists in /tmp/RtmpBXmSgR/working_dir/RtmpxMF9tX/dummygolem1f29d049237
    #> We noticed that some dev dependencies are not installed.
    #> You can install them with `golem::install_dev_deps()`.
    #> File .here already exists in /tmp/RtmpBXmSgR/working_dir/RtmpxMF9tX/dummygolem1f291fec6c5
    #> We noticed that some dev dependencies are not installed.
    #> You can install them with `golem::install_dev_deps()`.
    #> File .here already exists in /tmp/RtmpBXmSgR/working_dir/RtmpxMF9tX/dummygolem1f2937135ae7
    #> We noticed that some dev dependencies are not installed.
    #> You can install them with `golem::install_dev_deps()`.
    #> File .here already exists in /tmp/RtmpBXmSgR/working_dir/RtmpxMF9tX/dummygolem1f2928960d8b
    #> We noticed that some dev dependencies are not installed.
    #> You can install them with `golem::install_dev_deps()`.
    #> File .here already exists in /tmp/RtmpBXmSgR/working_dir/RtmpxMF9tX/dummygolem1f29310a1c25
    #> We noticed that some dev dependencies are not installed.
    #> You can install them with `golem::install_dev_deps()`.
    #> The path file doesn't exist.
    #> It's possible that you might not be in a {golem} based project.
    #> Do you want to create the {golem} files?File .here already exists in /tmp/RtmpBXmSgR/working_dir/RtmpxMF9tX/dummy1f2971fafd66/koko
    #> We noticed that some dev dependencies are not installed.
    #> You can install them with `golem::install_dev_deps()`.
    #> File .here already exists in /tmp/RtmpBXmSgR/working_dir/RtmpxMF9tX/dummy1f2971fafd66/kokogui
    #> We noticed that some dev dependencies are not installed.
    #> You can install them with `golem::install_dev_deps()`.
    #> We noticed that some dev dependencies are not installed.
    #> You can install them with `golem::install_dev_deps()`.
    #> We noticed that some dev dependencies are not installed.
    #> You can install them with `golem::install_dev_deps()`.
    #> File .here already exists in /tmp/RtmpBXmSgR/working_dir/RtmpxMF9tX/dummy1f2971fafd66/sesame
    #> We noticed that some dev dependencies are not installed.
    #> You can install them with `golem::install_dev_deps()`.
    #> File .here already exists in /tmp/RtmpBXmSgR/working_dir/RtmpxMF9tX/dummy1f2971fafd66/gigit
    #> We noticed that some dev dependencies are not installed.
    #> You can install them with `golem::install_dev_deps()`.
    #> File .here already exists in /tmp/RtmpBXmSgR/working_dir/RtmpxMF9tX/dummy1f2971fafd66/gigitgui
    #> We noticed that some dev dependencies are not installed.
    #> You can install them with `golem::install_dev_deps()`.
    #> File .here already exists in /tmp/RtmpBXmSgR/working_dir/RtmpxMF9tX/dummy1f2971fafd66/withooutcomments
    #> We noticed that some dev dependencies are not installed.
    #> You can install them with `golem::install_dev_deps()`.
    #> File .here already exists in /tmp/RtmpBXmSgR/working_dir/RtmpxMF9tX/dummy1f2971fafd66/withooutcommentsgui
    #> We noticed that some dev dependencies are not installed.
    #> You can install them with `golem::install_dev_deps()`.
    #> File .here already exists in /tmp/RtmpBXmSgR/working_dir/RtmpxMF9tX/dummy1f2971fafd66/2cou_cou
    #> We noticed that some dev dependencies are not installed.
    #> You can install them with `golem::install_dev_deps()`.
    #> File .here already exists in /tmp/RtmpBXmSgR/working_dir/RtmpxMF9tX/dummy1f2971fafd66/2cou_cou
    #> We noticed that some dev dependencies are not installed.
    #> You can install them with `golem::install_dev_deps()`.
    #> File .here already exists in /tmp/RtmpBXmSgR/working_dir/RtmpxMF9tX/dummy1f2971fafd66/examplehook
    #> We noticed that some dev dependencies are not installed.
    #> You can install them with `golem::install_dev_deps()`.
    #> File .here already exists in /tmp/RtmpBXmSgR/working_dir/RtmpxMF9tX/dummy1f2971fafd66/examplehookgui
    #> We noticed that some dev dependencies are not installed.
    #> You can install them with `golem::install_dev_deps()`.
    #> i the `authors` argument is empty, using `author_first_name`, `author_last_name`, `author_email` and `author_orcid` to fill the DESCRIPTION file.
    #> v Setting `golem_version` to 0.0.0.9000
    #> v Setting `golem_name` to zctkynojhc20240228160448.494241
    #> v DESCRIPTION file modified
    #> -- Setting {golem} options in `golem-config.yml` -------------------------------
    #> v Setting `golem_name` to zctkynojhc20240228160448.494241
    #> v Setting `golem_wd` to golem::pkg_path()
    #> You can change golem working directory with set_golem_wd('path/to/wd')
    #> v Setting `golem_version` to 0.0.0.9000
    #> v Setting `app_prod` to FALSE
    #> -- Setting {usethis} project as `golem_wd` -------------------------------------
    #>   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
    #>                                  Dload  Upload   Total   Spent    Left  Speed
    #>   0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0100  2734  100  2734    0     0  28417      0 --:--:-- --:--:-- --:--:-- 28479
    #> Installing package into '/tmp/RtmpBXmSgR/RLIBS_1c6454e2a000'
    #> (as 'lib' is unspecified)
    #> trying URL 'https://cran.rstudio.com/src/contrib/attachment_0.4.1.tar.gz'
    #> Content type 'application/x-gzip' length 196468 bytes (191 KB)
    #> ==================================================
    #> downloaded 191 KB
    #> 
    #> * installing *source* package ‘attachment’ ...
    #> ** package ‘attachment’ successfully unpacked and MD5 sums checked
    #> ** using staged installation
    #> ** R
    #> ** inst
    #> ** byte-compile and prepare package for lazy loading
    #> ** help
    #> *** installing help indices
    #> *** copying figures
    #> ** building package indices
    #> ** installing vignettes
    #> ** testing if installed package can be loaded from temporary location
    #> ** testing if installed package can be loaded from final location
    #> ** testing if installed package keeps a record of temporary installation path
    #> * DONE (attachment)
    #> 
    #> The downloaded source packages are in
    #>  '/tmp/RtmpBXmSgR/working_dir/RtmpxMF9tX/downloaded_packages'
    #> Installing package into '/tmp/RtmpBXmSgR/RLIBS_1c6454e2a000'
    #> (as 'lib' is unspecified)
    #> also installing the dependency 'pak'
    #> 
    #> trying URL 'https://cran.rstudio.com/src/contrib/pak_0.7.1.tar.gz'
    #> Content type 'application/x-gzip' length 2022732 bytes (1.9 MB)
    #> ==================================================
    #> downloaded 1.9 MB
    #> 
    #> trying URL 'https://cran.rstudio.com/src/contrib/dockerfiler_0.2.2.tar.gz'
    #> Content type 'application/x-gzip' length 269151 bytes (262 KB)
    #> ==================================================
    #> downloaded 262 KB
    #> 
    #> * installing *source* package ‘pak’ ...
    #> ** package ‘pak’ successfully unpacked and MD5 sums checked
    #> ** using staged installation
    #> ** Running ./configure
    #> ** libs
    #> Current platform: x86_64-pc-linux-gnu 
    #> Build platform:   
    #> Target platform:   
    #> 
    #> Compiling R6 
    #> 
    #> Compiling cli 
    #> using C compiler: ‘gcc (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0’
    #> make[1]: Entering directory '/tmp/RtmpBXmSgR/working_dir/Rtmpkq2OX9/R.INSTALL1f922d0cbea/pak/src/library/cli/src'
    #> gcc -I"/opt/R/4.3.2/lib/R/include" -DNDEBUG   -I/usr/local/include   -fvisibility=hidden -I../inst/include -fpic  -g -O2  -c ansi.c -o ansi.o
    #> gcc -I"/opt/R/4.3.2/lib/R/include" -DNDEBUG   -I/usr/local/include   -fvisibility=hidden -I../inst/include -fpic  -g -O2  -c cleancall.c -o cleancall.o
    #> gcc -I"/opt/R/4.3.2/lib/R/include" -DNDEBUG   -I/usr/local/include   -fvisibility=hidden -I../inst/include -fpic  -g -O2  -c diff.c -o diff.o
    #> gcc -I"/opt/R/4.3.2/lib/R/include" -DNDEBUG   -I/usr/local/include   -fvisibility=hidden -I../inst/include -fpic  -g -O2  -c errors.c -o errors.o
    #> gcc -I"/opt/R/4.3.2/lib/R/include" -DNDEBUG   -I/usr/local/include   -fvisibility=hidden -I../inst/include -fpic  -g -O2  -c glue.c -o glue.o
    #> gcc -I"/opt/R/4.3.2/lib/R/include" -DNDEBUG   -I/usr/local/include   -fvisibility=hidden -I../inst/include -fpic  -g -O2  -c init.c -o init.o
    #> gcc -I"/opt/R/4.3.2/lib/R/include" -DNDEBUG   -I/usr/local/include   -fvisibility=hidden -I../inst/include -fpic  -g -O2  -c inst.c -o inst.o
    #> gcc -I"/opt/R/4.3.2/lib/R/include" -DNDEBUG   -I/usr/local/include   -fvisibility=hidden -I../inst/include -fpic  -g -O2  -c keypress-unix.c -o keypress-unix.o
    #> gcc -I"/opt/R/4.3.2/lib/R/include" -DNDEBUG   -I/usr/local/include   -fvisibility=hidden -I../inst/include -fpic  -g -O2  -c keypress-win.c -o keypress-win.o
    #> gcc -I"/opt/R/4.3.2/lib/R/include" -DNDEBUG   -I/usr/local/include   -fvisibility=hidden -I../inst/include -fpic  -g -O2  -c keypress.c -o keypress.o
    #> gcc -I"/opt/R/4.3.2/lib/R/include" -DNDEBUG   -I/usr/local/include   -fvisibility=hidden -I../inst/include -fpic  -g -O2  -c md5.c -o md5.o
    #> gcc -I"/opt/R/4.3.2/lib/R/include" -DNDEBUG   -I/usr/local/include   -fvisibility=hidden -I../inst/include -fpic  -g -O2  -c progress-altrep.c -o progress-altrep.o
    #> gcc -I"/opt/R/4.3.2/lib/R/include" -DNDEBUG   -I/usr/local/include   -fvisibility=hidden -I../inst/include -fpic  -g -O2  -c progress.c -o progress.o
    #> gcc -I"/opt/R/4.3.2/lib/R/include" -DNDEBUG   -I/usr/local/include   -fvisibility=hidden -I../inst/include -fpic  -g -O2  -c sha1.c -o sha1.o
    #> gcc -I"/opt/R/4.3.2/lib/R/include" -DNDEBUG   -I/usr/local/include   -fvisibility=hidden -I../inst/include -fpic  -g -O2  -c sha256.c -o sha256.o
    #> gcc -I"/opt/R/4.3.2/lib/R/include" -DNDEBUG   -I/usr/local/include   -fvisibility=hidden -I../inst/include -fpic  -g -O2  -c thread.c -o thread.o
    #> gcc -I"/opt/R/4.3.2/lib/R/include" -DNDEBUG   -I/usr/local/include   -fvisibility=hidden -I../inst/include -fpic  -g -O2  -c tty.c -o tty.o
    #> gcc -I"/opt/R/4.3.2/lib/R/include" -DNDEBUG   -I/usr/local/include   -fvisibility=hidden -I../inst/include -fpic  -g -O2  -c utf8.c -o utf8.o
    #> gcc -I"/opt/R/4.3.2/lib/R/include" -DNDEBUG   -I/usr/local/include   -fvisibility=hidden -I../inst/include -fpic  -g -O2  -c utils.c -o utils.o
    #> gcc -I"/opt/R/4.3.2/lib/R/include" -DNDEBUG   -I/usr/local/include   -fvisibility=hidden -I../inst/include -fpic  -g -O2  -c vt.c -o vt.o
    #> gcc -I"/opt/R/4.3.2/lib/R/include" -DNDEBUG   -I/usr/local/include   -fvisibility=hidden -I../inst/include -fpic  -g -O2  -c vtparse.c -o vtparse.o
    #> gcc -I"/opt/R/4.3.2/lib/R/include" -DNDEBUG   -I/usr/local/include   -fvisibility=hidden -I../inst/include -fpic  -g -O2  -c vtparse_table.c -o vtparse_table.o
    #> gcc -I"/opt/R/4.3.2/lib/R/include" -DNDEBUG   -I/usr/local/include   -fvisibility=hidden -I../inst/include -fpic  -g -O2  -c win-utf8.c -o win-utf8.o
    #> gcc -I"/opt/R/4.3.2/lib/R/include" -DNDEBUG   -I/usr/local/include   -fvisibility=hidden -I../inst/include -fpic  -g -O2  -c winfiles.c -o winfiles.o
    #> gcc -shared -L/opt/R/4.3.2/lib/R/lib -L/usr/local/lib -o cli.so ansi.o cleancall.o diff.o errors.o glue.o init.o inst.o keypress-unix.o keypress-win.o keypress.o md5.o progress-altrep.o progress.o sha1.o sha256.o thread.o tty.o utf8.o utils.o vt.o vtparse.o vtparse_table.o win-utf8.o winfiles.o -L/opt/R/4.3.2/lib/R/lib -lR
    #> make[1]: Leaving directory '/tmp/RtmpBXmSgR/working_dir/Rtmpkq2OX9/R.INSTALL1f922d0cbea/pak/src/library/cli/src'
    #> make[1]: Entering directory '/tmp/RtmpBXmSgR/working_dir/Rtmpkq2OX9/R.INSTALL1f922d0cbea/pak/src/library/cli/src'
    #> make[1]: Leaving directory '/tmp/RtmpBXmSgR/working_dir/Rtmpkq2OX9/R.INSTALL1f922d0cbea/pak/src/library/cli/src'
    #> installing to /tmp/RtmpBXmSgR/RLIBS_1c6454e2a000/00LOCK-pak/00new/pak/library/cli/libs
    #> 
    #> Compiling curl 
    #> Package libcurl was not found in the pkg-config search path.
    #> Perhaps you should add the directory containing `libcurl.pc'
    #> to the PKG_CONFIG_PATH environment variable
    #> No package 'libcurl' found
    #> Package libcurl was not found in the pkg-config search path.
    #> Perhaps you should add the directory containing `libcurl.pc'
    #> to the PKG_CONFIG_PATH environment variable
    #> No package 'libcurl' found
    #> Using PKG_CFLAGS=
    #> Using PKG_LIBS=-lcurl
    #> --------------------------- [ANTICONF] --------------------------------
    #> Configuration failed because libcurl was not found. Try installing:
    #>  * deb: libcurl4-openssl-dev (Debian, Ubuntu, etc)
    #>  * rpm: libcurl-devel (Fedora, CentOS, RHEL)
    #> If libcurl is already installed, check that 'pkg-config' is in your
    #> PATH and PKG_CONFIG_PATH contains a libcurl.pc file. If pkg-config
    #> is unavailable you can set INCLUDE_DIR and LIB_DIR manually via:
    #> R CMD INSTALL --configure-vars='INCLUDE_DIR=... LIB_DIR=...'
    #> -------------------------- [ERROR MESSAGE] ---------------------------
    #> <stdin>:1:10: fatal error: curl/curl.h: No such file or directory
    #> compilation terminated.
    #> --------------------------------------------------------------------
    #> ERROR: configuration failed for package ‘curl’
    #> Error in install_one(pkg, lib = lib) : FAILED
    #> Calls: install_embedded_main -> install_all -> install_one
    #> Execution halted
    #> installing via 'install.libs.R' to /tmp/RtmpBXmSgR/RLIBS_1c6454e2a000/00LOCK-pak/00new/pak
    #> Error in eval(ei, envir) : Compilation failed.
    #> * removing ‘/tmp/RtmpBXmSgR/RLIBS_1c6454e2a000/pak’
    #> ERROR: dependency ‘pak’ is not available for package ‘dockerfiler’
    #> * removing ‘/tmp/RtmpBXmSgR/RLIBS_1c6454e2a000/dockerfiler’
    #> 
    #> The downloaded source packages are in
    #>  '/tmp/RtmpBXmSgR/working_dir/RtmpxMF9tX/downloaded_packages'
    #> Installing package into '/tmp/RtmpBXmSgR/RLIBS_1c6454e2a000'
    #> (as 'lib' is unspecified)
    #> trying URL 'https://cran.rstudio.com/src/contrib/renv_1.0.4.tar.gz'
    #> Content type 'application/x-gzip' length 1165157 bytes (1.1 MB)
    #> ==================================================
    #> downloaded 1.1 MB
    #> 
    #> * installing *source* package ‘renv’ ...
    #> ** package ‘renv’ successfully unpacked and MD5 sums checked
    #> ** using staged installation
    #> ** R
    #> ** inst
    #> ** byte-compile and prepare package for lazy loading
    #> ** help
    #> *** installing help indices
    #> *** copying figures
    #> ** building package indices
    #> ** installing vignettes
    #> ** testing if installed package can be loaded from temporary location
    #> ** testing if installed package can be loaded from final location
    #> ** testing if installed package keeps a record of temporary installation path
    #> * DONE (renv)
    #> 
    #> The downloaded source packages are in
    #>  '/tmp/RtmpBXmSgR/working_dir/RtmpxMF9tX/downloaded_packages'
    #> Installing package into '/tmp/RtmpBXmSgR/RLIBS_1c6454e2a000'
    #> (as 'lib' is unspecified)
    #> also installing the dependency 'packrat'
    #> 
    #> trying URL 'https://cran.rstudio.com/src/contrib/packrat_0.9.2.tar.gz'
    #> Content type 'application/x-gzip' length 376653 bytes (367 KB)
    #> ==================================================
    #> downloaded 367 KB
    #> 
    #> trying URL 'https://cran.rstudio.com/src/contrib/rsconnect_1.2.1.tar.gz'
    #> Content type 'application/x-gzip' length 470779 bytes (459 KB)
    #> ==================================================
    #> downloaded 459 KB
    #> 
    #> * installing *source* package ‘packrat’ ...
    #> ** package ‘packrat’ successfully unpacked and MD5 sums checked
    #> ** using staged installation
    #> ** R
    #> ** inst
    #> ** byte-compile and prepare package for lazy loading
    #> ** help
    #> *** installing help indices
    #> ** building package indices
    #> ** testing if installed package can be loaded from temporary location
    #> ** testing if installed package can be loaded from final location
    #> ** testing if installed package keeps a record of temporary installation path
    #> * DONE (packrat)
    #> * installing *source* package ‘rsconnect’ ...
    #> ** package ‘rsconnect’ successfully unpacked and MD5 sums checked
    #> ** using staged installation
    #> ** R
    #> ** inst
    #> ** byte-compile and prepare package for lazy loading
    #> ** help
    #> *** installing help indices
    #> *** copying figures
    #> ** building package indices
    #> ** installing vignettes
    #> ** testing if installed package can be loaded from temporary location
    #> ** testing if installed package can be loaded from final location
    #> ** testing if installed package keeps a record of temporary installation path
    #> * DONE (rsconnect)
    #> 
    #> The downloaded source packages are in
    #>  '/tmp/RtmpBXmSgR/working_dir/RtmpxMF9tX/downloaded_packages'
    #> [1] "test"
    #> [1] "test"
    #> [1] "test"
    #> [1] "test"
    #> File .here already exists in /tmp/RtmpBXmSgR/working_dir/RtmpxMF9tX/dummygolem1f2943d3400f
    #> We noticed that some dev dependencies are not installed.
    #> You can install them with `golem::install_dev_deps()`.
    #> File .here already exists in /tmp/RtmpBXmSgR/working_dir/RtmpxMF9tX/dummygolem1f29791e5b1e
    #> We noticed that some dev dependencies are not installed.
    #> You can install them with `golem::install_dev_deps()`.
    #> trying URL 'https://raw.githubusercontent.com/ThinkR-open/golem/dev/inst/utils/testfile_template_plainfile.txt'
    #> Content type 'text/plain; charset=utf-8' length 11 bytes
    #> ==================================================
    #> downloaded 11 bytes
    #> 
    #> trying URL 'https://raw.githubusercontent.com/ThinkR-open/golem/dev/inst/utils/testfile_template_html.html'
    #> Content type 'text/plain; charset=utf-8' length 102 bytes
    #> ==================================================
    #> downloaded 102 bytes
    #> 
    #> trying URL 'https://raw.githubusercontent.com/ThinkR-open/golem/dev/inst/utils/testfile_template_js.js'
    #> Content type 'text/plain; charset=utf-8' length 88 bytes
    #> ==================================================
    #> downloaded 88 bytes
    #> 
    #> trying URL 'https://raw.githubusercontent.com/ThinkR-open/golem/dev/inst/utils/testfile_template_css.css'
    #> Content type 'text/plain; charset=utf-8' length 137 bytes
    #> ==================================================
    #> downloaded 137 bytes
    #> 
    #> File .here already exists in /tmp/RtmpBXmSgR/working_dir/RtmpxMF9tX/dummygolem1f297515eaf5
    #> We noticed that some dev dependencies are not installed.
    #> You can install them with `golem::install_dev_deps()`.
    #> Loading required namespace: DT
    #> Failed with error:  'there is no package called 'DT''
    #> File .here already exists in /tmp/RtmpBXmSgR/working_dir/RtmpxMF9tX/dummygolem1f296d8c39ea
    #> We noticed that some dev dependencies are not installed.
    #> You can install them with `golem::install_dev_deps()`.
    #> File .here already exists in /tmp/RtmpBXmSgR/working_dir/RtmpxMF9tX/dummygolem1f2940e003c5
    #> We noticed that some dev dependencies are not installed.
    #> You can install them with `golem::install_dev_deps()`.
    #> File .here already exists in /tmp/RtmpBXmSgR/working_dir/RtmpxMF9tX/dummygolem1f29ac5d133
    #> We noticed that some dev dependencies are not installed.
    #> You can install them with `golem::install_dev_deps()`.
    #> File .here already exists in /tmp/RtmpBXmSgR/working_dir/RtmpxMF9tX/dummygolem1f29568ce2c4
    #> We noticed that some dev dependencies are not installed.
    #> You can install them with `golem::install_dev_deps()`.
    #> File .here already exists in /tmp/RtmpBXmSgR/working_dir/RtmpxMF9tX/dummygolem1f29698e4aa0
    #> We noticed that some dev dependencies are not installed.
    #> You can install them with `golem::install_dev_deps()`.
    #> The path some_type doesn't exist, create?
    #> To use this html file as a template, add the following code in your UI:
    #> htmlTemplate(
    #>     app_sys("app/www/NAME-OF-HTML-FILE.html"),
    #>     body = tagList()
    #>     # add here other template arguments
    #> )
    #> File .here already exists in /tmp/RtmpBXmSgR/working_dir/RtmpxMF9tX/dummygolem1f293aa4b2d1
    #> We noticed that some dev dependencies are not installed.
    #> You can install them with `golem::install_dev_deps()`.
    #> File .here already exists in /tmp/RtmpBXmSgR/working_dir/RtmpxMF9tX/dummygolem1f293a4afed4
    #> We noticed that some dev dependencies are not installed.
    #> You can install them with `golem::install_dev_deps()`.
    #> File .here already exists in /tmp/RtmpBXmSgR/working_dir/RtmpxMF9tX/dummygolem1f294a4c9c12
    #> We noticed that some dev dependencies are not installed.
    #> You can install them with `golem::install_dev_deps()`.
    #> File .here already exists in /tmp/RtmpBXmSgR/working_dir/RtmpxMF9tX/uhrvkxdsxx
    #> We noticed that some dev dependencies are not installed.
    #> You can install them with `golem::install_dev_deps()`.
    #> Setting `RoxygenNote` to "7.3.1"
    #> i Loading uhrvkxdsxx
    #> Writing 'NAMESPACE'
    #> i Loading uhrvkxdsxx
    #> [ FAIL 5 | WARN 2 | SKIP 7 | PASS 375 ]
    #> 
    #> ══ Skipped tests (7) ═══════════════════════════════════════════════════════════
    #> • dockerfiler cannot be loaded (4): 'test-add_deploy_helpers.R:37:3',
    #>   'test-extra_sysreqs.R:1:1', 'test-renv_stuff.R:4:3', 'test-renv_stuff.R:41:3'
    #> • exists("run_app") is not TRUE (2): 'test-with_opt.R:12:7',
    #>   'test-with_opt.R:54:9'
    #> • renv cannot be loaded (1): 'test-add_deploy_helpers.R:3:3'
    #> 
    #> ══ Warnings ════════════════════════════════════════════════════════════════════
    #> ── Warning ('test-install_dev_deps.R:2:3'): install_dev_deps works ─────────────
    #> installation of package 'pak' had non-zero exit status
    #> Backtrace:
    #>     ▆
    #>  1. └─golem::install_dev_deps(force_install = TRUE, repos = "https://cran.rstudio.com") at test-install_dev_deps.R:2:3
    #>  2.   └─utils (local) f(pak, ...)
    #> ── Warning ('test-install_dev_deps.R:2:3'): install_dev_deps works ─────────────
    #> installation of package 'dockerfiler' had non-zero exit status
    #> Backtrace:
    #>     ▆
    #>  1. └─golem::install_dev_deps(force_install = TRUE, repos = "https://cran.rstudio.com") at test-install_dev_deps.R:2:3
    #>  2.   └─utils (local) f(pak, ...)
    #> 
    #> ══ Failed tests ════════════════════════════════════════════════════════════════
    #> ── Error ('test-config.R:245:3'): get_current_config() interactively recreates files upon user wish ──
    #> <packageNotFoundError/error/condition>
    #> Error in `loadNamespace(x)`: there is no package called 'mockery'
    #> Backtrace:
    #>     ▆
    #>  1. └─base::loadNamespace(x) at test-config.R:245:3
    #>  2.   └─base::withRestarts(stop(cond), retry_loadNamespace = function() NULL)
    #>  3.     └─base (local) withOneRestart(expr, restarts[[1L]])
    #>  4.       └─base (local) doWithOneRestart(return(expr), restart)
    #> ── Error ('test-config.R:289:3'): get_current_config() interactively returns NULL upon user wish ──
    #> <packageNotFoundError/error/condition>
    #> Error in `loadNamespace(x)`: there is no package called 'mockery'
    #> Backtrace:
    #>     ▆
    #>  1. └─base::loadNamespace(x) at test-config.R:289:3
    #>  2.   └─base::withRestarts(stop(cond), retry_loadNamespace = function() NULL)
    #>  3.     └─base (local) withOneRestart(expr, restarts[[1L]])
    #>  4.       └─base (local) doWithOneRestart(return(expr), restart)
    #> ── Failure ('test-install_dev_deps.R:28:5'): install_dev_deps works ────────────
    #> rlang::is_installed(pak) is not TRUE
    #> 
    #> `actual`:   FALSE
    #> `expected`: TRUE 
    #> ── Error ('test-utils.R:100:5'): file creation utils work interactively with user mimick 'no' ──
    #> <packageNotFoundError/error/condition>
    #> Error in `loadNamespace(x)`: there is no package called 'mockery'
    #> Backtrace:
    #>     ▆
    #>  1. ├─withr::with_dir(...) at test-utils.R:97:3
    #>  2. │ └─base::force(code)
    #>  3. └─base::loadNamespace(x) at test-utils.R:100:5
    #>  4.   └─base::withRestarts(stop(cond), retry_loadNamespace = function() NULL)
    #>  5.     └─base (local) withOneRestart(expr, restarts[[1L]])
    #>  6.       └─base (local) doWithOneRestart(return(expr), restart)
    #> ── Error ('test-utils.R:139:5'): file creation utils work interactively with user mimick 'yes' ──
    #> <packageNotFoundError/error/condition>
    #> Error in `loadNamespace(x)`: there is no package called 'mockery'
    #> Backtrace:
    #>     ▆
    #>  1. ├─withr::with_dir(...) at test-utils.R:131:3
    #>  2. │ └─base::force(code)
    #>  3. └─base::loadNamespace(x) at test-utils.R:139:5
    #>  4.   └─base::withRestarts(stop(cond), retry_loadNamespace = function() NULL)
    #>  5.     └─base (local) withOneRestart(expr, restarts[[1L]])
    #>  6.       └─base (local) doWithOneRestart(return(expr), restart)
    #> 
    #> [ FAIL 5 | WARN 2 | SKIP 7 | PASS 375 ]
    #> Error: Test failures
    #> Execution halted
    #> 
    #> 1 error ✖ | 0 warnings ✔ | 2 notes ✖
    #> Error: R CMD check found ERRORs

    covr::package_coverage()
    #> Error: Failure in `/tmp/RtmpRdE1Bs/R_LIBS1b6d7cf0d5f/golem/golem-tests/testthat.Rout.fail`
    #> () NULL)
    #>  5.     └─base (local) withOneRestart(expr, restarts[[1L]])
    #>  6.       └─base (local) doWithOneRestart(return(expr), restart)
    #> 
    #> [ FAIL 5 | WARN 2 | SKIP 7 | PASS 375 ]
    #> Error: Test failures
    #> Execution halted

## CoC

Please note that this project is released with a [Contributor Code of
Conduct](https://www.contributor-covenant.org/version/1/0/0/code-of-conduct.html).
By participating in this project you agree to abide by its terms.

## Note for the contributors

Please style the files according to `grkstyle::grk_style_transformer()`

    # If you work in RStudio
    options(styler.addins_style_transformer = "grkstyle::grk_style_transformer()")

    # If you work in VSCode
    options(languageserver.formatting_style = function(options) {
      grkstyle::grk_style_transformer()
    })

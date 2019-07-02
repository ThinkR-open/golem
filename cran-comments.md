## Test environments
* local OS X install, R 3.6.0
* ubuntu 14.04 (on travis-ci), R 3.6.0
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a resubmission. 

Feedbacks from previous submission: 

```
Found the following (possibly) invalid URLs:
     URL:
       From: inst/doc/c_deploy.html
             inst/doc/d_js.html
       Message: Empty URL

remove empty references.
```

-> We filled the URL so they are not empty anymore 

```
   Found the following (possibly) invalid file URI:
     URI: CODE_OF_CONDUCT.md
       From: README.md

The file is not part of the package, perhaps link to it via a fully 
specified URL?
```

-> Changed the Code of conduct link to full url

```
We also see you declared > License: MIT + file LICENSE
where the license file should be the CRAN template for the MIT license, 
but actually it contains a copy of the GPL-3? Is this meant as an 
alternative licence?
```

-> We switched to a full MIT licence
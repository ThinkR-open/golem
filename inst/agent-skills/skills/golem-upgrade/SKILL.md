---
name: golem-upgrade
description: |
  Upgrades the golem Shiny app with the newest golem package features.
  Triggers on:
    - "upgrade my Shiny app"
    - "upgrade app"
    - "upgrade Shiny app"
    - "upgrade with newest golem features"
    - "upgrade to newest golem features"
    - "update my Shiny app"
    - "update app"
    - "update Shiny app"
    - "update with newest golem features"
    - "update to newest golem features"
  Do not trigger on:
    - if outside an R Shiny app
    - if outside an R Shiny app which is not golem based
---

## Main Task

An old golem Shiny app which has been built with an older version of `{golem}`
gets an upgrade. Upgrade means getting access to newest features, and updates
of meta files and information.

## Usage

Use this skill when creating, reviewing, or modifying a golem-based Shiny
application, and it is clear that the user wants an upgrade or should get an
upgrade from the context of the conversation.

## To-Do

**IMPORTANT**: leave changes likely made by the user as is.

To this end:

I. Make an inventory of the following:

1. dev/ folder:
  - most often replacing older files with newer versions of the files is enough
2. R/app_ui.R & R/app_server.R
  - most often replacing older files with newer versions of the files is enough
3. R/app_config & R/run_app.R
  - sometimes replacing the old file with a newer version is enough, but careful
  with the possibility of user changes
4. inst/golem-config
  - could be tricky; make a diff, and only add new fields from new golem version,
  not changing other fields; still the App may not be that "old" and the user
  might decide to delete fields on purpose
5. old deprecated functions: to find deprecated features refer to
  - lookup table under assets/lookup_table.md
  - NEWS.md under assets/NEWS.md

II. Compare Shiny app version and golem package version newest golem version

The newest CRAN version is given at
- https://cran.r-project.org/web/packages/golem/index.html

The newest upstream version is given in the master/main branch under
- https://github.com/ThinkR-open/golem

III. Propose to update the R {golem} package (install.packages("golem"))

After the update, migrate functions and metadata to align with the new golem
version, **BUT AGAIN IMPORTANTLY: do not touch the content likely set by the
user: find a way to migrate !** . If unsure what is set by the user, and what
comes from an older golem version, ask the user, checkout the older version
installed on the system with upstream information at
https://github.com/ThinkR-open/golem , evaluate this, and then discuss this with
the user.

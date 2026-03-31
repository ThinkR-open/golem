---
name: check
description: Run a full R CMD check on the golem package and report errors, warnings, and notes.
---

Run a full R CMD check on the golem package and report errors, warnings, and notes.

```bash
Rscript -e "devtools::check()"
```

Summarize the results clearly, highlighting any errors, warnings, or notes. The goal is 0 errors, 0 warnings, 0 notes.

Suggests changes to correct the failures, if any.

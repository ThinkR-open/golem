---
name: test
description: Run the golem package test suite and summarize the results.
---

Run the test suite for the golem package using devtools.

```bash
Rscript -e "devtools::test()"
```

Summarize the results: number of tests passed, failed, and skipped.

If there are failures, show the relevant error messages and file locations, and suggests changes to correct the failures.

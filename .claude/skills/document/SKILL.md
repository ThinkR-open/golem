---
name: document
description: Regenerate documentation (NAMESPACE and Rd files) then format the code with air.
---

Regenerate documentation (NAMESPACE and Rd files) then format the codebase.

```bash
Rscript -e "devtools::document()" && air format .
```

Report any issues encountered during documentation generation or formatting.

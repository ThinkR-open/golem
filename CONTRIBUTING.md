## Contributing 

First of all, thank you for taking time to contribute to `{golem}`!

### What you can help with

There are several ways to contribute to the package: 

1. Spot typos and/or mistakes in the documentations 

1. Feature requests or Bug Report

1. Contribute the code-base with new features or with bug fixes

### How to contribute

1. For typos, please open an issue or a Pull request with your change. 

For a simple typo, you can PR into the repo without opening an issue first. 
You can also only report the typo without doing a PR. 

2. For a new feature or bug report, start by opening an issue on this repo. 

You're welcome to fix the bug or implement the feature, but __please don't PR in the repo with features or bugs correction without opening an issue first so that we can discuss the feature / confirm the bug.__ 

### Making change into `{golem}`

1. Fork the repo on your profile. 

2. `git clone` your repo on your machine.

  ```
  git clone https://github.com/YOURNAME/golem.git
  ```

3. Work on the `dev` branch.
 
  ```
  git branch dev
  ```

  Or use the Git panel from RStudio 

4. Make the changes locally. 

5. Be sure to have a `devtools::check()` that return 0 errors, 0 warnings and 0 mistakes

  ```r
  devtools::check()
  ```
  
  If ever you have some errors, please specify it in your commit message / PR comment

6. PR the change __into golem dev branch__, not straight to master

7. In your PR message, please add the reference of the issue, and the content to be used in NEWS.md. Changes can be : `## New Functions`, `## New features`, `## Breaking changes`, `## Bug fix`, `## Bug fix`, `## Internal changes`

  See https://github.com/ThinkR-open/golem/pull/149 for an example

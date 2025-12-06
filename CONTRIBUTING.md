# If you work in VSCode

## Contributing

First of all, thank you for taking time to contribute to
[golem](https://thinkr-open.github.io/golem/)!

### What you can help with

There are several ways to contribute to the package:

1.  Spot typos and/or mistakes in the documentations

2.  Feature requests or Bug Report

3.  Contribute the code-base with new features or with bug fixes

### How to contribute

1.  For typos, please open an issue or a Pull request with your change.

For a simple typo, you can PR into the repo without opening an issue
first. You can also only report the typo without doing a PR.

2.  For a new feature or bug report, start by opening an issue on this
    repo.

You’re welcome to fix the bug or implement the feature, but **please
don’t PR in the repo with features or bugs correction without opening an
issue first so that we can discuss the feature / confirm the bug.**

### Making change into `{golem}`

1.  Fork the repo on your profile.

2.  `git clone` your repo on your machine.

&nbsp;

    git clone https://github.com/YOURNAME/golem.git

3.  Work on the `dev` branch.

&nbsp;

    git branch dev

Or use the Git panel from RStudio

4.  Make the changes locally.

5.  Be sure to have a
    [`devtools::check()`](https://devtools.r-lib.org/reference/check.html)
    that return 0 errors, 0 warnings and 0 mistakes

``` r
devtools::check()
```

If ever you have some errors, please specify it in your commit message /
PR comment

6.  PR the change **into golem dev branch**, not straight to master

7.  In your PR message, please add the reference of the issue, and the
    content to be used in NEWS.md. Changes can be : `## New Functions`,
    `## New features`, `## Breaking changes`, `## Bug fix`,
    `## Bug fix`, `## Internal changes`

See <https://github.com/ThinkR-open/golem/pull/149> for an example

### Styling

Please style the files according to `grkstyle::grk_style_transformer()`

\`\`\`{r} \# If you work in RStudio
options(styler.addins_style_transformer =
“grkstyle::grk_style_transformer()”)

options(languageserver.formatting_style = function(options) {
grkstyle::grk_style_transformer() }) \`\`\`

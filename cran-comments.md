# Release summary

This is a patch release (1.0.0 -> 1.0.1).

We are aware that this comes shortly after the 1.0.0 release. We are submitting
it because, after 1.0.0 reached CRAN, we discovered a bug that breaks deployed
applications: `favicon()` — which runs at app runtime — relied on the `{fs}`
package, but `{fs}` is only a `Suggests` dependency of `{golem}`. Apps deployed
to an environment where `{fs}` is not installed therefore crashed at UI render
time. This patch removes that runtime dependency; the single-line fix and its
NEWS entry are the only user-facing changes. Thank you for your understanding.

# R CMD check results

0 errors | 0 warnings | 0 notes

# Reverse dependencies

The only change since the 1.0.0 release is a one-line internal fix to
`favicon()`. The function's output is unchanged (it still returns the exact
same `<link>` favicon tag and href); the fix only removes an internal call to
`{fs}`. No reverse dependency's use of `{golem}` is affected by this change.

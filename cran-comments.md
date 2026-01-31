## Resubmission

This is a resubmission. In this version, I have removed the offending folder named `sleacr` inside `inst`.

## Test environments
* local OS X install, R 4.5.2
* local ubuntu 22.04 install, R 4.5.2
* win-builder (devel, release, and old release)
* github actions windows-latest, r: release
* github actions macOS-latest, r: release
* github actions ubuntu-24.04, r: release, devel, old release
* rhub windows-latest r devel
* rhub ubuntu 24.04 r devel
* rhub macos r devel
* rhub macos-arm64 r devel
* macbuilder (devel)

## R CMD check results

### Local checks

0 errors | 0 warnings | 0 notes

### win-builder checks - devel and release

0 errors | 0 warnings | 1 note

* This is a new release.

### win-builder checks - old release

0 errors | 0 warnings | 2 notes

* This is a new release.

Author field differs from that derived from Authors@R
Author field differs from that derived from Authors@R
  Author:    'Ernest Guevarra [aut, cre, cph] (ORCID: <https://orcid.org/0000-0002-4887-4415>), Mark Myatt [aut, cph] (ORCID: <https://orcid.org/0000-0003-1119-1474>)'
  Authors@R: 'Ernest Guevarra [aut, cre, cph] (<https://orcid.org/0000-0002-4887-4415>), Mark Myatt [aut, cph] (<https://orcid.org/0000-0003-1119-1474>)'

Both author information are the same but ORCID records are formatted differently.

For winbuilder checks, additional note on:

Possibly misspelled words in DESCRIPTION:
  CSAS (18:15)
  Centric (17:52)
  MoH (24:64)
  SLEAC (4:23, 20:27, 25:17, 27:25)
  SQUEAC (26:29)

These words are not misspelled. Four of the five are abbreviations. The fifth is a correctly-spelled word.

### rhub checks

0 errors | 0 warnings | 0 notes

### macbuilder checks

0 errors | 0 warnings | 1 note

* This is a new release.



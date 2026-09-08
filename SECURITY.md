# Security policy

## Supported versions

Only the latest released version receives fixes.

## Reporting a vulnerability

Do not open a public issue for a vulnerability that could expose local CLI
credentials or execute project configuration. Contact the maintainer privately
or enable GitHub private vulnerability reporting before publishing the
repository.

## Design notes

LimitChecker runs the CLIs in an app-owned empty Application Support directory.
It does not run from the user's project directory and does not intentionally
load project-local configuration or hooks. The helper is bundled and signed
inside the application; release builds should be Developer-ID signed and
notarized.

# Security Policy

This tap only packages the Vericto CLI: each formula points at the release
archives of [vericto/vericto-cli](https://github.com/vericto/vericto-cli) and
pins them by SHA-256.

## Reporting a vulnerability

**Do not open a public GitHub issue for security vulnerabilities.**

Email **security@vericto.com**, or open a private report on the CLI repository:
[Report a vulnerability](https://github.com/vericto/vericto-cli/security/advisories/new).
Vulnerabilities in the CLI itself are handled there; see its
[security policy](https://github.com/vericto/vericto-cli/blob/main/SECURITY.md).

In scope here: a formula that installs anything other than the archive the
CLI release published (a wrong URL or checksum), or a change to this
repository's workflows that could alter what `brew install vericto/tap/vericto`
installs.

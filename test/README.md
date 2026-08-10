# Test Harness

`test/cmdblocks-test` is the local and CI entrypoint. It runs every focused
suite under `test/suites/`; the suites load shared assertions from
`test/helpers.sh`. Shared CI sets `CMDBLOCKS_SKIP_SHELLCHECK=1` because its
required Ubuntu inventory job owns lint execution, while local runs lint by
default.

## Suite Scope

- `cmdblocks-behavior-test` covers the terminal command-block helpers
  (`tmux-copy-last-output`, `term-notify-sound`).
- `install-test` covers the standalone checkout-backed command and manpage
  links, idempotent retargeting, custom destinations, complete source
  preflight, and refusal to overwrite user-owned paths.
- `manpage-test` verifies that every PATH-visible helper ships a manual page.
- `shellcheck-test` lints the program rows in
  `.github/shellcheck-files.txt`; the shared action owns whole-repository drift
  discovery.
- `ci-contract-test` verifies the shared workflow contract and proves that
  local-default and delegated ShellCheck modes execute as intended.

Prefer fake `tmux`/terminal commands and fixture input over depending on an
active tmux or terminal session, and add assertions to the suite that owns the
behavior being changed.

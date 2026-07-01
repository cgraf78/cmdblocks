# Test Harness

`test/cmdblocks-test` is the local and CI entrypoint. It runs every focused
suite under `test/suites/`; the suites load shared assertions from
`test/helpers.sh`.

## Suite Scope

- `cmdblocks-behavior-test` covers the terminal command-block helpers
  (`tmux-copy-last-output`, `term-notify-sound`).
- `manpage-test` verifies that every PATH-visible helper ships a manual page.

Prefer fake `tmux`/terminal commands and fixture input over depending on an
active tmux or terminal session, and add assertions to the suite that owns the
behavior being changed.

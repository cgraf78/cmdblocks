# cmdblocks

![Tests](https://github.com/cgraf78/cmdblocks/actions/workflows/test.yml/badge.svg?branch=main)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Bash Version](https://img.shields.io/badge/bash-%3E%3D3.2-blue.svg)](https://www.gnu.org/software/bash/)
[![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20macOS%20%7C%20WSL-lightgrey.svg)](#)

Small tmux helpers for working with command output and pane attention:

- **`tmux-copy-last-output [N]`**: copy the last N commands and their output
  from the current tmux pane to your clipboard, through `pbcopy`, `xclip`, or
  OSC 52 (which can reach your local clipboard over SSH). It is like "copy last
  output" in Warp or iTerm2, but inside tmux. **It needs a specific two-line
  prompt; see [Prompt format](#prompt-format).**
- **`term-notify-sound`**: ring the terminal bell. Call it when a job or agent
  finishes. Inside tmux it also marks which pane rang, which plain tmux does
  not track (tmux records a bell against the window).
- **`term-pane-mark`**: set or clear a `busy` or `pending` mark on your tmux
  pane, for example while a coding agent works on a prompt, so your tmux
  config can show it.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/cgraf78/cmdblocks/main/install.sh | bash
```

This keeps a durable managed checkout under `$XDG_DATA_HOME` when that path is
absolute, or under `$HOME/.local/share` otherwise, and publishes links to its
commands and manual pages. Rerunning the curl command safely updates the clean
managed checkout before republishing the links.

To choose and manage the checkout yourself instead, keep it at a stable path
and run:

```bash
./install.sh
```

The installer creates checkout-backed symlinks for every command under
`$HOME/.local/bin` and for their manual pages under
`$HOME/.local/share/man/man1`. Set `PREFIX` to relocate both trees, or set
`BIN_DIR` and `MAN_DIR` independently. Re-running the installer is safe and
retargets existing symlinks, but it refuses to replace a non-symlink path.
Moving or deleting the checkout breaks the installed links.

Requirements: Bash and tmux. `tmux-copy-last-output` copies through `pbcopy`
when it is on `PATH`, then `xclip` when `DISPLAY` is set, and otherwise writes
OSC 52 to the attached tmux client's terminal, which must support OSC 52.

## Prompt format

`tmux-copy-last-output` finds command boundaries by reading the pane text for
a two-line prompt. It recognizes exactly this shape:

```text
[0] user@host:~/src/project (main)
$ make test
```

- **Line 1** starts with `user@host:`, optionally preceded by an exit code
  such as `[0] `. The user name may contain only letters, digits, and `_`;
  the host may also contain `.` and `-`. Anything after the colon is ignored.
- **Line 2**, immediately below, is `$` (bash) or `%` (zsh), then a space and
  the command.

These prompts match:

```bash
# bash (~/.bashrc). Use a literal `$`: `\$` turns into `#` for root.
PS1='[$?] \u@\h:\w\n$ '
```

```zsh
# zsh (~/.zshrc)
PROMPT=$'[%?] %n@%m:%~\n%% '
```

With any other prompt, the command finds no blocks: it shows a tmux message,
"No command output found", and copies nothing. With `--print` it also exits
with status 3. Prompt colors are fine, because tmux captures the text without
them.

## tmux setup

Copy the last command and its output with `prefix y`, or the last N with
`prefix Y`:

```tmux
bind y run-shell 'TMUX_PANE=#{pane_id} tmux-copy-last-output'
bind Y command-prompt -p 'Copy last N commands:' 'run-shell "TMUX_PANE=#{pane_id} tmux-copy-last-output %1"'
```

`term-notify-sound` and `term-pane-mark` set the pane options
`@term_notify_pending` and `@term_busy` to `1`. Rendering and clearing the
pending mark is up to your tmux config. For example, show both in pane
borders and clear the pending mark when you visit the pane:

```tmux
set -g pane-border-status top
set -g pane-border-format '#{?@term_notify_pending,[!] ,}#{?@term_busy,[busy] ,}#{pane_current_command}'
set-hook -g after-select-pane 'set-option -pu @term_notify_pending'
set-hook -g after-select-window 'set-option -pu @term_notify_pending'
```

## Commands

- `tmux-copy-last-output [--print] [N]`: copy the last N command blocks (the
  default is 1) from the last 10,000 lines of the pane. `--print` writes them
  to standard output instead, so a binding can route them elsewhere.
- `term-notify-sound [--owner PID]`: write one BEL to `/dev/tty`
  (`TERM_NOTIFY_TTY` overrides it), falling back to the tmux pane's tty. Inside
  tmux it then runs `term-pane-mark set pending`. Typical use is
  `make; term-notify-sound`, or an agent's "finished" hook.
- `term-pane-mark set|clear pending|busy [--pane PANE] [--owner PID]`: set or
  clear `@term_notify_pending` or `@term_busy` on the caller's own pane.
  `--owner PID` limits changes to that process while it runs in the pane's
  foreground, so programs an agent launches cannot clear the agent's mark.

Each command has a man page with the details, including how
`term-pane-mark` decides which pane is the caller's.

## Integrators

`share/cmdblocks/shell.sh` is a no-op shell loader for harnesses that source
every dependency's shell API the same way. The installer leaves it in the
checkout. With [shdeps](https://github.com/cgraf78/shdeps), resolve it with:

```bash
. "$(shdeps dep-file cgraf78/cmdblocks share/cmdblocks/shell.sh)"
```

## Development

```bash
./test/cmdblocks-test
```

The ShellCheck suite needs `shellcheck` unless `CMDBLOCKS_SKIP_SHELLCHECK=1`
is set. See [`AGENTS.md`](AGENTS.md) for the test layout and CI details.

## License

MIT. See [`LICENSE`](LICENSE).

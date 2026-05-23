# cmdblocks

![Tests](https://github.com/cgraf78/cmdblocks/actions/workflows/test.yml/badge.svg?branch=main)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Bash Version](https://img.shields.io/badge/bash-%3E%3D3.2-blue.svg)](https://www.gnu.org/software/bash/)
[![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20macOS%20%7C%20WSL-lightgrey.svg)](#)

`cmdblocks` owns structured terminal command-block utilities.

`shdeps` installs the executable files in `bin/` as PATH-visible symlinks. The
scripts are self-contained and resolve their behavior without consumer-owned
wrapper scripts.

## Public API

- `bin/tmux-copy-last-output`: copy recent tmux command output blocks.
- `bin/term-notify-sound`: emit terminal-aware completion notifications.
- `share/cmdblocks/shell.sh`: stable no-op shell loader for integration
  harnesses that source each dependency's shell API uniformly.

Source non-binary assets through shdeps so install locations stay under the
dependency manager's contract:

```bash
. "$(shdeps dep-file cgraf78/cmdblocks share/cmdblocks/shell.sh)"
```

## Dependencies

- Bash for the CLI entry points.
- `tmux` is required by `tmux-copy-last-output` and by tmux-aware notification
  routing.
- A clipboard backend is required for copying command output: `pbcopy` on macOS
  or `xclip` with `DISPLAY` on X11.
- `term-notify-sound` works best in terminals that understand its notification
  signals. It writes WezTerm OSC user variables when running under WezTerm and
  falls back to a state-file signal for VS Code-style terminals.

Keybindings, shell hooks, and host-specific terminal config belong to the
consumer that installs `cmdblocks`; this repo owns reusable command-boundary
and terminal-notification behavior.

Run tests with:

```bash
./test/cmdblocks-test
```

## License

MIT. See [`LICENSE`](LICENSE).

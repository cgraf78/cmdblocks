# cmdblocks

**Moved to [tmux-tools](https://github.com/cgraf78/tmux-tools).** This
repository is no longer maintained.

`tmux-copy-last-output`, `term-notify-sound`, and `term-pane-mark` now ship
in tmux-tools with the same names, options, pane options
(`@term_notify_pending`, `@term_busy`), environment variables, and exit
statuses. Install them from there:

```bash
curl -fsSL https://raw.githubusercontent.com/cgraf78/tmux-tools/main/install.sh | bash
```

The tmux-tools installer retargets existing cmdblocks command and man page
links, so running it over a cmdblocks install is enough; pass the same
`PREFIX`, `BIN_DIR`, or `MAN_DIR` if you set one for cmdblocks. With
[shdeps](https://github.com/cgraf78/shdeps), declare `cgraf78/tmux-tools`
and drop `cgraf78/cmdblocks`.

This repository keeps its last commands, man pages, and installer so that
existing checkouts and links keep working until you switch. The history of
the three commands up to the move lives here.

## License

MIT. See [`LICENSE`](LICENSE).

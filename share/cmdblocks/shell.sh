# shellcheck shell=bash
# cmdblocks shell integration.
#
# Source this file from shell startup when a host wants all dependency shell
# loaders to follow the same convention:
#   . "$(shdeps dep-file cgraf78/cmdblocks share/cmdblocks/shell.sh)"

# shellcheck disable=SC2034 # public marker for callers that verify the loader ran.
CMDBLOCKS_SHELL_LOADED=1

# ---------------------------------------------------------------------------
# Public API - stable shell integration surface
# ---------------------------------------------------------------------------
# cmdblocks currently exports no interactive shell functions. Its stable public
# surface is the command set in bin/.

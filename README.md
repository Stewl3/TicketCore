# TicketCore

## Install on Windows

Download `TicketCore-Setup-<version>.exe` from the repository's [Releases](https://github.com/Stewl3/TicketCore-Work-Iteration/releases), run it, and follow the setup wizard. The installer creates a Start menu shortcut, an optional desktop shortcut, and an uninstall entry for the current Windows user. It does not require administrator privileges.

The installer starts with no ticket or parts records. TicketCore stores its data in `%LOCALAPPDATA%\TicketCore\output\data`, including the `Tickets` folder. Updates and uninstallation leave this data in place; remove it manually only if you no longer need it.

The installer is not digitally signed, so Windows SmartScreen may show a warning.

## Publish a Windows release

Push the source changes, then push a version tag such as `v1.0.0`. The Windows installer workflow builds the executable and attaches the installer to a GitHub Release for that tag. Tags must use the `vMAJOR.MINOR.PATCH` format. GitHub Actions must have permission to write repository contents.

The release installer contains the executable only, not the checkout's ticket or parts data. Removing files from the current checkout does not remove previously committed records from Git history.

For development builds, see [the build guide](docs/START_HERE.md). Development builds continue to use the checkout's `output\data` directory.

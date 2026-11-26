# TicketCore

## Install on Windows

Download `TicketCore-Setup-<version>.exe` from the repository's [Releases](https://github.com/Stewl3/TicketCore-Work-Iteration/releases), run it, and follow the setup wizard. The installer creates a Start menu shortcut, an optional desktop shortcut, and an uninstall entry for the current Windows user. It does not require administrator privileges.

The installer starts with no ticket or parts records. TicketCore stores its data in `%LOCALAPPDATA%\TicketCore\output\data`, including the `Tickets` folder. Updates and uninstallation leave this data in place; remove it manually only if you no longer need it.

Releases may be unsigned or signed with a self-signed test certificate. Neither establishes a trusted publisher, so Windows may show an unknown publisher or SmartScreen warning.

## Publish a Windows release

Push the source changes, then push a version tag such as `v1.0.0`. The Windows installer workflow builds the executable and attaches the installer to a GitHub Release for that tag. Tags must use the `vMAJOR.MINOR.PATCH` format. GitHub Actions must have permission to write repository contents.

The release installer contains the executable only, not the checkout's ticket or parts data. Removing files from the current checkout does not remove previously committed records from Git history.

### Optional test signature

The workflow can sign the installer with a password-protected, self-signed code-signing certificate for testing. Create one on Windows, keeping the PFX and password private:

```powershell
$cert = New-SelfSignedCertificate -Type CodeSigningCert -Subject 'CN=TicketCore Test Signing' -CertStoreLocation 'Cert:\CurrentUser\My' -KeyExportPolicy Exportable
$password = Read-Host 'PFX password' -AsSecureString
Export-PfxCertificate -Cert $cert -FilePath "$env:USERPROFILE\TicketCore-test-signing.pfx" -Password $password
```

In the repository's GitHub Actions secrets, set `SIGNING_PFX_PASSWORD` to that password and `SIGNING_PFX_BASE64` to the output of `[Convert]::ToBase64String([IO.File]::ReadAllBytes("$env:USERPROFILE\TicketCore-test-signing.pfx"))`. Treat that output like the private key: do not commit or share it. The runner deletes its temporary PFX after signing. With neither secret set, releases remain unsigned; if only one is set or signing fails, the release fails.

The signature is untrusted on other machines unless they explicitly trust the test certificate. Do not ask users to trust it for production; use a certificate from a recognized code-signing provider for a trusted publisher instead. Only the installer is signed, not the installed executable.

For development builds, see [the build guide](docs/START_HERE.md). Development builds continue to use the checkout's `output\data` directory.

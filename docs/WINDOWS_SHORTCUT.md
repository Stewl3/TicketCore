# Windows desktop shortcut

The Windows installer creates a desktop shortcut automatically; see the [installation instructions](../README.md#install-on-windows). The steps below are for development builds in a checkout.

After building TicketCore, register its right-click command once in PowerShell:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\register-ticketcore-context-menu.ps1
```

In Explorer, right-click `output\bin\ticketcore.exe` and choose **Create TicketCore desktop shortcut**. On Windows 11, first choose **Show more options**. This creates `TicketCore.lnk` on the desktop with `icon.ico` and the project root as its working directory. It will not overwrite an existing `TicketCore.lnk`.

The menu is registered for the current Windows user and points to this project location. Register it again if the project moves. It is filtered to files named `ticketcore.exe` and only accepts this project's executable. Windows' built-in **Create shortcut** command is unchanged.

To remove the command:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\register-ticketcore-context-menu.ps1 -Unregister
```

The existing shortcut script can also create shortcuts directly:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\create-ticketcore-shortcut.ps1 -Location Both
```

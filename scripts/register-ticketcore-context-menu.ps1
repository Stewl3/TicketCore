param(
    [switch]$Unregister
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$key = 'HKCU:\Software\Classes\exefile\shell\TicketCore.CreateShortcut'

if ($Unregister) {
    if (Test-Path -LiteralPath $key) {
        Remove-Item -LiteralPath $key -Recurse
        Write-Host 'Removed the TicketCore shortcut context menu.'
    } else {
        Write-Host 'The TicketCore shortcut context menu is not registered.'
    }
    return
}

$script = Join-Path $PSScriptRoot 'create-ticketcore-shortcut.ps1'
$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$executable = Join-Path $projectRoot 'output\bin\ticketcore.exe'
$icon = Join-Path $projectRoot 'icon.ico'
foreach ($file in @($script, $executable, $icon)) {
    if (-not (Test-Path -LiteralPath $file -PathType Leaf)) {
        throw "Required file was not found: $file"
    }
}

$powershell = Join-Path $env:SystemRoot 'System32\WindowsPowerShell\v1.0\powershell.exe'
$command = "`"$powershell`" -NoProfile -ExecutionPolicy Bypass -File `"$script`" -Executable `"%1`""
New-Item -Path $key -Force | Out-Null
Set-Item -Path $key -Value 'Create TicketCore desktop shortcut'
New-ItemProperty -Path $key -Name 'AppliesTo' -Value 'System.FileName:="ticketcore.exe"' -PropertyType String -Force | Out-Null
New-ItemProperty -Path $key -Name 'Icon' -Value $icon -PropertyType String -Force | Out-Null
New-Item -Path (Join-Path $key 'command') -Force | Out-Null
Set-Item -Path (Join-Path $key 'command') -Value $command
Write-Host 'Registered the TicketCore shortcut context menu for the current Windows user.'

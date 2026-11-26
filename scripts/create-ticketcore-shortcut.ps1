param(
    [ValidateSet("Desktop", "StartMenu", "Both")]
    [string]$Location = "Desktop"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$executable = Join-Path $projectRoot 'output\bin\ticketcore.exe'
$iconPath = Join-Path $projectRoot 'icon.ico'

if (-not (Test-Path $executable)) {
    throw "TicketCore executable was not found at: $executable"
}

if (-not (Test-Path $iconPath)) {
    throw "Custom icon was not found at: $iconPath"
}

function New-TicketCoreShortcut([string]$folder) {
    New-Item -ItemType Directory -Force $folder | Out-Null
    $shortcutPath = Join-Path $folder 'TicketCore.lnk'

    $shell = New-Object -ComObject WScript.Shell
    $shortcut = $shell.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = $executable
    $shortcut.WorkingDirectory = $projectRoot
    $shortcut.Description = 'Open TicketCore'
    $shortcut.IconLocation = "$iconPath,0"
    $shortcut.WindowStyle = 1
    $shortcut.Save()

    [Runtime.InteropServices.Marshal]::ReleaseComObject($shortcut) | Out-Null
    [Runtime.InteropServices.Marshal]::ReleaseComObject($shell) | Out-Null

    Write-Host "Created: $shortcutPath"
}

if ($Location -in @('Desktop', 'Both')) {
    New-TicketCoreShortcut ([Environment]::GetFolderPath('Desktop'))
}

if ($Location -in @('StartMenu', 'Both')) {
    New-TicketCoreShortcut (Join-Path ([Environment]::GetFolderPath('StartMenu')) 'Programs')
}

Write-Host "Executable: $executable"
Write-Host "Icon: $iconPath"

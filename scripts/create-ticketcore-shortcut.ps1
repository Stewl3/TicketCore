param(
    [ValidateSet("Desktop", "StartMenu", "Both")]
    [string]$Location = "Desktop",
    [string]$Executable
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$expectedExecutable = Join-Path $projectRoot 'output\bin\ticketcore.exe'
$iconPath = Join-Path $projectRoot 'icon.ico'

function New-TicketCoreShortcut([string]$folder) {
    New-Item -ItemType Directory -Force $folder | Out-Null
    $shortcutPath = Join-Path $folder 'TicketCore.lnk'

    if ($Executable -and (Test-Path -LiteralPath $shortcutPath)) {
        throw "Shortcut already exists; it was not overwritten: $shortcutPath"
    }

    $shell = New-Object -ComObject WScript.Shell
    $shortcut = $shell.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = $expectedExecutable
    $shortcut.WorkingDirectory = $projectRoot
    $shortcut.Description = 'Open TicketCore'
    $shortcut.IconLocation = "$iconPath,0"
    $shortcut.WindowStyle = 1
    $shortcut.Save()

    [Runtime.InteropServices.Marshal]::ReleaseComObject($shortcut) | Out-Null
    [Runtime.InteropServices.Marshal]::ReleaseComObject($shell) | Out-Null

    Write-Host "Created: $shortcutPath"
}

try {
    if ($Executable -and
        [IO.Path]::GetFullPath($Executable) -ine [IO.Path]::GetFullPath($expectedExecutable)) {
        throw "Select this project's TicketCore executable: $expectedExecutable"
    }

    if (-not (Test-Path -LiteralPath $expectedExecutable -PathType Leaf)) {
        throw "TicketCore executable was not found at: $expectedExecutable"
    }

    if (-not (Test-Path -LiteralPath $iconPath -PathType Leaf)) {
        throw "Custom icon was not found at: $iconPath"
    }

    if ($Location -in @('Desktop', 'Both')) {
        New-TicketCoreShortcut ([Environment]::GetFolderPath('Desktop'))
    }

    if ($Location -in @('StartMenu', 'Both')) {
        New-TicketCoreShortcut (Join-Path ([Environment]::GetFolderPath('StartMenu')) 'Programs')
    }

    Write-Host "Executable: $expectedExecutable"
    Write-Host "Icon: $iconPath"
} catch {
    if ($Executable) {
        Add-Type -AssemblyName System.Windows.Forms
        [System.Windows.Forms.MessageBox]::Show($_.Exception.Message, 'TicketCore shortcut') | Out-Null
    }
    throw
}

param(
    [Parameter(Mandatory = $true)]
    [string]$Executable
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$executablePath = (Resolve-Path -LiteralPath $Executable).Path
$testRoot = Join-Path ([IO.Path]::GetTempPath()) ("ticketcore-startup-" + [guid]::NewGuid())
$originalLocalAppData = $env:LOCALAPPDATA
New-Item -ItemType Directory -Path $testRoot | Out-Null

try {
    $env:LOCALAPPDATA = $testRoot
    $tickets = Join-Path $testRoot 'TicketCore\output\data\Tickets'
    $process = Start-Process -FilePath $executablePath -WorkingDirectory $testRoot -PassThru
    try {
        for ($i = 0; $i -lt 100 -and -not (Test-Path -LiteralPath $tickets -PathType Container); $i++) {
            if ($process.HasExited) {
                throw "TicketCore exited before creating its data folder: $($process.ExitCode)"
            }
            Start-Sleep -Milliseconds 100
        }
        if (-not (Test-Path -LiteralPath $tickets -PathType Container)) {
            throw 'TicketCore did not create its Tickets folder.'
        }
        if (@(Get-ChildItem -LiteralPath $tickets -Force).Count -ne 0) {
            throw 'A fresh Tickets folder should be empty.'
        }
    } finally {
        if (-not $process.HasExited) {
            Stop-Process -Id $process.Id
        }
    }

    $env:LOCALAPPDATA = ''
    $errorFile = Join-Path $testRoot 'startup-error.txt'
    $process = Start-Process -FilePath $executablePath -WorkingDirectory $testRoot -RedirectStandardError $errorFile -PassThru -Wait
    if ($process.ExitCode -ne 1 -or (Get-Content -LiteralPath $errorFile -Raw) -notmatch 'LOCALAPPDATA is not set') {
        throw 'TicketCore did not report the missing LOCALAPPDATA variable.'
    }
    Write-Host 'Installed startup checks passed.'
} finally {
    $env:LOCALAPPDATA = $originalLocalAppData
    Remove-Item -LiteralPath $testRoot -Recurse -Force
}

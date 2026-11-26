param(
    [Parameter(Mandatory = $true)]
    [string]$CertificatePath,

    [Parameter(Mandatory = $true)]
    [string]$CertificatePassword,

    [string]$ExecutablePath = "../output/bin/ticketcore.exe",
    [string]$TimestampUrl = "http://timestamp.digicert.com",
    [string]$Description = "TicketCore"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$projectRoot = Resolve-Path (Join-Path $PSScriptRoot '..')
$executable = (Resolve-Path (Join-Path $projectRoot $ExecutablePath)).Path
$certificate = (Resolve-Path $CertificatePath).Path

$signTool = Get-Command signtool.exe -ErrorAction SilentlyContinue
if (-not $signTool) {
    throw "SignTool.exe was not found. Install Windows SDK or use Developer Command Prompt for VS."
}

$securePassword = ConvertTo-SecureString $CertificatePassword -AsPlainText -Force

& signtool.exe sign /fd SHA256 /td SHA256 /tr $TimestampUrl /d $Description /f $certificate /p $CertificatePassword /a $executable
if ($LASTEXITCODE -ne 0) {
    throw "Signing failed with exit code $LASTEXITCODE"
}

& signtool.exe verify /pa /all /v $executable
if ($LASTEXITCODE -ne 0) {
    throw "Signed executable verification failed with exit code $LASTEXITCODE"
}

Write-Host "Verified digital signature: $executable"

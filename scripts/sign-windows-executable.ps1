param(
    [Parameter(Mandatory = $true)]
    [string]$CertificatePath,

    [Parameter(Mandatory = $true)]
    [string]$CertificatePassword,

    [string]$ExecutablePath = "../output/bin/ticketcore.exe",
    [string]$TimestampUrl = "http://timestamp.digicert.com",
    [string]$Description = "TicketCore",
    [switch]$AllowUntrustedTestCertificate
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$projectRoot = Resolve-Path (Join-Path $PSScriptRoot '..')
if ([IO.Path]::IsPathRooted($ExecutablePath)) {
    $executable = (Resolve-Path -LiteralPath $ExecutablePath).Path
} else {
    $executable = (Resolve-Path -LiteralPath (Join-Path $projectRoot $ExecutablePath)).Path
}
$certificate = (Resolve-Path $CertificatePath).Path

$signTool = Get-Command signtool.exe -ErrorAction SilentlyContinue
if (-not $signTool) {
    $sdkBin = Join-Path ${env:ProgramFiles(x86)} 'Windows Kits\10\bin'
    if (Test-Path -LiteralPath $sdkBin) {
        $signTool = Get-ChildItem -LiteralPath $sdkBin -Directory |
            Sort-Object Name -Descending |
            ForEach-Object { Join-Path $_.FullName 'x64\signtool.exe' } |
            Where-Object { Test-Path -LiteralPath $_ } |
            Select-Object -First 1
    }
}
if (-not $signTool) {
    throw "SignTool.exe was not found. Install Windows SDK or use Developer Command Prompt for VS."
}
if ($signTool -is [System.Management.Automation.CommandInfo]) {
    $signTool = $signTool.Source
}

$signingCertificate = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2(
    $certificate, $CertificatePassword,
    [System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::EphemeralKeySet
)
try {
    $expectedThumbprint = $signingCertificate.Thumbprint
    if ($AllowUntrustedTestCertificate -and $signingCertificate.Subject -ne $signingCertificate.Issuer) {
        throw "The untrusted test certificate must be self-signed."
    }
} finally {
    $signingCertificate.Dispose()
}

& $signTool sign /fd SHA256 /td SHA256 /tr $TimestampUrl /d $Description /f $certificate /p $CertificatePassword /a $executable
if ($LASTEXITCODE -ne 0) {
    throw "Signing failed with exit code $LASTEXITCODE"
}

$signature = Get-AuthenticodeSignature -LiteralPath $executable
if (-not $signature.SignerCertificate -or $signature.SignerCertificate.Thumbprint -ne $expectedThumbprint) {
    throw "The executable was not signed by the supplied certificate."
}
if (-not $signature.TimeStamperCertificate) {
    throw "The executable signature has no timestamp."
}
$untrustedRootMessage = (New-Object System.ComponentModel.Win32Exception(-2146762487)).Message
$untrustedRoot = $signature.StatusMessage.TrimEnd('.', ' ') -eq $untrustedRootMessage.TrimEnd('.', ' ')
if ($AllowUntrustedTestCertificate -and $untrustedRoot) {
    Write-Warning "The test signature is untrusted. Windows may display an unknown publisher or SmartScreen warning."
    return
}
if ($signature.Status -ne 'Valid') {
    throw "Signed executable verification failed: $($signature.Status) - $($signature.StatusMessage)"
}

& $signTool verify /pa /all /v $executable
if ($LASTEXITCODE -ne 0) {
    throw "Signed executable verification failed with exit code $LASTEXITCODE"
}

Write-Host "Verified digital signature: $executable"

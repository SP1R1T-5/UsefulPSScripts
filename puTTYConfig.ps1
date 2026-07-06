# Installs PuTTY (if not already present), then creates a saved session in the registry.

$sessionName = "test"
$targetHost  = "127.0.0.1"

# Install PuTTY if it's not already there
$putty = Get-Command putty.exe -ErrorAction SilentlyContinue
if ($putty) {
    Write-Host "PuTTY already installed - skipping install."
} else {
    Write-Host "Installing PuTTY via winget..."
    winget install --id PuTTY.PuTTY -e --accept-source-agreements --accept-package-agreements
}

# Create the saved session in the registry
$key = "HKCU\Software\SimonTatham\PuTTY\Sessions\$sessionName"
reg add $key /v HostName   /d $targetHost /f | Out-Null
reg add $key /v Protocol   /d ssh         /f | Out-Null
reg add $key /v PortNumber /t REG_DWORD /d 22 /f | Out-Null

# Confirm the Config Set
reg query $key

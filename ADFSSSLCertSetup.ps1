#Requires -RunAsAdministrator
# =============================================================================
# New-AdfsSslCert.ps1
# Creates a self-signed SSL certificate for ADFS on jon.local
# Run this on the ADFS server as Administrator
# =============================================================================
 
$fqdn = "jon.local"
 
# --- Create the certificate ---
$cert = New-SelfSignedCertificate `
    -DnsName $fqdn `
    -CertStoreLocation "Cert:\LocalMachine\My" `
    -FriendlyName "ADFS SSL Certificate - $fqdn" `
    -NotAfter (Get-Date).AddYears(5) `
    -KeyLength 2048 `
    -KeyAlgorithm RSA `
    -HashAlgorithm SHA256 `
    -KeyExportPolicy Exportable `
    -KeyUsage DigitalSignature, KeyEncipherment `
    -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.1") # Server Authentication EKU
 
Write-Host ""
Write-Host "Certificate created successfully!" -ForegroundColor Green
Write-Host "  Subject:      CN=$fqdn" 
Write-Host "  Thumbprint:   $($cert.Thumbprint)"
Write-Host "  Expires:      $($cert.NotAfter)"
Write-Host "  Store:        LocalMachine\My (Personal)"
Write-Host ""
 
# --- Export PFX (optional - useful for backup) ---
$exportPath = "$env:USERPROFILE\Desktop\$($fqdn)_ADFS_SSL.pfx"
$pfxPassword = Read-Host -Prompt "Enter a password to export the PFX (or press Enter to skip export)" -AsSecureString
 
if ($pfxPassword.Length -gt 0) {
    Export-PfxCertificate `
        -Cert "Cert:\LocalMachine\My\$($cert.Thumbprint)" `
        -FilePath $exportPath `
        -Password $pfxPassword | Out-Null
 
    Write-Host "PFX exported to: $exportPath" -ForegroundColor Green
} else {
    Write-Host "PFX export skipped." -ForegroundColor Yellow
}

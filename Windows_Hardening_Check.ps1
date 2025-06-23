<#
    Script Name: Windows_Hardening_Check.ps1
    Author: Kaleb
    Description: Performs basic Windows hardening checks and logs results to a timestamped report file.
    Date Created: 2025-06-17
#>

# Generate timestamp and define log file path
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$logFile = "$PSScriptRoot\SecurityAudit_$timestamp.txt"

# Logging function: prints to console and logs to file
function Log {
    param ($message)
    Write-Output $message
    Add-Content -Path $logFile -Value $message
}

Log "Starting Windows Security Audit - $timestamp`n"

# ------------------ FIREWALL CHECK ------------------
Log "Checking Windows Firewall status..."

$firewallStatus = (Get-NetFirewallProfile | Where-Object {$_.Enabled -eq 'True'}).Count

if ($firewallStatus -ge 1) {
    Log "Firewall is ENABLED on at least one profile.`n"
} else {
    Log "WARNING: Firewall is DISABLED on all profiles.`n"
}

# ------------------ GUEST ACCOUNT CHECK ------------------
Log "Checking if Guest account is enabled..."

$guestAccount = Get-LocalUser -Name "Guest"

if ($guestAccount.Enabled -eq $true) {
    Log "WARNING: Guest account is ENABLED. This is a security risk.`n"
} else {
    Log "Guest account is DISABLED.`n"
}

# ------------------ REMOTE DESKTOP (RDP) CHECK ------------------
Log "Checking if Remote Desktop (RDP) is enabled..."

$rdpStatus = Get-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections"

if ($rdpStatus.fDenyTSConnections -eq 0) {
    Log "WARNING: Remote Desktop is ENABLED. This can be a security risk.`n"
} else {
    Log "Remote Desktop is DISABLED.`n"
}

Log "Security Audit Complete. Report saved to: $logFile"

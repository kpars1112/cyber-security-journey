# Get the current date and time for the report name
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"

# Define the path for saving scan report
$reportPath = "$PSScriptRoot\ScanReport_$timestamp.txt"

# Define the path to Nmap
$nmapPath = "C:\Program Files (x86)\Nmap\nmap.exe"

# Define the target to scan (localhost)
$target = "127.0.0.1"

# Let the user know scanning has started
Write-Output "Scanning $target..."

# Run the Nmap scan and save output
& $nmapPath -sS -T4 $target | Out-File -Encoding UTF8 -FilePath $reportPath

# Let the user know it's done
Write-Output "`nScan Complete. Report saved to:"
Write-Output $reportPath

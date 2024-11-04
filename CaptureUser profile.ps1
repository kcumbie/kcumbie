# Change directory to the script's location
Set-Location -Path $PSScriptRoot

# Get the logged-on username
$localuser = (Get-WmiObject -Class Win32_ComputerSystem).Username
$username1= $localuser -split '\\' | Select-Object -Last 1


# Get the hostname
$hostname = $env:COMPUTERNAME

# User Profile Path
$UserProfile = "C:\Users\$username1"
# Define array of process names
$processesToStop = @('OUTLOOK', 'Teams', 'msedge', 'Chrome', 'OneDrive')



# Define the path for the Capture.txt file
$CaptureFilePath = Join-Path -Path $UserProfile -ChildPath 'Capture.txt'

# Content to write to the Capture.txt file
$Content = "This is a capture file created for the logged-on user."

# Write the content to the Capture.txt file
Set-Content -Path $CaptureFilePath -Value $Content

Write-Output "Capture.txt has been created in the user's profile directory: $CaptureFilePath"


# Loop through the array and stop each process
foreach ($process in $processesToStop) {
    Stop-Process -Name $process -Force -ErrorAction SilentlyContinue
}

# Define network share path and create a mapped drive
$SharePath = "\\Network share\$username1"


# Create a network directory for the user
$NetworkDirectory = "$SharePath\$username1"
New-Item -Path $NetworkDirectory -ItemType Directory -Force -ErrorAction SilentlyContinue

# Destination Path
$Destination = $NetworkDirectory

# Time-Stamp
$DateTime = Get-Date -Format "yyyy-MM-dd HH-mm-ss"

# Define paths for Chrome, Firefox, Edge, and Outlook
#$ChromeBm    = "$UserProfile\AppData\Local\Google\Chrome\User Data\Default\Bookmarks"
#$FirefoxProf = "$UserProfile\AppData\Roaming\Mozilla\Firefox\Profiles\*"
#$OutlookSig  = "$UserProfile\AppData\Roaming\Microsoft\Signatures"
#$EdgeBm      = "$UserProfile\AppData\Local\Microsoft\Edge\User Data\Default\Bookmarks"



# Profile folders to exclude
# Profile folders to exclude
$ExcludesFolder = @(
    '.dotnet', '.vscode', 'AppData', 'Application Data', 'Cookies', 'IntelGraphicsProfiles',
    'Local Settings', 'MicrosoftEdgeBackups', 'Nethood', 'OneDrive', 'SendTo', 'source', 'Start Menu', 'Templates', '3D Objects', 'Links', 'PrintHood', 'Recent', 'Saved Games', 'Searches', '.ms-ad'
)

# Create excluded folder paths and wrap in quotes for robustness
$ExcludeFolders = $ExcludesFolder | ForEach-Object { '"' + "$UserProfile\$_" + '"' }

# Join the excluded folder paths for use with Robocopy
$ExcludeParams = $ExcludeFolders -join ' '

# Destination path
$Destination = "$NetworkDirectory"

# Robocopy parameters
$RobocopyParams = "/E /B /XA:SH /XD $ExcludeParams, .* /R:5 /W:15 /MT:40 /Z /XO /NP /NC /BYTES"

# Log file for Robocopy
$RoboFinalLog = "$Destination\RobocopyLog.txt"

# Create the destination directory if it doesn't exist
if (-not (Test-Path -Path $Destination)) {
    New-Item -Path $Destination -ItemType Directory -Force
}

# Start the Robocopy process
Start-Process -FilePath "robocopy" -ArgumentList "$UserProfile", "$Destination", $RobocopyParams, "/LOG:$RoboFinalLog" -NoNewWindow -Wait




# Copy Chrome Bookmarks
#Write-Output "Copying Chrome Bookmarks to $Destination\Chrome"
#New-Item -Path "$Destination\Chrome" -ItemType Directory -Force -ErrorAction SilentlyContinue
#Copy-Item -Path $ChromeBm -Destination "$Destination\Chrome" -Force -ErrorAction SilentlyContinue

# Copy Edge Bookmarks
#Write-Output "Copying Edge Bookmarks to $Destination\Edge"
#New-Item -Path "$Destination\Edge" -ItemType Directory -Force -ErrorAction SilentlyContinue
#Copy-Item -Path $EdgeBm -Destination "$Destination\Edge" -Force -ErrorAction SilentlyContinue


# Copy Outlook signatures
#Write-Output "Copying Outlook Signatures to $Destination\Signatures"
#Copy-Item -Path $OutlookSig -Destination "$Destination\Signatures" -Recurse -Force -ErrorAction SilentlyContinue


# Get Network Printers
Write-Output "Creating network printer list to $Destination\printers"
Get-WmiObject -Query "Select Name from Win32_Printer Where Network = True" | ForEach-Object { $_.Name } | Out-File -FilePath "$Destination\printers" -Encoding UTF8

# Get Network folders
Write-Output "Creating network folders text file to $Destination\netFolders"
net use | Out-File -FilePath "$Destination\netFolders" -Encoding UTF8

# Ensure permissions are set for the destination
$samAccountName = $username1  # Assuming the username is the same as the account name
& icacls $Destination /setowner "$env:userdomain\$samAccountName" /T /C
& icacls $Destination /grant "$env:userdomain\$samAccountName`:(OI)(CI)F" /T


# Output completion message
Write-Output "Profile copy completed successfully."

# End

$strUser = "Domainname\user"
$strDomain = "corp.123.com"
$strPassword = ConvertTo-SecureString "password" -AsPlainText -Force
$Credentials = New-Object System.Management.Automation.PsCredential $strUser,
$strPassword
$strOU = "CN=Computers,DC=corp,DC=123,DC=com"

Add-computer -DomainName $strDomain -Credential $Credentials -OUPath $strOU




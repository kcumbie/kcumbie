#Remove-Computer -passthru -verbose -force
#Add-Computer -Workgroup "WORKGROUP"
#(GWMI Win32_ComputerSystem).JoinDomainOrWorkgroup("WORKGROUP", $pass, $urs, $null, 3)
(GWMI Win32_ComputerSystem).UnJoinDomainOrWorkgroup()
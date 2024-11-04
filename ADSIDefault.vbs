option Explicit

Dim objSysInfo, strComputerDN, objComputer, strDescr

' Retrieve DN of local computer object in AD.
Set objSysInfo = CreateObject("ADSystemInfo")
strComputerDN = objSysInfo.ComputerName

' Bind to the computer object in AD.
Set objComputer = GetObject("LDAP://" & strComputerDN)

' Assign description and save.
objComputer.employeeType = "Workstation"
objComputer.SetInfo

' Assign description and save.
objComputer.employeeSubtype = "Default"
objComputer.SetInfo
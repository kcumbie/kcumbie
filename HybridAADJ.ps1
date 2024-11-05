REG.EXE ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CDJ\AAD" /v TenantId /t REG_SZ /d TenetID /f
REG.EXE ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CDJ\AAD" /v TenantName /t REG_SZ /d Tenant.onmicrosoft.com /f
REG.EXE ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\WorkplaceJoin" /v autoWorkplaceJoin /t REG_DWORD /d 1 /f
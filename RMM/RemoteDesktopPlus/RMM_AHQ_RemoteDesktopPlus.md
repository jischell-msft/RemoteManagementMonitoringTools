# Advanced Hunting Query for RemoteDesktopPlus

### Create Process 
```
let Time_start = now(-5d);
let Time_end = now();
//
let rmmProcess = 
DeviceProcessEvents 
| where Timestamp between (Time_start..Time_end)
| where ProcessVersionInfoCompanyName has 'www.donkz.nl'
    and ProcessVersionInfoProductName has 'Remote Desktop Plus'
    and ProcessVersionInfoOriginalFileName has 'rdp.exe'
| summarize FirstSeen=min(Timestamp), LastSeen=max(Timestamp), 
    Report=make_set(ReportId), Count=count() by DeviceId, DeviceName, AccountUpn 
| extend rmmProcessName = 'RemoteDesktopPlus' 
; 
rmmProcess
```

### File Signature
```
```

### Network Connection
```
let Time_start = now(-5d);
let Time_end = now();
//
let rmmNetwork = 
DeviceNetworkEvents
| where Timestamp between (Time_start..Time_end)
| where InitiatingProcessVersionInfoCompanyName has 'www.donkz.nl'
    and InitiatingProcessVersionInfoProductName has 'Remote Desktop Plus'
    and InitiatingProcessVersionInfoOriginalFileName has 'rdp.exe'
| summarize FirstSeen=min(Timestamp), LastSeen=max(Timestamp), 
    Report=make_set(ReportId), Count=count() by DeviceId, DeviceName,
    AccountUpn, RemoteUrl 
| extend rmmNetworkName = 'RemoteDesktopPlus'
;
rmmNetwork
```
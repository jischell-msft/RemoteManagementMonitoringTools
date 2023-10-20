# Advanced Hunting Query for ChromeRDP

### Create Process 
```
let Time_start = now(-5d);
let Time_end = now();
//
let rmmProcess = 
DeviceProcessEvents 
| where Timestamp between (Time_start..Time_end)
| where ProcessVersionInfoCompanyName has 'Google'
    and ProcessVersionInfoProductName has 'Chrome Remote Desktop'
| summarize FirstSeen=min(Timestamp), LastSeen=max(Timestamp), 
    Report=make_set(ReportId), Count=count() by DeviceId, DeviceName, AccountUpn 
| extend rmmProcessName = 'ChromeRDP' 
; 
rmmProcess
```

### Network Connection
```
let Time_start = now(-5d);
let Time_end = now();
//
let rmmNetwork = 
DeviceNetworkEvents
| where Timestamp between (Time_start..Time_end)
| where RemoteUrl has 'remotedesktop-pa.googleapis.com'
    and InitiatingProcessVersionInfoCompanyName has 'Google'
    and InitiatingProcessVersionInfoProductName has 'Chrome Remote Desktop'
| summarize FirstSeen=min(Timestamp), LastSeen=max(Timestamp), 
    Report=make_set(ReportId), Count=count() by DeviceId, DeviceName,
    AccountUpn, RemoteUrl 
| extend rmmNetworkName = 'ChromeRDP'
;
rmmNetwork
```
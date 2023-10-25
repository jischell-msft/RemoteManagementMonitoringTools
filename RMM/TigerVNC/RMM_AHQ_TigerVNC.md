# Advanced Hunting Query for TigerVNC

### Create Process 
```
let Time_start = now(-5d);
let Time_end = now();
//
let rmmProcess = 
DeviceProcessEvents 
| where Timestamp between (Time_start..Time_end)
| where ProcessVersionInfoCompanyName has 'TigerVNC'
    and ProcessVersionInfoProductName has 'TigerVNC'
| summarize FirstSeen=min(Timestamp), LastSeen=max(Timestamp), 
    Report=make_set(ReportId), Count=count() by DeviceId, DeviceName, AccountUpn 
| extend rmmProcessName = 'TigerVNC' 
; 
rmmProcess
```

### File Signature
```
```

### Network Connection
This query will identify network connections associated with TigerVNC; TigerVNC does not appear to have consistent network callbacks.
```
let Time_start = now(-5d);
let Time_end = now();
//
let rmmNetwork = 
DeviceNetworkEvents
| where Timestamp between (Time_start..Time_end)
| where InitiatingProcessVersionInfoCompanyName has 'TigerVNC'
    and InitiatingProcessVersionInfoProductName has 'TigerVNC'
| summarize FirstSeen=min(Timestamp), LastSeen=max(Timestamp), 
    Report=make_set(ReportId), Count=count() by DeviceId, DeviceName,
    AccountUpn, RemoteUrl 
| extend rmmNetworkName = 'TigerVNC'
;
rmmNetwork
```
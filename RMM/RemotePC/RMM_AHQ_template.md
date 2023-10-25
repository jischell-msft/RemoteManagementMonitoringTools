# Advanced Hunting Query for RemotePC

### Create Process 
```
let Time_start = now(-5d);
let Time_end = now();
//
let rmmProcess = 
DeviceProcessEvents 
| where Timestamp between (Time_start..Time_end)
| where ProcessVersionInfoCompanyName has 'idrive'
    and ProcessVersionInfoProductName has_any (
        'remotepc',
        'viewer',
        'remotedesktop'
    )
| summarize FirstSeen=min(Timestamp), LastSeen=max(Timestamp), 
    Report=make_set(ReportId), Count=count() by DeviceId, DeviceName, AccountUpn 
| extend rmmProcessName = 'RemotePC' 
; 
rmmProcess
```

### File Signature
```
let Time_start = now(-5d);
let Time_end = now();
//
let rmmFileSig = 
DeviceFileCertificateInfo
| where Timestamp between (Time_start..Time_end)
| where Signer has 'idrive'
| summarize FirstSeen=min(Timestamp), LastSeen=max(Timestamp), 
    Report=make_set(ReportId), Count=count() by DeviceId, DeviceName
| extend rmmFileSigName = 'RemotePC' 
;
rmmFileSig
```

### Network Connection
```
let Time_start = now(-5d);
let Time_end = now();
//
let rmmNetwork = 
DeviceNetworkEvents
| where Timestamp between (Time_start..Time_end)
| where RemoteUrl has 'remotepc.com'
    and InitiatingProcessVersionInfoCompanyName has 'idrive'
    and InitiatingProcessVersionInfoProductName has_any (
        'remotepc',
        'viewer',
        'remotedesktop'
    )
| summarize FirstSeen=min(Timestamp), LastSeen=max(Timestamp), 
    Report=make_set(ReportId), Count=count() by DeviceId, DeviceName,
    AccountUpn, RemoteUrl 
| extend rmmNetworkName = 'RemotePC'
;
rmmNetwork
```
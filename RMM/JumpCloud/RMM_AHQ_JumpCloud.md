# Advanced Hunting Query for JumpCloud

### Create Process 
```
let Time_start = now(-5d);
let Time_end = now();
//
let rmmProcess = 
DeviceProcessEvents 
| where Timestamp between (Time_start..Time_end)
| where ( ProcessVersionInfoCompanyName has 'JumpCloud'
    or isempty(ProcessVersionInfoCompanyName)
    and FileName has 'JumpCloud'
    and FileName has_any ('remote', 'assist', 'agent')
| summarize FirstSeen=min(Timestamp), LastSeen=max(Timestamp), 
    Report=make_set(ReportId), Count=count() by DeviceId, DeviceName, AccountUpn 
| extend rmmProcessName = 'JumpCloud' 
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
| where Signer has 'JumpCloud'
| summarize FirstSeen=min(Timestamp), LastSeen=max(Timestamp), 
    Report=make_set(ReportId), Count=count() by DeviceId, DeviceName
| extend rmmFileSigName = 'JumpCloud' 
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
| where RemoteUrl has_any (
        'assist.jumpcloud.com',
        'api.jumpcloud.com'
    )
    and (
        InitiatingProcessVersionInfoCompanyName has 'JumpCloud'
     or isempty(InitiatingProcessVersionInfoCompanyName)
    )
| summarize FirstSeen=min(Timestamp), LastSeen=max(Timestamp), 
    Report=make_set(ReportId), Count=count() by DeviceId, DeviceName,
    AccountUpn, RemoteUrl 
| extend rmmNetworkName = 'JumpCloud'
;
rmmNetwork
```
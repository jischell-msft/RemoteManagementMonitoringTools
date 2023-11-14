# Advanced Hunting Query for Itarian

### Create Process 
```
let Time_start = now(-5d);
let Time_end = now();
//
let rmmProcess = 
DeviceProcessEvents 
| where Timestamp between (Time_start..Time_end)
| where ProcessVersionInfoCompanyName has_any (
        'Comodo',
        'Itarian'
    )
    and ProcessVersionInfoProductName has_any (
        'Remote',
        'Endpoint Manager',
        'RMM'
    )
| summarize FirstSeen=min(Timestamp), LastSeen=max(Timestamp), 
    Report=make_set(ReportId), Count=count() by DeviceId, DeviceName, AccountUpn 
| extend rmmProcessName = 'Itarian' 
; 
rmmProcess
```

### File Signature
```
Too broad for use
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
        'xmpp.itsm-us1.comodo.com',
        'xmpp.cmdm.comodo.com',
        'rmm-api.itsm-us1.comodo.com',
        'rmm-api.cmdm.comodo.com'
    )
    and InitiatingProcessVersionInfoCompanyName has_any (
        'Comodo',
        'Itarian'
    )
| summarize FirstSeen=min(Timestamp), LastSeen=max(Timestamp), 
    Report=make_set(ReportId), Count=count() by DeviceId, DeviceName,
    AccountUpn, RemoteUrl 
| extend rmmNetworkName = 'Itarian'
;
rmmNetwork
```
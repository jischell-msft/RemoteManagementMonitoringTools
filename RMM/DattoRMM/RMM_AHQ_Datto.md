# Advanced Hunting Query for Datto

### File Signature
```
let Time_start = now(-5d);
let Time_end = now();
//
let rmmFileSig = 
DeviceFileCertificateInfo
| where Timestamp between (Time_start..Time_end)
| where Signer has 'Datto Inc'
| summarize FirstSeen=min(Timestamp), LastSeen=max(Timestamp), 
    Report=make_set(ReportId), Count=count() by DeviceId, DeviceName
| extend rmmFileSigName = 'Datto' 
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
        'rmm.datto.com',
        'agent.centrastage.net',
        'audit.centrastage.net',
        'monitoring.centrastage.net',
        'agent-notifications.centrastage.net',
        'agent-comms.centrastage.net',
        'update.centrastage.net',
        'realtime.centrastage.net',
        'ts.centrastage.net'
    )
    and ( 
        InitiatingProcessVersionInfoCompanyName has_any ('CentraStage', 'Datto', 'Kaseya' )
    or isempty(InitiatingProcessVersionInfoCompanyName)
    )
| summarize FirstSeen=min(Timestamp), LastSeen=max(Timestamp), 
    Report=make_set(ReportId), Count=count() by DeviceId, DeviceName,
    AccountUpn, RemoteUrl 
| extend rmmNetworkName = 'Datto'
;
rmmNetwork
```
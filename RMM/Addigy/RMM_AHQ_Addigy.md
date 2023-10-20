# Advanced Hunting Query for Addigy

### Network Connection
```
let Time_start = now(-5d);
let Time_end = now();
//
let rmmNetwork = 
DeviceNetworkEvents
| where Timestamp between (Time_start..Time_end)
| where RemoteUrl has_any (
        'prod.addigy.com',
        'grtmprod.addigy.com',
        'agents.addigy.com'
    )
    and InitiatingProcessFileName has_any (
        'go-agent',
        'auditor',
        'collector',
        'xpcproxy',
        'lan-cache',
        'mdmclient',
        'launchd'
    )
    and isempty(InitiatingProcessVersionInfoCompanyName)
| summarize FirstSeen=min(Timestamp), LastSeen=max(Timestamp), 
    Report=make_set(ReportId), Count=count() by DeviceId, DeviceName,
    AccountUpn, RemoteUrl 
| extend rmmNetworkName = 'Addigy'
;
rmmNetwork
```
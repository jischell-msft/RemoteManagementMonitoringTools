# Advanced Hunting Query for NAble

### Create Process 
```
let Time_start = now(-5d);
let Time_end = now();
//
let rmmProcess = 
DeviceProcessEvents 
| where Timestamp between (Time_start..Time_end)
| where ProcessVersionInfoCompanyName has_any (
        'N-Able',
        'SolarWinds MSP',
        'Remote Monitoring',
        'LogicNow Ltd'
    )
| summarize FirstSeen=min(Timestamp), LastSeen=max(Timestamp), 
    Report=make_set(ReportId), Count=count() by DeviceId, DeviceName, AccountUpn 
| extend rmmProcessName = 'NAble' 
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
| where Signer has_any (
        'N-Able Technologies',
        'LogicNow'
    )
| summarize FirstSeen=min(Timestamp), LastSeen=max(Timestamp), 
    Report=make_set(ReportId), Count=count() by DeviceId, DeviceName
| extend rmmFileSigName = 'NAble' 
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
        'remote.management',
        'logicnow.com',
        'logicnow.us',
        'system-monitor.com',
        'systemmonitor.eu.com',
        'systemmonitor.co.uk',
        'systemmonitor.us',
        'n-able.com',
        'rmm-host.com',
        'solarwindsmsp.com'
    )
    and InitiatingProcessVersionInfoCompanyName has_any (
            'Remote Monitoring',
            'LogicNow Ltd',
            'N-Able',
            'SolarWinds MSP'
        )
| summarize FirstSeen=min(Timestamp), LastSeen=max(Timestamp), 
    Report=make_set(ReportId), Count=count() by DeviceId, DeviceName,
    AccountUpn, RemoteUrl 
| extend rmmNetworkName = 'NAble'
;
rmmNetwork
```
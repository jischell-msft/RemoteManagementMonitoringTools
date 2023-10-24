# Advanced Hunting Query for LogMeIn

### Create Process 
```
let Time_start = now(-5d);
let Time_end = now();
//
let rmmProcess = 
DeviceProcessEvents 
| where Timestamp between (Time_start..Time_end)
| where ProcessVersionInfoCompanyName has 'LogMeIn'
    and ProcessVersionInfoProductName has_any (
        'LogMeIn',
        'LogMeInRemoteControl',
        'RemotelyAnywhere'
    )
| summarize FirstSeen=min(Timestamp), LastSeen=max(Timestamp), 
    Report=make_set(ReportId), Count=count() by DeviceId, DeviceName, AccountUpn 
| extend rmmProcessName = 'LogMeIn' 
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
| where Signer has_any ('LogMeIn', 'GoTo, Inc')
| summarize FirstSeen=min(Timestamp), LastSeen=max(Timestamp), 
    Report=make_set(ReportId), Count=count() by DeviceId, DeviceName
| extend rmmFileSigName = 'LogMeIn' 
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
        'update-cdn.logmein.com',
        'secure.logmein.com',
        'update.logmein.com',
        'logmeinrescue.com',
        'logmeinrescue.eu',
        'logmeinrescue-enterprise.com',
        'logmeinrescue-enterprise.eu',
        'remotelyanywhere.com',
        'gotoassist.com',
        'logmeininc.com',
        'logme.in',
        'getgo.com',
        'goto.com',
        'goto-rtc.com',
        'gotomypc.com'
    )
    and InitiatingProcessVersionInfoCompanyName has_any ('LogMeIn', 'GoTo')
| summarize FirstSeen=min(Timestamp), LastSeen=max(Timestamp), 
    Report=make_set(ReportId), Count=count() by DeviceId, DeviceName,
    AccountUpn, RemoteUrl 
| extend rmmNetworkName = 'LogMeIn'
;
rmmNetwork
```
# Advanced Hunting Query for Kaseya

### Create Process 
```

```

### File Signature
```
let Time_start = now(-5d);
let Time_end = now();
//
let rmmFileSig = 
DeviceFileCertificateInfo
| where Timestamp between (Time_start..Time_end)
| where Signer has 'Kaseya'
| summarize FirstSeen=min(Timestamp), LastSeen=max(Timestamp), 
    Report=make_set(ReportId), Count=count() by DeviceId, DeviceName
| extend rmmFileSigName = 'Kaseya' 
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
        'kaseya.com',				
        'stun.kaseya.com',			
        'managedsupport.kaseya.net',
        'kaseya.net'
    )
    and InitiatingProcessVersionInfoCompanyName has 'Kaseya'
    and InitiatingProcessVersionInfoProductName has 'Kaseya'
| summarize FirstSeen=min(Timestamp), LastSeen=max(Timestamp), 
    Report=make_set(ReportId), Count=count() by DeviceId, DeviceName,
    AccountUpn, RemoteUrl 
| extend rmmNetworkName = 'Kaseya'
;
rmmNetwork
```
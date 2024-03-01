# Advanced hunting query for Xeox

### Create Process 
```
let Time_start = now(-5d);
let Time_end = now();
//
let rmmProcess = 
DeviceProcessEvents 
| where Timestamp between (Time_start..Time_end)
| where ProcessVersionInfoCompanyName has 'Xeox'
    or ProcessVersionInfoCompanyName has 'hs2n Informationstechnologie GmbH' or ProcessVersionInfoProductName has 'Xeox'
| summarize FirstSeen=min(Timestamp), LastSeen=max(Timestamp), 
    Report=make_set(ReportId), Count=count() by DeviceId, DeviceName, AccountUpn 
| extend rmmProcessName = 'Xeox' 
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
    | where Signer has 'Xeox' or Signer has 'hs2n Informationstechnologie GmbH'
    | summarize FirstSeen=min(Timestamp), LastSeen=max(Timestamp), 
    Report=make_set(ReportId), Count=count() by DeviceId, DeviceName
| extend rmmFileSigName = 'Xeox' 
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
| where RemoteUrl has 'xeox.com'
    and InitiatingProcessVersionInfoCompanyName has 'xeox'
        or  InitiatingProcessVersionInfoProductName has 'hs2n Informationstechnologie GmbH' or InitiatingProcessVersionInfoProductName has "xeox"
| summarize FirstSeen=min(Timestamp), LastSeen=max(Timestamp), 
    Report=make_set(ReportId), Count=count() by DeviceId, DeviceName,
    AccountUpn, RemoteUrl 
| extend rmmNetworkName = 'Xeox'
;
rmmNetwork
```
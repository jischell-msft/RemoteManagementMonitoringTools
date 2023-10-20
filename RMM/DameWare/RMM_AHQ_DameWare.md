# Advanced Hunting Query for DameWare

### Create Process 
```
let Time_start = now(-5d);
let Time_end = now();
//
let rmmProcess = 
DeviceProcessEvents 
| where Timestamp between (Time_start..Time_end)
| where ProcessVersionInfoCompanyName has_any ('DameWare', 'SolarWinds')
    and 
    (
        ProcessVersionInfoProductName has 'DameWare'
        or
        ProcessVersionInfoFileDescription has 'DameWare'
    )    
| summarize FirstSeen=min(Timestamp), LastSeen=max(Timestamp), 
    Report=make_set(ReportId), Count=count() by DeviceId, DeviceName, AccountUpn 
| extend rmmProcessName = 'DameWare' 
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
| where Signer has 'DameWare Development'
| summarize FirstSeen=min(Timestamp), LastSeen=max(Timestamp), 
    Report=make_set(ReportId), Count=count() by DeviceId, DeviceName
| extend rmmFileSigName = 'DameWare' 
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
        "swi-rc.com",
        "swi-tc.com",
        "beanywhere.com",
        "licenseserver.solarwinds.com"
    )
    and InitiatingProcessVersionInfoCompanyName  has_any ('DameWare', 'SolarWinds')
    and 
    (
        InitiatingProcessVersionInfoProductName has 'DameWare'
        or 
        InitiatingProcessVersionInfoFileDescription has 'DameWare'
    )
| summarize FirstSeen=min(Timestamp), LastSeen=max(Timestamp), 
    Report=make_set(ReportId), Count=count() by DeviceId, DeviceName,
    AccountUpn, RemoteUrl 
| extend rmmNetworkName = 'DameWare'
;
rmmNetwork
```
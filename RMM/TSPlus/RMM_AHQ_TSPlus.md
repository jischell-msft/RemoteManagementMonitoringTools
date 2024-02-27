# Advanced Hunting Query for TSPlus

### Create Process 
```
TSPlus does not have consistent artifacts to be used for create process discovery
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
        'TSplus',
        'Remote Access World',
        'JWTS'
    )
| summarize FirstSeen=min(Timestamp), LastSeen=max(Timestamp), 
    Report=make_set(ReportId), Count=count() by DeviceId, DeviceName
| extend rmmFileSigName = 'TSPlus' 
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
        'tsplus-remotesupport.com',
        'secure-download-file.com',
        'licenseapi.dl-files.com',
        'securityapi.dl-files.com',
        'monitoring.tsplus.net'
    )
    and (
    InitiatingProcessVersionInfoCompanyName has_any (
        'TSplus',
        'JWTS',
        'REmote Access World'
    )
    or isempty(InitiatingProcessVersionInfoCompanyName)
    )
| summarize FirstSeen=min(Timestamp), LastSeen=max(Timestamp), 
    Report=make_set(ReportId), Count=count() by DeviceId, DeviceName,
    AccountUpn, RemoteUrl 
| extend rmmNetworkName = 'TSPlus'
;
rmmNetwork
```

# Advanced Hunting Query for Alpemix

### Create Process 
```
let Time_start = now(-5d);
let Time_end = now();
//
let rmmProcess = 
DeviceProcessEvents 
| where Timestamp between (Time_start..Time_end)
| where ProcessVersionInfoCompanyName has_any ('Teknopars Bilisim', 'TEKNOPARS BİLİŞİM')
    and ProcessVersionInfoProductName has_any ('Alpemix', 'AlpemixWEB')
| summarize FirstSeen=min(Timestamp), LastSeen=max(Timestamp), 
    Report=make_set(ReportId), Count=count() by DeviceId, DeviceName, AccountUpn 
| extend rmmProcessName = 'Alpemix' 
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
| where Signer has_any ('Teknopars Bilisim', 'TEKNOPARS BİLİŞİM')
| summarize FirstSeen=min(Timestamp), LastSeen=max(Timestamp), 
    Report=make_set(ReportId), Count=count() by DeviceId, DeviceName
| extend rmmFileSigName = 'Alpemix' 
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
        'alpemix.com',
        'serverinfo.alpemix.com',
        'teknopars.com'
    )
    and InitiatingProcessVersionInfoCompanyName has_any ('Teknopars Bilisim', 'TEKNOPARS BİLİŞİM')
    and InitiatingProcessVersionInfoProductName has_any ('Alpemix', 'AlpemixWEB')
| summarize FirstSeen=min(Timestamp), LastSeen=max(Timestamp), 
    Report=make_set(ReportId), Count=count() by DeviceId, DeviceName,
    AccountUpn, RemoteUrl 
| extend rmmNetworkName = 'Alpemix'
;
rmmNetwork
```

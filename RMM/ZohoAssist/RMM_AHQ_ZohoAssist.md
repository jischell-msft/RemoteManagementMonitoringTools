# Advanced Hunting Query for Zoho Assist

### Create Process 
```
let Time_start = now(-5d);
let Time_end = now();
//
let rmmProcess = 
DeviceProcessEvents 
| where Timestamp between (Time_start..Time_end)
| where ProcessVersionInfoCompanyName has 'Zoho'
    and ProcessVersionInfoProductName has 'Zoho Assist'
| summarize FirstSeen=min(Timestamp), LastSeen=max(Timestamp), 
    Report=make_set(ReportId), Count=count() by DeviceId, DeviceName, AccountUpn 
| extend rmmProcessName = 'Zoho Assist' 
; 
rmmProcess
```

### File Signature
This query will return _all_ binaries signed by Zoho, not just Zoho Assist.
```
let Time_start = now(-5d);
let Time_end = now();
//
let rmmFileSig = 
DeviceFileCertificateInfo
| where Timestamp between (Time_start..Time_end)
| where Signer has 'Zoho'
| summarize FirstSeen=min(Timestamp), LastSeen=max(Timestamp), 
    Report=make_set(ReportId), Count=count() by DeviceId, DeviceName
| extend rmmFileSigName = 'Zoho Assist' 
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
        'assist.zoho.com',			
        'assist.zoho.eu',			
        'assist.zoho.com.au',		
        'assist.zoho.in',			
        'assist.zoho.jp', 			
        'assist.zoho.uk',			
        'assistlab.zoho.com',		
        'downloads.zohocdn.com',	
        'download-accl.zoho.in',	
        'zohoassist.com',			
        'zohopublic.com',			
        'zohopublic.eu',			
        'meeting.zoho.com',			
        'meeting.zoho.eu', 			
        'static.zohocdn.com',		
        'zohodl.com.cn',			
        'zohowebstatic.com',		
        'zohostatic.in'		
    )
    and InitiatingProcessVersionInfoCompanyName has 'Zoho'
    and InitiatingProcessVersionInfoProductName has 'Zoho Assist'
| summarize FirstSeen=min(Timestamp), LastSeen=max(Timestamp), 
    Report=make_set(ReportId), Count=count() by DeviceId, DeviceName,
    AccountUpn, RemoteUrl 
| extend rmmNetworkName = 'Zoho Assist'
;
rmmNetwork
```

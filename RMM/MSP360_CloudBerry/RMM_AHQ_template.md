# Advanced Hunting Query for MSP360_CloudBerry

### Create Process 
```
let Time_start = now(-5d);
let Time_end = now();
//
let rmmProcess = 
DeviceProcessEvents 
| where Timestamp between (Time_start..Time_end)
| where ProcessVersionInfoCompanyName has_any (
        'CloudBerry',
        'MSP360'
    )
    and ProcessVersionInfoProductName has_any (
        'RMM',
        'Remote',
        'Connect',
        'Cloud.Ra',
        'RM Service'
    )
| summarize FirstSeen=min(Timestamp), LastSeen=max(Timestamp), 
    Report=make_set(ReportId), Count=count() by DeviceId, DeviceName, AccountUpn 
| extend rmmProcessName = 'MSP360_CloudBerry' 
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
    'MSPBytes', 
    'Trichilia Consultants'
)
| summarize FirstSeen=min(Timestamp), LastSeen=max(Timestamp), 
    Report=make_set(ReportId), Count=count() by DeviceId, DeviceName
| extend rmmFileSigName = 'MSP360_CloudBerry' 
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
        'rm.mspbackups.com',		// MSP360
        'client.rmm.mspbackups.com',// MSP360
        'settings.services.mspbackups.com',	// MSP360
        'connect.ra.msp360.com',	// MSP360	
        'foris.cloudberrylab.com',	// MSP360
    )
    and InitiatingProcessVersionInfoCompanyName has_any (
        'CloudBerry',
        'MSP360'
    )
| summarize FirstSeen=min(Timestamp), LastSeen=max(Timestamp), 
    Report=make_set(ReportId), Count=count() by DeviceId, DeviceName,
    AccountUpn, RemoteUrl 
| extend rmmNetworkName = 'MSP360_CloudBerry'
;
rmmNetwork
```
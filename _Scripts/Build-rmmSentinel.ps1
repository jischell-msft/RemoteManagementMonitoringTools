function New-RMM_SentinelProc {
    [CmdletBinding()]
    param
    (
        $Path,
        $Name,
        $Template
    )
	
    $yamlName = "rmm_$($Name)_createproc.yaml"
    $fullPath = "$($Path)\$($yamlName)"
    $exist = Test-Path -Path $fullPath
    if (!($exist)) {
        New-Item -Name $yamlName -Path $Path 
        $nameReplace = (Get-Content -Path $Template) -Replace '%%NAME%%', $Name 
        $newGuid = (new-guid).guid
        $guidReplace = $nameReplace -replace '%%GUID%%', $newGuid
        Set-Content -Path $fullPath -Value $guidReplace
    }
}
function New-RMM_SentinelFileSig {
    [CmdletBinding()]
    param
    (
        $Path,
        $Name,
        $Template
    )
	
    $yamlName = "rmm_$($Name)_filesig.yaml"
    $fullPath = "$($Path)\$($yamlName)"
    $exist = Test-Path -Path $fullPath
    if (!($exist)) {
        New-Item -Name $yamlName -Path $Path 
        $nameReplace = (Get-Content -Path $Template) -Replace '%%NAME%%', $Name 
        $newGuid = (new-guid).guid
        $guidReplace = $nameReplace -replace '%%GUID%%', $newGuid
        Set-Content -Path $fullPath -Value $guidReplace
    }
}
function New-RMM_SentinelNetworkConnection {
    [CmdletBinding()]
    param
    (
        $Path,
        $Name,
        $Template
    )
	
    $yamlName = "rmm_$($Name)_netconn.yaml"
    $fullPath = "$($Path)\$($yamlName)"
    $exist = Test-Path -Path $fullPath
    if (!($exist)) {
        New-Item -Name $yamlName -Path $Path 
        $nameReplace = (Get-Content -Path $Template) -Replace '%%NAME%%', $Name 
        $newGuid = (new-guid).guid
        $guidReplace = $nameReplace -replace '%%GUID%%', $newGuid
        Set-Content -Path $fullPath -Value $guidReplace
    }
}



function Build-RMMSentinel {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $TopLevelDirectory = (Split-Path -Path $PSScriptRoot -Parent) ,

        [Parameter()]
        [string]
        $PathTo_TemplateProc = (Join-Path (Split-Path -Path $PSScriptRoot -Parent) "_Templates\sentinel_rmm_template_createproc.yaml"),
        
        [Parameter()]
        [string]
        $PathTo_TemplateFileSig = (Join-Path (Split-Path -Path $PSScriptRoot -Parent) "_Templates\sentinel_rmm_template_filesig.yaml"),
        
        [Parameter()]
        [string]
        $PathTo_TemplateNet = (Join-Path (Split-Path -Path $PSScriptRoot -Parent) "_Templates\sentinel_rmm_template_netconn.yaml")
    )

    Begin {
        $RMM_DirectoryPath = Get-ChildItem -Path (Join-Path $TopLevelDirectory "RMM") -Directory
        
        $TemplateProc = Get-ChildItem -Path $PathTo_TemplateProc
        $TemplateFile = Get-ChildItem -Path $PathTo_TemplateFileSig
        $TemplateNet = Get-ChildItem -Path $PathTo_TemplateNet
    }
    Process {
        foreach ($dir in $RMM_DirectoryPath) {
            $dirPath = $dir.FullName
            $dirName = $dir.Name
            New-RMM_SentinelProc -Path $dirPath -Name $dirName -Template $TemplateProc.FullName
            New-RMM_SentinelFileSig -Path $dirPath -Name $dirName -Template $TemplateFile.FullName
            New-RMM_SentinelNetworkConnection -Path $dirPath -Name $dirName -Template $TemplateNet.FullName
        }
    }
}

# Build RMM queries

# Written for RMM functionFinder building

function New-ProcByOrg
{
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
	if(!($exist))
	{
		New-Item -Name $yamlName -Path $Path 
		$nameReplace = (Get-Content -Path $Template) -Replace '%%NAME%%', $Name 
        $newGuid = (new-guid).guid
        $guidReplace = $nameReplace -replace '%%GUID%%', $newGuid
        Set-Content -Path $fullPath -Value $guidReplace
	}
}
function New-FileSigByOrg
{
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
	if(!($exist))
	{
		New-Item -Name $yamlName -Path $Path 
		$nameReplace = (Get-Content -Path $Template) -Replace '%%NAME%%', $Name 
        $newGuid = (new-guid).guid
        $guidReplace = $nameReplace -replace '%%GUID%%', $newGuid
        Set-Content -Path $fullPath -Value $guidReplace
	}
}
function New-NetworkConnectionByOrg
{
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
	if(!($exist))
	{
		New-Item -Name $yamlName -Path $Path 
		$nameReplace = (Get-Content -Path $Template) -Replace '%%NAME%%', $Name 
        $newGuid = (new-guid).guid
        $guidReplace = $nameReplace -replace '%%GUID%%', $newGuid
        Set-Content -Path $fullPath -Value $guidReplace
	}
}

function Build-RMMQuery
{
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $TopLevelDirectory = (Split-Path -Path $PSScriptRoot -Parent) ,

        [Parameter()]
        [string]
        $PathTo_TemplateProc = (Join-Path (Split-Path -Path $PSScriptRoot -Parent) "..\_Templates\sentinel_rmm_template_createproc.yaml"),
        
        [Parameter()]
        [string]
        $PathTo_TemplateFileSig = (Join-Path (Split-Path -Path $PSScriptRoot -Parent) "..\_Templates\sentinel_rmm_template_createproc.yaml"),
        
        [Parameter()]
        [string]
        $PathTo_TemplateNet = (Join-Path (Split-Path -Path $PSScriptRoot -Parent) "..\_Templates\sentinel_rmm_template_createproc.yaml")
    )

    Begin
    {
        $RMM_ProductDirectory = Get-ChildItem -Path $TopLevelDirectory -Directory 
        | Where-Object {$_.name -notlike "_*"}
        
        $TemplateProc = Get-ChildItem -Path $PathTo_TemplateProc
        $TemplateFile = Get-ChildItem -Path $PathTo_TemplateFileSig
        $TemplateNet = Get-ChildItem -Path $PathTo_TemplateNet
    }
    Process
    {
        foreach($dir in $RMM_ProductDirectory){
            $dirPath = $dir.FullName
            $dirName = $dir.Name
            New-ProcByOrg -Path $dirPath -Name $dirName -Template $TemplateProc.FullName
            New-FileSigByOrg -Path $dirPath -Name $dirName -Template $TemplateFile.FullName
            New-NetworkConnectionByOrg -Path $dirPath -Name $dirName -Template $TemplateNet.FullName
        }
    }
}

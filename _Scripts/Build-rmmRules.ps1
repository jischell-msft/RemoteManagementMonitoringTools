function New-RMM_Summary {
    [CmdletBinding()]
    param (
        $Path,
        $Name,
        $Template
    )

    $targetName = "RMM_Summary_$($Name).md"
    $fullPath = Join-Path $Path $targetName
    $exist = Test-Path -Path $fullPath
    if (!($exist)) {
        New-Item -Name $targetName -Path $Path
        (Get-Content -Path $Template) -Replace '%%NAME%%', $Name | Set-Content -Path $fullPath
    }
}

function New-RMM_AHQ {
    [CmdletBinding()]
    param (
        $Path,
        $Name,
        $Template
    )

    $targetName = "RMM_AHQ_$($Name).md"
    $fullPath = Join-Path $Path $targetName
    $exist = Test-Path -Path $fullPath
    if (!($exist)) {
        New-Item -Name $targetName -Path $Path
        (Get-Content -Path $Template) -Replace '%%NAME%%', $Name | Set-Content -Path $fullPath
    }
}

function Build-RMMQuery {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $TopLevelDirectory = (Split-Path -Path $PSScriptRoot -Parent) ,

        [Parameter()]
        [string]
        $RMM_summaryTemplate_Path = (Join-Path (Split-Path -Path $PSScriptRoot -Parent) "_Templates\RMM_Summary_template.md"),

        [Parameter()]
        [string]
        $RMM_ahqTemplate_Path = (Join-Path (Split-Path -Path $PSScriptRoot -Parent) "_Templates\RMM_AHQ_template.md")
    )
    Begin {
        $RMM_DirectoryPath = Get-ChildItem -Path (Join-Path $TopLevelDirectory "RMM") -Directory

        $Template_Summary = Get-ChildItem -Path $RMM_summaryTemplate_Path
        $Template_AHQ = Get-ChildItem -Path $RMM_ahqTemplate_Path
    }
    Process {
        foreach ($dir in $RMM_DirectoryPath) {
            $dirPath = $dir.FullName
            $dirName = $dir.Name

            New-RMM_Summary -Path $dirPath -Name $dirName -Template $Template_Summary
            New-RMM_AHQ -Path $dirPath -Name $dirName -Template $Template_AHQ
        }
    }
}
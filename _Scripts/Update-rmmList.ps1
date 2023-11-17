function Update-RMMList {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $TopLevelDirectory = (Split-Path -Path $PSScriptRoot -Parent) ,

        [Parameter()]
        $RMM_DirectoryPath = (Get-ChildItem -Path (Join-Path (Split-Path -Path $PSScriptRoot -Parent) "RMM") -Directory),

        [Parameter()]
        [string]
        $RMM_ToolListPath = ((Get-ChildItem -Path $TopLevelDirectory -Recurse -Filter "README.md").FullName)
    )
    Begin {
        $startOf_ToolListing = (Get-Content -Path $RMM_ToolListPath).IndexOf("### Tool List") + 1
        $endOf_ToolListing = (Get-Content -Path $RMM_ToolListPath).Length + 1
    }
    Process {
        $toolList_content = (Get-Content -Path $RMM_ToolListPath)[$startOf_ToolListing..$endOf_ToolListing]

        foreach ($dir in $RMM_DirectoryPath) {
            $dirName = $dir.Name
            if (! ($toolList_content | Where-Object { $_ -like "*$($dirName)*" }) ) {
                $toolList_content += "- [$($dirName)](RMM/$($dirName)/RMM_Summary_$($dirName).md)"
            }
        }
        $toolList_content = $toolList_content | Sort-Object
        $preamble_content = (Get-Content -Path $RMM_ToolListPath)[0..($startOf_ToolListing - 1)]
        $complete_content = $preamble_content + $toolList_content
        Set-Content -Value $complete_content -Path $RMM_ToolListPath
    }
}
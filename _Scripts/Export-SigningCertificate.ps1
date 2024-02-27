function Export-SigningCertificate {
    <#
.SYNOPSIS
Export authenticode certificate from executable

.DESCRIPTION
Given the path to file, attempts to validate authenticode signing status and 
export certificate to .CER file named as [Thumbprint].cer

.PARAMETER PathToExecutable
Path to executeable file for exporting the signing certificate

.PARAMETER FolderTarget
Target for the exported certificate. Default is present working directory

.EXAMPLE
Export-SigningCertificate -PathToExecutable C:\Windows\System32\calc.exe -FolderTarget .\Downloads\
---
Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---          2024-02-26    12:00           1290 FE51E838A087BB561BBB2DD9BA20143384A03B3F.cer

.NOTES
Name:       Export-SigningCertificate
Author:     JiSchell
Create:     2024-02-26
Modify:     2024-02-26
Version:    0.1.2
#>


    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $PathToExecutable,

        [Parameter()]
        [string]
        $FolderTarget = "$pwd"
    )

    begin {
        $cert = $null
        $validPath = Test-Path $PathToExecutable
        if ($validPath) {
            $authenticodeSignature = Get-AuthenticodeSignature -FilePath $PathToExecutable
        }
        else {
            Write-Error -Message "Path not found"
            break
        }

        if ($authenticodeSignature.status -notlike 'UnknownError') {
            $msg_verbose = "Signature found"
            Write-Verbose -Message $msg_verbose
            $cert = $authenticodeSignature.SignerCertificate
        }
        else {
            $msg_verbose = "No signature found"
            Write-Verbose -Message $msg_verbose
            Write-Error -Message $msg_verbose
            break
        }
    }
    process {
        $thumbprint = $cert.Thumbprint
        $outputName = "$($thumbprint).cer"
        $outputPath = Join-Path -Path $FolderTarget -ChildPath $outputName

        $cert | Export-Certificate -Type CERT -FilePath $outputPath
    }
    end {
    }
}
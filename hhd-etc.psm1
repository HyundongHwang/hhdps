<#
.SYNOPSIS
.EXAMPLE
#>
function mycomplexfunc
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [System.Diagnostics.Process]
        $process,

        [System.String]
        $prefix,

        [System.String[]]
        $strArray
    )

    $obj = New-Object -typename PSObject

    $obj | Add-Member -MemberType NoteProperty -Name prefix -Value $prefix
    $obj | Add-Member -MemberType NoteProperty -Name ProcessName -Value $process.Name
    $obj | Add-Member -MemberType NoteProperty -Name ProcessId -Value $process.Id

    write ("strArray.Length : " + $strArray.Length)

    if ($strArray.Length -gt 0) 
    {
        $rand = New-Object -TypeName System.Random
        $idx = $rand.Next($strArray.Length)

        write ("idx : " + $idx)

        $randValue = $strArray[$idx]

        write ("randValue : " + $randValue)

        $obj | Add-Member -MemberType NoteProperty -Name randValue -Value $randValue
    }

    Write-Output $obj
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhdnetworkgetpubip
{
    [CmdletBinding()]
    param
    (
    )

    $myPubIp = (Invoke-WebRequest -Uri http://icanhazip.com).Content
    return $myPubIp   
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhdwmigetprogram
{
    [CmdletBinding()]
    param
    (
    )

    gwmi -Class win32_product
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhdgcmgetscriptcontent
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [System.String]
        $cmdname
    )

    return (gcm $cmdname).ScriptBlock
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhdfileappendtime
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [System.IO.FileInfo]
        $file,

        [switch]
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        $changedatealwaysnew = $false
    )

    if($file.Name.StartsWith("."))
    {
        write "${file}.Name start with . so skip ..."
        return
    }

    $isProcessed = $false
    $date6 = $file.LastWriteTime.ToString("yyMMdd")
    $isPrefixNum = $false

    if($file.Name.Length -gt 6)
    {
        $first6 = $file.Name.SubString(0, 6)

        for($i = 0; $i -lt $first6.Length; $i++)
        {
            $isPrefixNum = @("0", "1", "2", "3", "4", "5", "6", "7", "8", "9") -contains $first6[$i]

            if ($isPrefixNum -eq $false) 
            {
                $isPrefixNum = $false
                break;
            }
        }
    }

    if($isPrefixNum)
    {
        if ($changedatealwaysnew) 
        {
            $newFileName = $date6 + $file.Name.Substring(6, $file.Name.Length - 6)
            mv $file $newFileName
            write "${file}.Name -> ${newFileName} !!!"
        }
        else 
        {
            write "${file}.Name is PrefixNum and is not changedatealwaysnew ..."
        }
    }
    else 
    {
        $newFileName = $date6 + " " + $file.Name
        write "${file}.Name -> ${newFileName}"
        mv $file $newFileName
    }
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhdfilewritefortest
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [System.IO.FileInfo]
        $file
    )
        
    Read-Host | Out-File $file
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhdnetworkgetipmacaddress
{
    [CmdletBinding()]
    param
    (
    )

    Get-WmiObject win32_networkadapterconfiguration | 
        select description, macaddress, ipaddress | 
        ? { $_.macaddress -ne $null} | 
        fl
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhdimagegetwin10spotlightlockscreen
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [System.String]
        $dirName = "tmp"
    )

    $fileList = ls ~\AppData\Local\Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets\* | ? { $_.Length -gt 100000 }
    write $fileList
    md $dirName
    $fileList | % { cp $_.FullName "$dirName\$($_.Name).png" }
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhdcertfromwebsite
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [System.String]
        $url
    )

    $req = [Net.WebRequest]::Create($url)
    $req.GetResponse() 
    $cert = $req.ServicePoint.Certificate
    $bytes = $cert.Export([Security.Cryptography.X509Certificates.X509ContentType]::Cert)
    $certFilePath = "$pwd\$($req.RequestUri.Host).cer"
    set-content -value $bytes -encoding byte -path $certFilePath
    certutil.exe -dump $certFilePath
}
# <#
# .SYNOPSIS
# .EXAMPLE
# #>
# function hhd-hello
# {
#    [CmdletBinding()]
#    param
#    (
#        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
#        [System.String]
#        $WORLD
#    )

#    process 
#    {
#        Write-Host "start"
#        $obj = New-Object -typename PSObject
#        $obj | Add-Member -MemberType NoteProperty -Name "hello" -Value "안녕하세요"
#        $obj | Add-Member -MemberType NoteProperty -Name "world" -Value $WORLD
#        Write-Host ""
#        return $obj;
#    }
# }



# hhd-hello -WORLD world
# @("a", "b", "c") | hhd-hello




<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-vod-logcat
{
   [CmdletBinding()]
   param
   (
   )

    $PACKAGE_NAME_LIST = @(
        "com.navercorp.vtech.vodsdk"
    )

    $pid = $null

    foreach ($packageName in $PACKAGE_NAME_LIST) {
        Write-Host "$packageName process searching ..."
        adb -d logcat -c

        try {
            $pid = (adb shell ps | Select-String $packageName)[0].ToString().Split(" ", [System.StringSplitOptions]::RemoveEmptyEntries)[1]

            if (![string]::IsNullOrEmpty($pid)) {
                Write-Host "$packageName[$pid] process found !!!"
                break
            }
        }
        catch {
        }
    }

    if ([string]::IsNullOrEmpty($pid)) {
        Write-Host "process not found !!!"
        return
    }

    Write-Host "$PACKAGE_NAME[$pid] start logcat ..."
    Write-Host ""
    Write-Host ""
    Write-Host ""
    $filePath = "hhd-ull-logcat-$([datetime]::Now.ToString("yyMMdd-HHmm")).log"

    adb -d logcat | 
        Select-String $pid |
        Tee-Object -FilePath $filePath
}
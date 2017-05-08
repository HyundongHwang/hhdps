<#
.SYNOPSIS
.EXAMPLE
#>
function hhdadblogcatmono
{
    [CmdletBinding()]
    param
    (
    )

    adb logcat -s mono-stdout:v
}

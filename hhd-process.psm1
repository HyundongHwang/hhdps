<#
.SYNOPSIS
.EXAMPLE
#>
function hhdps
{
    [CmdletBinding()]
    param
    (
    )

    ps | sort WS -Descending | select Id, Name, @{l="WS(M)"; e={[int]($_.WS / 1024 / 1024)}}, Path -First 10 | ft -AutoSize -Wrap
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhdkillallpowershellwithoutme
{
    [CmdletBinding()]
    param
    (
    )

    ps -Name *powershell* | where { $_.Id -ne $PID } | kill
}




<#
.SYNOPSIS
.EXAMPLE
#>
function hhdkill
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [System.String[]]
        $processNameList
    )

    $processNameList | % { ps "*$_*" } | % { taskkill /PID $_.id /T /F }
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhdkillvsgarbage
{
    [CmdletBinding()]
    param
    (
    )

    hhdkill -processName vshub
    hhdkill -processName msbuild
}

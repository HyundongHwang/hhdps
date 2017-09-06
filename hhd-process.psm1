<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-ps
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
function hhd-kill-all-powershell-without-me
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
function hhd-kill
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [System.String[]]
        $PROCESS_NAME_LIST
    )

    $PROCESS_NAME_LIST | % { ps "*$_*" } | % { taskkill /PID $_.id /T /F }
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-kill-vs-garbage
{
    [CmdletBinding()]
    param
    (
    )

    hhd-kill -processName vshub
    hhd-kill -processName msbuild
}

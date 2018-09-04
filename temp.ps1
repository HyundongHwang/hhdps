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










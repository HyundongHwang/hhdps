##
## temp.ps1
##

#<#
#.SYNOPSIS
#.EXAMPLE
##>
#function hhd-hello
#{
#    [CmdletBinding()]
#    param
#    (
#        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
#        [System.String]
#        $WORLD
#    )

#    process 
#    {
#        Write-Host "Ω√¿€"
#        $obj = New-Object -typename PSObject
#        $obj | Add-Member -MemberType NoteProperty -Name "hello" -Value "«Ô∑ŒøÏ"
#        $obj | Add-Member -MemberType NoteProperty -Name "world" -Value $WORLD
#        Write-Host "¡æ∑·"
#        return $obj;
#    }
#}



#hhd-hello -WORLD world
#@("¿œ", "¿Ã", "ªÔ") | hhd-hello










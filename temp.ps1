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
#        Write-Host "����"
#        $obj = New-Object -typename PSObject
#        $obj | Add-Member -MemberType NoteProperty -Name "hello" -Value "��ο�"
#        $obj | Add-Member -MemberType NoteProperty -Name "world" -Value $WORLD
#        Write-Host "����"
#        return $obj;
#    }
#}



#hhd-hello -WORLD world
#@("��", "��", "��") | hhd-hello










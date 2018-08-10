<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-cd-add-path
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [System.String]
        $NAME,

        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [System.String]
        $PATH
    )

    $g_hhdFavList | ? {$_.name -eq $NAME} | set rmList
    $rmList | % { $g_hhdFavList.Remove($_) }
    $newObj = New-Object psobject
    $newObj | Add-Member -Name name -Value $NAME -MemberType NoteProperty
    $newObj | Add-Member -Name path -Value $PATH -MemberType NoteProperty
    $g_hhdFavList.Add($newObj)
    $g_hhdFavList | ConvertTo-Json | Out-File -FilePath ~/hhdFavList.json
}



# write "load hhdfavList.json ..."

# if (Test-Path ~/hhdfavList.json) 
# {
#     cat ~/hhdfavList.json | ConvertFrom-Json | set temp 

#     $g_hhdDirBackwardStack = New-Object -TypeName System.Collections.Stack
#     $g_hhdDirForwardStack = New-Object -TypeName System.Collections.Stack
#     $g_hhdFavList = New-Object System.Collections.Generic.List[psobject]
        
#     $temp | % { 
#         $newObj = New-Object psobject
#         $newObj | Add-Member -MemberType NoteProperty -Name name -Value $_.name
#         $newObj | Add-Member -MemberType NoteProperty -Name path -Value $_.path
#         $g_hhdFavList.Add($newObj) 
#     }

#     $g_hhdFavList | % { 
#         $exp = "function hhdcd{0} {{ cd {1} }}" -f $_.name, $_.path
#         write ("exp : {0}" -f $exp)
#         Invoke-Expression $exp
#     }    
# }
# else 
# {
#     $g_hhdFavList = New-Object System.Collections.Generic.List[psobject]
# }
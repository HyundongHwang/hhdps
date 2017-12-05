#
# temp.ps1
#



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-hello
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [System.String]
        $WORLD
    )

	$obj = New-Object -typename PSObject
	$obj | Add-Member -MemberType NoteProperty -Name "hello" -Value "Çï·Î¿ì"
	$obj | Add-Member -MemberType NoteProperty -Name "world" -Value $WORLD
	return $obj;
}



hhd-hello



pause
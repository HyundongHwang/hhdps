<#
.SYNOPSIS
.EXAMPLE
#>
function hhdvs2017openfile
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [System.String]
        $FILE_NAME
    )

    vs2017 /Edit $FILE_NAME
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhdvs2017openhhdps
{
    [CmdletBinding()]
    param
    (
    )

    hhdvs2017openfile C:\hhdps
}
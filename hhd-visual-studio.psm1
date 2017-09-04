<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-vs2017-open-file
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
function hhd-vs2017-open-hhdps
{
    [CmdletBinding()]
    param
    (
    )

    hhd-vs2017-openfile C:\hhdps
}
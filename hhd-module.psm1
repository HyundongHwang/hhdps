<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-module-install-import
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [System.String]
        $MODULE_NAME
    )

    if((Get-InstalledModule -name $MODULE_NAME).count -eq 0)
    {
        write "install $MODULE_NAME ..."
        Install-Module $MODULE_NAME -Force -AllowClobber
    }
    else 
    {
        write "$MODULE_NAME already installed !!!"
    }

    write "$MODULE_NAME import ..."
    Import-Module $MODULE_NAME -Force
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-module-load-from-dll
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [System.String]
        $dllpath
    )

    if (Test-Path $dllpath -eq $false)
    {
        write "no file ${dllpath} ..."
        return
    }

    Add-Type -Path $dllpath
    Import-Module $dllpath
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-nuget-restore
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [System.IO.FileInfo]
        $SLN_FILE
    )

    nuget restore -SolutionDirectory $SLN_FILE.FullName -PackagesDirectory packages
}

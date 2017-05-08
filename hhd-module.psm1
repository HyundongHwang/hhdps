<#
.SYNOPSIS
.EXAMPLE
#>
function hhdmoduleinstallimport
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
        Install-Package $MODULE_NAME -Force -AllowClobber
    }
    else 
    {
        write "$MODULE_NAME already installed !!!"
    }

    write "import $MODULE_NAME ..."
    Import-Module $MODULE_NAME -Force
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhdmoduleloadfromdll
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
function hhdnugetrestore
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [System.IO.FileInfo]
        $slnfile
    )

    nuget restore -SolutionDirectory $slnfile.FullName -PackagesDirectory packages
}

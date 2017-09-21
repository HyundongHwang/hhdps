<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-azure-login-auto
{
    [CmdletBinding()]
    param
    (
    )

    if ((Test-Path ~/*publishsettings) -eq $false) 
    {
        Get-AzurePublishSettingsFile
        write ("save at {0}" -f (Resolve-Path ~).Path)
    }

    write "azure login ..."
    Import-AzurePublishSettingsFile ~\*.publishsettings    
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-azure-current
{
    [CmdletBinding()]
    param
    (
    )

    write "azure subscription check ..."
    pause
    Get-AzureSubscription

    write "azure website check ..."
    pause
    Get-AzureWebsite
    Get-AzureWebHostingPlan

    write "azure sql database check ..."
    pause
    Get-AzureSqlDatabaseServer | Get-AzureSqlDatabase | hhd-azure-sql-database-detail

    write "azure storage account check ..."
    pause
    Get-AzureStorageAccount

    write "azure storage blob check ..."
    pause
    Get-AzureStorageAccount | Get-AzureStorageContainer | Get-AzureStorageBlob
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-azure-start-all-website
{
    [CmdletBinding()]
    param
    (
    )

    write "azure website check ..."
    Get-AzureWebSite

    write "start all websites ..."
    Get-AzureWebSite | Start-AzureWebSite

    write "azure website check ..."
    Get-AzureWebSite
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-azure-stop-all-website
{
    [CmdletBinding()]
    param
    (
    )

    write "azure website check ..."
    Get-AzureWebSite

    write "stop all websites ..."
    Get-AzureWebSite | Stop-AzureWebSite

    write "azure website check ..."
    Get-AzureWebSite
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-azure-get-website-log-hhdyidbot
{
    [CmdletBinding()]
    param
    (
    )

    Get-AzureWebsiteLog -Name hhdyidbot -Tail
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-azure-sql-database-detail
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [Microsoft.WindowsAzure.Commands.SqlDatabase.Services.Server.Database]
        $dbObj
    )

    $obj = New-Object -typename PSObject
    $dbType = [Microsoft.WindowsAzure.Commands.SqlDatabase.Services.Server.Database]
    $methodList = $dbType.GetMethods() | where { $_.Name -like "get_*" }

    foreach ($method in $methodList) 
    {
        $name = $method.Name.TrimStart("get_")
        $value = $method.Invoke($dbObj, $null)

        if ([string]::IsNullOrWhiteSpace($value))
        {
            continue
        }



        $obj | Add-Member -MemberType NoteProperty -Name $name -Value $value
    }

    #pyx1rbr0s0.database.windows.net
    #Server=tcp:pyx1rbr0s0.database.windows.net,1433;Data Source=pyx1rbr0s0.database.windows.net;Initial Catalog=hhdyidbot;Persist Security Info=False;User ID={your_username};Password={your_password};Pooling=False;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;

    $serverName = $dbObj.Context.ServerName
    $dbName = $dbObj.Name
    $obj | Add-Member -MemberType NoteProperty -Name ServerAddress -Value "$serverName.database.windows.net"
    $obj | Add-Member -MemberType NoteProperty -Name ConnectionString -Value "Server=tcp:$serverName.database.windows.net,1433;Data Source=$serverName.database.windows.net;Initial Catalog=$dbName;Persist Security Info=False;User ID={your_username};Password={your_password};Pooling=False;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
    Write-Output $obj
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-azure-login
{
    [CmdletBinding()]
    param
    (
    )

    if (Test-Path ~/*.publishsettings)
    {
        Import-AzurePublishSettingsFile -PublishSettingsFile ~/*.publishsettings
    }
    else
    {
        Get-AzurePublishSettingsFile
    }
}
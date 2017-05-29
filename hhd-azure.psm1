<#
.SYNOPSIS
.EXAMPLE
#>
function hhdazureloginauto
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
function hhdazurecurrent
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
    Get-AzureSqlDatabaseServer | Get-AzureSqlDatabase | hhdazuresqldatabasedetail

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
function hhdazurestartallwebsite
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
function hhdazurestopallwebsite
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
function hhdazuregetwebsiteloghhdyidbot
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
function hhdazuresqldatabasedetail
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
function hhdazurestorageuploadfile
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [string]
        $FILE_NAME,

        [parameter(Mandatory = $false, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [ValidateSet("None", "Prefix", "Postfix")]
        [string]
        $ADD_TIMESTAMP_STR = "None",

        [parameter(Mandatory = $false, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [string]
        $AZURE_STORAGE_CONNECTION_STR = "DefaultEndpointsProtocol=https;AccountName=hhdpublish;AccountKey=3y07DG/iIvULhXaX0hzV8LU+6JWXP1EbeEzRfAP8hOhfXrRlnI+IEbbOfCwwF+UMIJxbqwGPtFcxKNXDzuwezw==;EndpointSuffix=core.windows.net",

        [parameter(Mandatory = $false, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [string]
        $AZURE_STORAGE_CONTAINER = "publish"
    )

    $storageCtx = New-AzureStorageContext -ConnectionString $AZURE_STORAGE_CONNECTION_STR
    # New-AzureStorageContainer -Context $storageCtx -Name "publish" -Permission Container

    $upDir = Convert-Path "$FILE_NAME\.." | select -First 1

    ls $FILE_NAME -File -Force -Recurse | 
    % {
        $blobName = $_.FullName.Replace($upDir, "").TrimStart("\\")
        $dirName = [System.IO.Path]::GetDirectoryName($blobName)
        $fileName = [System.IO.Path]::GetFileNameWithoutExtension($blobName)
        $extName = [System.IO.Path]::GetExtension($blobName)

        if($ADD_TIMESTAMP_STR -eq "Prefix")
        {
            $dtStr = $_.LastWriteTime.ToString("yyMMdd-HHmm")
            $blobName = [System.IO.Path]::Combine($dirName, "$dtStr $fileName$extName")
        }
        elseif($ADD_TIMESTAMP_STR -eq "Postfix")
        {
            $dtStr = $_.LastWriteTime.ToString("yyMMdd-HHmm")
            $blobName = [System.IO.Path]::Combine($dirName, "$fileName $dtStr$extName")
        }

        if ($extName -eq ".html") 
        {
            $props = @{"ContentType" = "text/html"};
        }
        elseif ($extName -eq ".css") 
        {
            $props = @{"ContentType" = "text/css"};
        }
        elseif ($extName -eq ".js") 
        {
            $props = @{"ContentType" = "application/javascript"};
        }
        elseif ($extName -eq ".json") 
        {
            $props = @{"ContentType" = "application/json"};
        }
        elseif ($extName -eq ".xml") 
        {
            $props = @{"ContentType" = "application/xml"};
        }
        elseif ($extName -eq ".txt") 
        {
            $props = @{"ContentType" = "text/plain"};
        }
        elseif ($extName -eq ".text") 
        {
            $props = @{"ContentType" = "text/plain"};
        }
        elseif ($extName -eq ".jpg") 
        {
            $props = @{"ContentType" = "image/jpeg"};
        }
        elseif ($extName -eq ".jpeg") 
        {
            $props = @{"ContentType" = "image/jpeg"};
        }
        elseif ($extName -eq ".png") 
        {
            $props = @{"ContentType" = "image/png"};
        }
        elseif ($extName -eq ".gif") 
        {
            $props = @{"ContentType" = "image/gif"};
        }
        elseif ($extName -eq ".mp3") 
        {
            $props = @{"ContentType" = "audio/mpeg"};
        }
        elseif ($extName -eq ".mp4") 
        {
            $props = @{"ContentType" = "video/mp4"};
        }
        else 
        {
            $props = @{"ContentType" = "application/octet-stream"};
        }

        $blob = Set-AzureStorageBlobContent -Context $storageCtx -Container $AZURE_STORAGE_CONTAINER -File $_.FullName -Blob $blobName -Force -Properties $props
        $obj = New-Object -typename PSObject
        $obj | Add-Member -MemberType NoteProperty -Name LocalFilePath -Value $_.FullName
        $obj | Add-Member -MemberType NoteProperty -Name DownloadUrl -Value $blob.ICloudBlob.Uri.AbsoluteUri
        write $obj
    } | fl
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhdazurelogin
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
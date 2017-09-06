<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-onedrive-upload
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [System.String]
        $FILE_PATH
    )

    hhd-module-install-import -MODULE_NAME OneDrive

    $authRes = Get-ODAuthentication -ClientID "00000000401C7029"
    $uploadRes = Add-ODItem -AccessToken $authRes.access_token -Path "/publish" -LocalFile $FILE_PATH
    $uploadResObj = $uploadRes | ConvertFrom-Json

    $createLinkRes = Invoke-WebRequest ("https://api.onedrive.com/v1.0/drive/items/{0}/action.createLink" -f $uploadResObj.id) -Headers @{"Authorization"="bearer " + $authRes.access_token; "Content-Type"="application/json" } -Body '{ "type": "view" }' -Method Post
    $createLinkResObj = $createLinkRes | ConvertFrom-Json

    $createLinkResObj.link.webUrl | clip
    return $createLinkResObj.link.webUrl
}

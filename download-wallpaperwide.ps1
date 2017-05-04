[CmdletBinding()]
param (
    #[parameter(Mandatory = $true)]
    #[string]$FILE_PATH = $false,

    #[parameter(Mandatory = $false)]
    #[switch]$OPEN_HTML = $false,

    #[parameter(Mandatory = $false)]
    #[switch]$DEPLOY_TO_WEB = $false
)



1..100 | 
% {
    [Microsoft.PowerShell.Commands.HtmlWebResponseObject]$html = 
        Invoke-WebRequest -Uri "http://wallpaperswide.com/top_wallpapers/page/$_" -SessionVariable sessionVar

    $html.ParsedHtml.links | ? { $_.pathname -like "*-wallpapers.html" } | ? { $_.pathname -notlike "*-desktop*" } |
    % {
        $imageName = $_.pathname -replace "-wallpapers.html", ""
        $imageFileName = "$imageName-wallpaper-1920x1080.jpg"
        $imageUrl = "http://wallpaperswide.com/download/$imageFileName"

        if (Test-Path $imageFileName) 
        {
            write "$imageUrl skip ..."
            return
        }
        
        write "$imageUrl start ..."
        Invoke-WebRequest -Uri $imageUrl -OutFile $imageFileName -UseBasicParsing -WebSession $sessionVar
        write "$imageUrl finish ..."
    }
}
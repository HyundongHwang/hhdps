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
        Invoke-WebRequest -Uri "http://wallpaperswide.com/top_wallpapers/page/$_"

    $html.ParsedHtml.links | ? { $_.pathname -like "*-wallpapers.html" } | ? { $_.pathname -notlike "*-desktop*" } |
    % {
        $imageName = $_.pathname -replace "-wallpapers.html", ""
        $imageUrl = "http://wallpaperswide.com/download/$imageName-wallpaper-1920x1080.jpg"

        write "$imageUrl start ..."
        Invoke-WebRequest -Uri $imageUrl -OutFile "$imageName-wallpaper-1920x1080.jpg" -UseBasicParsing
        write "$imageUrl finish ..."
    }
}
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
    $html = Invoke-WebRequest -Uri "http://wallpaperswide.com/top_wallpapers/page/$_" -UseBasicParsing

    $html.Links | 
    ? { $_.href -like "*-wallpapers.html" } |
    ? { $_.href -notlike "*-desktop*" } |
    % {
        $imageName = $_.href -replace "-wallpapers.html", ""
        $imageFileName = "$imageName-wallpaper-1920x1080.jpg"
        $imageUrl = "http://wallpaperswide.com/download$imageFileName"

        if (Test-Path $imageFileName) 
        {
            write "$imageUrl skip ..."
            return
        }
        
        write "$imageUrl start ..."
        Invoke-WebRequest -Uri $imageUrl -OutFile "$pwd$imageFileName"
        write "$imageUrl finish ..."
    }
}
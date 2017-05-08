$PROFILE_PATH = "$PSHOME\profile.ps1"
$PSSCRIPTROOT_RESOLVED = Resolve-Path $PSScriptRoot

$HHDPS_PROFILE_ADDON_STR = 
@"
ls "$PSSCRIPTROOT_RESOLVED\*.psm1" |
% { 
    write "`$(`$_.Name) load ..."
    Import-Module `$_.FullName 
}
"@

if(!(Test-Path $PROFILE_PATH))
{
    $HHDPS_PROFILE_ADDON_STR | Out-File -FilePath $PROFILE_PATH -Encoding utf8
}
else
{
    $profileContent = cat $PROFILE_PATH
    
    if(!($profileContent -like "*hhdps*"))
    {
        "$profileContent`n$HHDPS_PROFILE_ADDON_STR" | Out-File -FilePath $PROFILE_PATH -Encoding utf8
    }
}

ls $PROFILE_PATH | select FullName
cat $PROFILE_PATH
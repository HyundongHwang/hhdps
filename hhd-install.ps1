$PROFILE_PATH = "$PSHOME\profile.ps1"
$PSSCRIPTROOT_RESOLVED = Resolve-Path $PSScriptRoot


if ($PSVersionTable.Platform -eq "Unix") 
{

$HHDPS_PROFILE_ADDON_STR = 
@"
    Import-Module ~/hhdps/hhd-main.psm1 -Force -WarningAction Ignore
    Import-Module ~/hhdps/hhd-linux.psm1 -Force -WarningAction Ignore
    Import-Module ~/hhdps/hhd-git.psm1 -Force -WarningAction Ignore
    Import-Module ~/hhdps/hhd-android.psm1 -Force -WarningAction Ignore
    Import-Module ~/hhdps/hhd-ull.psm1 -Force -WarningAction Ignore
"@

}
else
{

$HHDPS_PROFILE_ADDON_STR = 
@"
Get-ChildItem "$PSSCRIPTROOT_RESOLVED\*.psm1" |
% { 
    Write-Host "`$(`$_.Name) load ..."
    Import-Module `$_.FullName -Force -WarningAction Ignore
}
"@

}

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

. $PROFILE_PATH

Install-Module blackbox
Install-Module fastfilepub
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
    Import-Module /hhdps/hhd-main.psm1 -Force -WarningAction Ignore
    Import-Module /hhdps/hhd-git.psm1 -Force -WarningAction Ignore
    Import-Module /hhdps/hhd-android.psm1 -Force -WarningAction Ignore
    Import-Module /hhdps/hhd-azure.psm1 -Force -WarningAction Ignore
    Import-Module /hhdps/hhd-cd.psm1 -Force -WarningAction Ignore
    Import-Module /hhdps/hhd-etc.psm1 -Force -WarningAction Ignore
    Import-Module /hhdps/hhd-module.psm1 -Force -WarningAction Ignore
    Import-Module /hhdps/hhd-process.psm1 -Force -WarningAction Ignore
    Import-Module /hhdps/hhd-sal.psm1 -Force -WarningAction Ignore
    Import-Module /hhdps/hhd-visual-studio.psm1 -Force -WarningAction Ignore
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
# hhdps

- �������� ������ ����ȯ���� ���� �Ŀ��� ���, �Լ�, �����ڵ� ����
- ��� �Լ����� ������Ʈ���� �ڵ��ϼ��� ���� �Ǳ� ���ؼ� `hhd + ī�װ� + �׼� + ������` �������� �����Ǿ� �ִ�.

# ��ġ

```powershell
PS C:\temp> Invoke-WebRequest "https://github.com/HyundongHwang/hhdps/archive/master.zip" -OutFile hhdps.zip

PS C:\temp> Expand-Archive hhdps.zip -DestinationPath .



PS C:\temp> .\hhdps-master\hhd-install.ps1
FullName
--------
C:\Windows\SysWOW64\WindowsPowerShell\v1.0\profile.ps1
ls "C:\temp\hhdps-master\*.psm1" |
% {
    write "$($_.Name) load ..."
    Import-Module $_.FullName
}

env-coconut-dev.psm1 load ...
hhd-android.psm1 load ...
hhd-azure.psm1 load ...
hhd-cd.psm1 load ...
hhd-etc.psm1 load ...
hhd-git.psm1 load ...
hhd-iotcore.psm1 load ...
hhd-main.psm1 load ...
hhd-module.psm1 load ...
hhd-onedrive.psm1 load ...
hhd-process.psm1 load ...
hhd-sal-common.psm1 load ...
hhd-sal-hhdcommand.psm1 load ...
hhd-visual-studio.psm1 load ...



PS C:\temp> Get-Module -Name *hhd*
ModuleType Version    Name                                ExportedCommands
---------- -------    ----                                ----------------
Script     0.0        hhd-android                         hhdadblogcatmono
Script     0.0        hhd-azure                           {hhdazurecurrent, hhdazuregetwebsiteloghhdyidbot, hhdazureloginauto, hhdazuresqldatabasedetail...}
Script     0.0        hhd-cd                              {hhdcdaddpath, hhdcdcoconut, hhdcdhhdcommand, hhdcdhhdps...}
Script     0.0        hhd-etc                             {hhdfileappendtime, hhdfilewritefortest, hhdgcmgetscriptcontent, hhdimagegetwin10spotlightlocksc...
Script     0.0        hhd-git                             {hhdgitaddcommitpush, hhdgitgraph, hhdgitposhinit, hhdgitresetclean...}
Script     0.0        hhd-iotcore                         {hhdiotconnect, hhdiotconnectfirstrp3, hhdiotconnectminwinpc, hhdiotmountdrivefirstrp3}
Script     0.0        hhd-main
Script     0.0        hhd-module                          {hhdmoduleinstallimport, hhdmoduleloadfromdll, hhdnugetrestore}
Script     0.0        hhd-onedrive                        hhdonedriveupload
Script     0.0        hhd-process                         {hhdkill, hhdkillallpowershellwithoutme, hhdkillvsgarbage, hhdps}
Script     0.0        hhd-sal-common                      {7z, AccCheckConsole, acccheckui, apt...}
Script     0.0        hhd-sal-hhdcommand                  {amcap, dbgview, depends, DSFMgr...}
Script     0.0        hhd-visual-studio                   {hhdvs2017openfile, hhdvs2017openhhdps}
```
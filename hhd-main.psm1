write "main start ..."
write "OutputEncoding = [System.Text.Encoding]::UTF8 ..."
$OutputEncoding = [System.Text.Encoding]::UTF8

# powershell_ise 에서 실행된다면 필요한 구문이다.
# write "[System.Console]::OutputEncoding = [Text.UTF8Encoding]::UTF8 ..."
# git status
# [System.Console]::OutputEncoding = [Text.UTF8Encoding]::UTF8

write "env:LC_ALL=C.UTF-8 ..."
$env:LC_ALL="C.UTF-8"

write "Set-ExecutionPolicy Bypass -Scope Process -Force ..."
Set-ExecutionPolicy Bypass -Scope Process -Force



$env:Path = "
$env:Path;

C:\Users\hhd20\AppData\Local\Android\Sdk\platform-tools;

C:\Users\hhd20\AppData\Local\Programs\Python\Python36;
C:\Users\hhd20\AppData\Local\Programs\Python\Python36\Scripts;

C:\Windows\Boot\PCAT;
C:\Windows\ImmersiveControlPanel;
C:\Windows\Microsoft.NET\Framework64\v4.0.30319;
C:\Windows\PrintDialog;
C:\Windows\servicing;
C:\Windows\SysWOW64\com;
C:\Windows\SysWOW64\F12;
C:\Windows\SysWOW64\IME\shared;
C:\Windows\SysWOW64\Speech_OneCore\common;
C:\Windows\SysWOW64\wbem;
C:\Windows\SysWOW64\WindowsPowerShell\v1.0;
C:\Windows\SysWOW64;

C:\Program Files\Bandizip;
C:\Program Files\Common Files\microsoft shared\DW;
C:\Program Files\Common Files\microsoft shared\EQUATION;
C:\Program Files\Common Files\microsoft shared\MSInfo;
C:\Program Files\dotnet;
C:\Program Files\Git\bin;
C:\Program Files\Git\cmd;
C:\Program Files\Git\usr\bin;
C:\Program Files\Git\usr\lib\ssh;
C:\Program Files\Git;
C:\Program Files\Microsoft Office\Office16;
C:\Program Files\Microsoft VS Code;
C:\Program Files\nodejs;

C:\Program Files (x86)\Common Files\microsoft shared\ink;
C:\Program Files (x86)\Common Files\microsoft shared\MSInfo;
C:\Program Files (x86)\Common Files\microsoft shared\TextTemplating\14.0;
C:\Program Files (x86)\ESTsoft\ALSee;
C:\Program Files (x86)\Evernote\Evernote;
C:\Program Files (x86)\Google\Chrome\Application;
C:\Program Files (x86)\HTML Help Workshop;
C:\Program Files (x86)\Internet Explorer;
C:\Program Files (x86)\Kakao\KakaoTalk;
C:\Program Files (x86)\Microsoft Help Viewer\v2.2;
C:\Program Files (x86)\Microsoft SDKs\TypeScript\2.5;
C:\Program Files (x86)\Microsoft SDKs\Windows\v10.0A\bin\NETFX 4.6 Tools\x64;
C:\Program Files (x86)\Microsoft Silverlight;
C:\Program Files (x86)\Microsoft Visual Studio\Preview\Community\Common7\IDE\CommonExtensions\Microsoft\WebClient\Language Service;
C:\Program Files (x86)\Microsoft Visual Studio\Preview\Community\Common7\IDE\Extensions\PreEmptiveSolutions\DotfuscatorCE;
C:\Program Files (x86)\Microsoft Visual Studio\Preview\Community\Common7\IDE\Remote Debugger\x64;
C:\Program Files (x86)\Microsoft Visual Studio\Preview\Community\Common7\IDE;
C:\Program Files (x86)\Microsoft Visual Studio\Preview\Community\Common7\Tools;
C:\Program Files (x86)\Microsoft Visual Studio\Preview\Community\MSBuild\15.0\Bin\Roslyn;
C:\Program Files (x86)\Microsoft Visual Studio\Preview\Community\MSBuild\Microsoft\VisualStudio\v15.0\AppxPackage;
C:\Program Files (x86)\Microsoft Visual Studio\Preview\Community\Team Tools\Performance Tools;
C:\Program Files (x86)\Microsoft Visual Studio\Preview\Community\VC\Tools\MSVC\14.12.25816\bin\Hostx64\x64;
C:\Program Files (x86)\Microsoft Visual Studio\Preview\Community\VSSDK\VisualStudioIntegration\Tools\Bin;
C:\Program Files (x86)\Microsoft Visual Studio\Shared\Common\VSPerfCollectionTools\x64;
C:\Program Files (x86)\Windows Kits\10\bin\x64;
C:\Program Files (x86)\Windows Mail;
C:\Program Files (x86)\Windows Media Player;
C:\Program Files (x86)\windows nt\accessories;
C:\Program Files (x86)\Windows Photo Viewer;

C:\AndroidStudio3\bin;
C:\AndroidStudio3\jre\bin;
C:\AndroidStudio3\jre\jre\bin;

C:\hhdcommand\AMCap;
C:\hhdcommand\dbeaver;
C:\hhdcommand\dbgview;
C:\hhdcommand\depends;
C:\hhdcommand\DSFMgr;
C:\hhdcommand\FileZilla;
C:\hhdcommand\KbManageTool;
C:\hhdcommand\PuTTYPortable\App\putty;
C:\hhdcommand\SublimeText;
C:\hhdcommand\WinSCP;
C:\hhdcommand\YouTubeToMP3;
C:\hhdcommand\MobaXterm;
C:\hhdcommand\OiColorPicker;
"
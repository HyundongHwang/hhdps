##
## temp.ps1
##

#<#
#.SYNOPSIS
#.EXAMPLE
##>
#function hhd-hello
#{
#    [CmdletBinding()]
#    param
#    (
#        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
#        [System.String]
#        $WORLD
#    )

#    process 
#    {
#        Write-Host "Ω√¿€"
#        $obj = New-Object -typename PSObject
#        $obj | Add-Member -MemberType NoteProperty -Name "hello" -Value "«Ô∑ŒøÏ"
#        $obj | Add-Member -MemberType NoteProperty -Name "world" -Value $WORLD
#        Write-Host "¡æ∑·"
#        return $obj;
#    }
#}



#hhd-hello -WORLD world
#@("¿œ", "¿Ã", "ªÔ") | hhd-hello








cd C:\project

ls -Directory | 
where { $_.Name -notlike "*.*" } |
where { Test-Path "$($_.FullName)\.git"} |
#where { 
#    cd $_.FullName
#    $resultStr = (git status)
#    return ($resultStr -like "*not staged*")
#} |
foreach {
    cd $_.FullName
    [string]$firstLine = (git remote -v)[0]
    $idx = $firstLine.IndexOf("git@")
    $idx2 = $firstLine.IndexOf(".git")
    $len = $idx2 - $idx + 4
    $url = $firstLine.Substring($idx, $len)
    return $url
} |
#foreach {
#    write ""
#    write ""
#    write ""
#    write "--------------------------------------------------------------------------------"
#    write $_.FullName
    
#    cd $_.FullName
#    git remote -v
#    git status
#}
Out-Host








<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-git-clone
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [System.String]
        $URL
    )

    process 
    {
        Write-Host "--------------------------------------------------------------------------------"
        Write-Host "URL : $URL"
        git clone $_ temp
        cd temp
        [string]$line = (git log --reverse --date=format:"%y%m%d" | sls "Date:")[0]
        [string]$dateyymmdd = $line.Split(" ", [System.StringSplitOptions]::RemoveEmptyEntries)[1]
        $idx = $_.IndexOf("/")
        [string]$projName = $_.Substring($idx + 1, $_.Length - $idx - 5)
        [string]$newDirName = "$($dateyymmdd)_$($projName)"
        cd ..
        Write-Host "newDirName : $($newDirName)"
        mv temp $newDirName

        $obj = New-Object -typename PSObject
        $obj | Add-Member -MemberType NoteProperty -Name "url" -Value $URL
        $obj | Add-Member -MemberType NoteProperty -Name "dir" -Value $newDirName
        return $obj;
    }
}










$rootDir = $PWD.Path

"git@gitlab.com:hhd2002/BujaAndroid.git
git@github.com:HyundongHwang/AndroidApp2App.git
git@github.com:HyundongHwang/BlackBox.git
git@github.com:HyundongHwang/CefWpfTest.git
git@github.com:HyundongHwang/Convert2PdfPs.git
git@github.com:HyundongHwang/DotNetTour.git
git@github.com:HyundongHwang/EasyZmq.git
git@github.com:HyundongHwang/FastFilePub.git
git@github.com:HyundongHwang/MaximSpa.git
git@github.com:HyundongHwang/MyDotNetDllCall.git
git@github.com:HyundongHwang/MyDotNetDllCall.git
git@github.com:HyundongHwang/MyJQueryStudy.git
git@github.com:HyundongHwang/MyMlStudy.git
git@github.com:HyundongHwang/MyQnA.git
git@github.com:HyundongHwang/MyShellHookTest.git
git@github.com:HyundongHwang/PsAdbScreenCap.git
git@github.com:HyundongHwang/android-ndk.git
git@github.com:HyundongHwang/beginningwebgl.git
git@github.com:HyundongHwang/gittest.git
git@gitlab.com:hhd2002/DeltaIsland.git
git@gitlab.com:hhd2002/DotNetTourBook.git
git@gitlab.com:hhd2002/hhdvscodesnippets.git
git@gitlab.com:hhd2002/hhdyidbot.git
git@gitlab.com:hhd2002/resume.git
git@gitlab.com:hhd2002/CoconutClient.git
git@gitlab.com:hhd2002/MyCloverApp.git
git@gitlab.com:hhd2002/NineDragon.git
git@gitlab.com:hhd2002/NntPayAndroid.git".Split("`n", [System.StringSplitOptions]::RemoveEmptyEntries) |
hhd-git-clone
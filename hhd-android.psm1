<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-android-install {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelinebyPropertyName = $true)]
        [System.String]
        $APK_PATH
    )

    adb install -r $APK_PATH
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-android-uninstall {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelinebyPropertyName = $true)]
        [System.String]
        $PKG_NAME
    )

    adb uninstall $PKG_NAME
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-android-pkg-show-all {
    [CmdletBinding()]
    param
    (
    )

    adb shell pm list packages
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-android-signing-report {
    [CmdletBinding()]
    param
    (
    )

    ./gradlew signingReport --daemon --stacktrace
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-android-gradle-clean {
    [CmdletBinding()]
    param
    (
    )

    ./gradlew clean --daemon --stacktrace
    Get-ChildItem *.apk, *.aar, *.jar -Recurse | Where-Object { $_.FullName -like "*build\outputs*" } | Select-Object FullName
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-android-gradle-assemble-debug {
    [CmdletBinding()]
    param
    (
    )

    ./gradlew assembleDebug --daemon --stacktrace
    Get-ChildItem *.apk, *.aar -Recurse | Select-Object FullName 
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-android-gradle-assemble-release {
    [CmdletBinding()]
    param
    (
    )

    ./gradlew assembleRelease --daemon --stacktrace
    Get-ChildItem *.apk, *.aar -Recurse | Select-Object FullName 
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-android-keytool-generate {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelinebyPropertyName = $true)]
        [System.String]
        $KEYSTORE_PATH,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelinebyPropertyName = $true)]
        [System.String]
        $ALIAS
    )

    keytool -genkey -v -keystore $KEYSTORE_PATH -alias $ALIAS -keyalg RSA -keysize 2048 -validity 10000
    Get-ChildItem *.keystore -Recurse | Select-Object FullName
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-android-keytool-show-from-keystore-file {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelinebyPropertyName = $true)]
        [System.String]
        $KEYSTORE_PATH
    )

    keytool -list -v -keystore $KEYSTORE_PATH
    Get-ChildItem *.keystore -Recurse | Select-Object FullName
}



<#
.SYNOPSIS
.EXAMPLE
	hhd-android-download-apk-from-device
	adb shell pm list packages -f -3
#>
function hhd-android-download-apk-from-device {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelinebyPropertyName = $true)]
        [System.String]
        $PKG_NAME
    )

    $apkPathAtDevice = (adb shell pm path $PKG_NAME) -replace "package:", ""
    Write-Host "apkPathAtDevice : $apkPathAtDevice ..."
    adb pull $apkPathAtDevice "$PKG_NAME.apk"
}



<#
.SYNOPSIS
.EXAMPLE
    adb shell dumpsys package com.hhd2002.hhdtest
#>
function hhd-android-dumpsys {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelinebyPropertyName = $true)]
        [System.String]
        $PKG_NAME
    )


    adb shell dumpsys package $PKG_NAME
}



<#
.SYNOPSIS
.EXAMPLE
    adb shell ls /sdcard/ -al
    adb shell ls /storage/ -al
    adb shell ls /sdcard/Download/ -al
#>
function hhd-android-ls-important {
    [CmdletBinding()]
    param
    (
    )

    

    $dirList = @("/sdcard/", "/storage/", "/sdcard/Download/", "/sdcard/Android/data/")

    $dirList | 
    ForEach-Object {
        write ""
        write ""
        write ""
        write "--------------------------------------------------------------------------------"
        write "dir : $_"
        adb shell ls $_ -al
    }
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-android-file-copy-from-device {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelinebyPropertyName = $true)]
        [System.String]
        $FILE_PATH_DEVICE,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelinebyPropertyName = $true)]
        [System.String]
        $FILE_PATH_PC
    )


    adb pull $FILE_PATH_DEVICE $FILE_PATH_PC
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-android-file-copy-to-device {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelinebyPropertyName = $true)]
        [System.String]
        $FILE_PATH_PC,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelinebyPropertyName = $true)]
        [System.String]
        $FILE_PATH_DEVICE
    )


    adb push $FILE_PATH_PC $FILE_PATH_DEVICE 
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-android-gradle-version {
    [CmdletBinding()]
    param
    (
    )


    .\gradlew -v
}



function hhd-android-pkg-show-current {
    [CmdletBinding()]
    param
    (
    )

    adb shell dumpsys activity activities | 
    Select-String mLastPausedActivity, mLastPausedActivity |
    ForEach-Object { 
        $tokenArray = $_.ToString().Split( [char]' ', [char]'/') | Where-Object { $_ -ne "" }
        $obj = New-Object -typename PSObject
        $obj | Add-Member PkgName $tokenArray[3]
        return $obj
    }
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-android-logcat {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelinebyPropertyName = $true)]
        [System.String]
        $PKG_NAME,

        [parameter(Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelinebyPropertyName = $true)]
        [ValidateSet("E", "W", "I", "D", "V")]
        [string]
        $LOG_LEVEL = "V"
    )

    adb -d logcat -c
    $searchRes = adb shell ps | Select-String $PKG_NAME

    if ($searchRes -eq 0) {
        Write-Host "$PKG_NAME not found !!!"
        return
    }

    $tokenArray = $searchRes[0].ToString().Split(" ") | Where-Object { $_ -ne "" }
    $pid = $tokenArray[1]

    Write-Host "--------------------------------------------------------------------------------"
    Write-Host "PKG_NAME[$PKG_NAME] pid[$pid] start logcat ..."
    Write-Host "--------------------------------------------------------------------------------"
    Write-Host "--------------------------------------------------------------------------------"
    Write-Host "--------------------------------------------------------------------------------"

    $filePath = "pkg_$($PKG_NAME)_$([datetime]::Now.ToString("yyMMdd_HHmmss")).log"
    adb -d logcat *:$LOG_LEVEL | Select-String $pid | Tee-Object -FilePath $filePath
}




<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-android-adb-start-app {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelinebyPropertyName = $true)]
        [System.String]
        $PACKAGE_NAME
    )



    adb shell monkey -p $PACKAGE_NAME 1
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-android-sdk-dir-ls {
    [CmdletBinding()]
    param
    (
    )



    $sdkDir = (ls "~\AppData\Local\Android\sdk\platforms\" | sort -Descending -Property Name | select -First 1).FullName
    ls $sdkDir -Recurse -Force | select FullName
}




<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-android-cleanup-build-process {
    [CmdletBinding()]
    param
    (
    )

    ps ninja, adb, java, cmake, clang* | kill -Force
    return $obj;
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-android-pcap-ls {
    [CmdletBinding()]
    param
    (
    )

    process {
        $TCAP_DIR = "/sdcard/Android/data/jp.co.taosoftware.android.packetcapture/files";
        
        $result = 
        adb shell ls $TCAP_DIR | 
        where { $_ -ne "" } |
        foreach 
        { 
            return "$TCAP_DIR/$_"
        }

        return $result
    }
}


<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-android-pcap-download {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelinebyPropertyName = $true)]
        [System.String]
        $DEVICE_FILE_PATH
    )

    process {
        $fileName = [System.IO.Path]::GetFileName($DEVICE_FILE_PATH)

        if (Test-Path $fileName) {
            Write-Host "$fileName : already exist !!!"
        }
        else {
            Write-Host "$fileName : copying ..."
            hhd-android-adb-file-copy-from-device -FILE_PATH_DEVICE $DEVICE_FILE_PATH -FILE_PATH_PC .    
        }
    }
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-android-pcap-rm {
    [CmdletBinding()]
    param
    (
    )

    process {
        $TCAP_DIR = "/sdcard/Android/data/jp.co.taosoftware.android.packetcapture/files";
        adb shell rm -rf
    }
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-android-rm-build-dir {
    [CmdletBinding()]
    param
    (
    )

    process {
        Get-ChildItem -Recurse | 
        where { $_.Name -eq "build" } | 
        Remove-Item -Force -Recurse
    }
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-android-gradle-task {
    [CmdletBinding()]
    param
    (
    )

    ./gradlew projects | 
    Select-String "Project ':.*'" | 
    ForEach-Object { 
        $_ -match "Project ':.*'" | Out-Null
        $proj = $Matches[0].Replace(" ", "").Replace("Project", "").Replace("'", "").Replace(":", ""); 
        return $proj
    } | 
    Set-Variable projArray

    Write-Host "--------------------------------------------------------------------------------"
    0..($projArray.Length - 1) |
    ForEach-Object {
        Write-Host "$($_) : $($projArray[$_])"
    }
    Write-Host "--------------------------------------------------------------------------------"

    $selIdx = Read-Host -Prompt "select proj : "
    $selProj = $projArray[$selIdx]
    Write-Host "selProj[$selProj]"

    ./gradlew "`:$selProj`:tasks" --all | 
    Select-String "\s-\s" | 
    Set-Variable res

    $res |
    ForEach-Object {
        $_ -match "\w+\s-" | Out-Null
        $task = $Matches[0].Replace(" -", "")
        return $task
    } |
    Set-Variable taskArray

    Write-Host "--------------------------------------------------------------------------------"
    0..($taskArray.Length - 1) |
    ForEach-Object {
        Write-Host "$($_) : $($taskArray[$_])"
    }
    Write-Host "--------------------------------------------------------------------------------"

    $selIdx = Read-Host -Prompt "select task : "
    $selTask = $taskArray[$selIdx]
    Write-Host "selTask[$selTask]"

    Read-Host -Prompt "./gradlew `:$selProj`:$selTask continue ?"
    ./gradlew "`:$selProj`:$selTask"

    # adb shell am force-stop $PKG_NAME
    # adb shell monkey -p $PKG_NAME -c android.intent.category.LAUNCHER 1
}
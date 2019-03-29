<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-android-install-apk {
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
        $PACKAGE_NAME
    )

    adb uninstall $PACKAGE_NAME
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-android-packages-show-in-device {
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
function hhd-android-gradle-signing-report {
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
    Get-ChildItem *.apk, *.aar, *.jar -Recurse  | where { $_.FullName -like "*build\outputs*" } | select FullName
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
    Get-ChildItem *.keystore -Recurse | select FullName
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
    Get-ChildItem *.keystore -Recurse | select FullName
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
        $PACKAGE_NAME
    )

    $apkPathAtDevice = (adb shell pm path $PACKAGE_NAME) -replace "package:", ""
    write "apkPathAtDevice : $apkPathAtDevice ..."
    adb pull $apkPathAtDevice "$PACKAGE_NAME.apk"
}



<#
.SYNOPSIS
.EXAMPLE
    adb shell dumpsys package com.hhd2002.hhdtest
#>
function hhd-android-adb-shell-dumpsys {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelinebyPropertyName = $true)]
        [System.String]
        $PACKAGE_NAME
    )


    adb shell dumpsys package $PACKAGE_NAME
}



<#
.SYNOPSIS
.EXAMPLE
    adb shell ls /sdcard/ -al
    adb shell ls /storage/ -al
    adb shell ls /sdcard/Download/ -al
#>
function hhd-android-adb-shell-ls-important {
    [CmdletBinding()]
    param
    (
    )

    

    $dirList = @("/sdcard/", "/storage/", "/sdcard/Download/", "/sdcard/Android/data/")

    $dirList | 
        foreach {
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
function hhd-android-adb-file-copy-from-device {
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
function hhd-android-adb-file-copy-to-device {
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




<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-android-adb-logcat {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelinebyPropertyName = $true)]
        [System.String]
        $PACKAGE_NAME,

        [parameter(Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelinebyPropertyName = $true)]
        [ValidateSet("E", "W", "I", "D", "V")]
        [string]
        $LOG_LEVEL = "V",

        [parameter(Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelinebyPropertyName = $true)]
        [switch]$CLEAR_LOG = $false
    )



    if ($CLEAR_LOG) {
        adb -d logcat -c
    }
    
    if ($PACKAGE_NAME -eq "") {
        adb -d logcat *:$LOG_LEVEL
    } else {
        $pidStr = (adb shell ps | sls $PACKAGE_NAME).ToString().Split(" ", [System.StringSplitOptions]::RemoveEmptyEntries)[1]

        Write-Host "PID : $pidStr start logcat ..."
        Write-Host ""
        Write-Host ""
        Write-Host ""
    
        adb -d logcat *:$LOG_LEVEL | sls $pidStr
    }
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
<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-android-install-apk
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [System.String]
        $APK_PATH
    )

    adb install -r $APK_PATH
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-android-uninstall
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [System.String]
        $PACKAGE_NAME
    )

    adb uninstall $PACKAGE_NAME
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-android-packages-show-in-device
{
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
function hhd-android-gradle-signing-report
{
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
function hhd-android-gradle-clean
{
    [CmdletBinding()]
    param
    (
    )

    ./gradlew clean --daemon --stacktrace
    ls *.apk, *.aar, *.jar -Recurse  | where { $_.FullName -like "*build\outputs*" } | select FullName
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-android-gradle-assemble-debug
{
    [CmdletBinding()]
    param
    (
    )

    ./gradlew assembleDebug --daemon --stacktrace
    ls *.apk, *.aar, *.jar -Recurse  | where { $_.FullName -like "*build\outputs*" } | select FullName
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-android-gradle-assemble-release
{
    [CmdletBinding()]
    param
    (
    )

    ./gradlew assembleRelease --daemon --stacktrace
    ls *.apk, *.aar, *.jar -Recurse  | where { $_.FullName -like "*build\outputs*" } | select FullName
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-android-keytool-generage
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [System.String]
        $KEYSTORE_PATH,

        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [System.String]
        $ALIAS
    )

    keytool -genkey -v -keystore $KEYSTORE_PATH -alias $ALIAS -keyalg RSA -keysize 2048 -validity 10000
    ls *.keystore -Recurse | select FullName
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-android-keytool-show-from-keystore-file
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [System.String]
        $KEYSTORE_PATH
    )

    keytool -list -v -keystore $KEYSTORE_PATH
    ls *.keystore -Recurse | select FullName
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-android-download-apk-from-device
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
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
function hhd-android-adb-shell-dumpsys
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
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
function hhd-android-adb-shell-ls-important
{
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
function hhd-android-adb-file-copy-from-device
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [System.String]
        $FILE_PATH_DEVICE,

        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [System.String]
        $FILE_PATH_PC
    )


    adb pull $FILE_PATH_DEVICE $FILE_PATH_PC
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-android-adb-file-copy-to-device
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [System.String]
        $FILE_PATH_PC,

        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [System.String]
        $FILE_PATH_DEVICE
    )


    adb push $FILE_PATH_PC $FILE_PATH_DEVICE 
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-android-gradle-version
{
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
function hhd-android-adb-logcat
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [System.String]
        $PACKAGE_NAME,

        [parameter(Mandatory = $false, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [ValidateSet("E", "W", "I", "D", "V")]
        [string]
        $LOG_LEVEL = "V",

        [parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [switch]$CLEAR_LOG = $false
    )



    if ($CLEAR_LOG) {
        adb -d logcat -c
    }
    
    $pidStr = (adb shell ps | sls $PACKAGE_NAME).ToString().Split(" ", [System.StringSplitOptions]::RemoveEmptyEntries)[1]

    write "PID : $pidStr start logcat ..."
    write ""
    write ""
    write ""

    adb -d logcat *:$LOG_LEVEL | sls $pidStr | 
    foreach {
        if ($_ -match "$pidStr\s\d*\sF") {
            Write-Host $_ -ForegroundColor Red
        } elseif ($_ -match "$pidStr\s\d*\sE") {
            Write-Host $_ -ForegroundColor Red
        } elseif ($_ -match "$pidStr\s\d*\sW") {
            Write-Host $_ -ForegroundColor Yellow
        } elseif ($_ -match "$pidStr\s\d*\sI") {
            Write-Host $_ -ForegroundColor Green
        } elseif ($_ -match "$pidStr\s\d*\sD") {
            Write-Host $_ -ForegroundColor Gray
        } elseif ($_ -match "$pidStr\s\d*\sV") {
            Write-Host $_ -ForegroundColor White
        } else {
            Write-Host $_ -ForegroundColor White
        }
    }
}




<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-android-adb-start-app
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [System.String]
        $PACKAGE_NAME
    )



    adb shell monkey -p $PACKAGE_NAME 1
}
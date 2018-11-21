
<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-ull-logcat {
    [CmdletBinding()]
    param
    (
    )

    $PACKAGE_NAME_LIST = @(
        "com.navercorp.ullplayerdev", 
        "com.navercorp.ullplayersimple", 
        "com.naver.vapp"
    )

    $pid = $null

    foreach ($packageName in $PACKAGE_NAME_LIST) {
        Write-Host "$packageName process searching ..."
        adb -d logcat -c

        try {
            $pid = (adb shell ps | Select-String $packageName)[0].ToString().Split(" ", [System.StringSplitOptions]::RemoveEmptyEntries)[1]

            if (![string]::IsNullOrEmpty($pid)) {
                Write-Host "$packageName[$pid] process found !!!"
                break
            }
        }
        catch {
        }
    }

    if ([string]::IsNullOrEmpty($pid)) {
        Write-Host "process not found !!!"
        return
    }

    Write-Host "$PACKAGE_NAME[$pid] start logcat ..."
    Write-Host ""
    Write-Host ""
    Write-Host ""
    $filePath = "hhd-ull-logcat-$([datetime]::Now.ToString("yyMMdd-HHmm")).log"

    adb -d logcat | 
        Select-String $pid |
        Tee-Object -FilePath $filePath
}




<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-ull-logcat-analysis {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelinebyPropertyName = $true)]
        [System.String]
        $LOG_FILE_PATH,

        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelinebyPropertyName = $true)]
        [System.String[]]
        $PATTERN_LIST
    )

    $urlMap = @{}
    $urlList = New-Object System.Collections.Generic.List[string]
    $statDic = @{}

    $logFileText = Get-Content $LOG_FILE_PATH -Head 100
    $logFileText | 
        foreach {
        $line = $_
        $res = $line -match "https?://.*[.mpd|.m4s|.m4v|.m4a|.mp4|.ts]"

        if (!$res) {
            return
        }



        $url = $Matches[0]
    
        if ($urlMap.ContainsKey($url)) {
            return
        }


        $urlList.Add($url)
        $urlMap[$url] = $null
    }

    $PATTERN_LIST | 
        foreach {
        $pattern = $_
        $statDic[$pattern] = New-Object System.Collections.Generic.List[psobject]
    }


    $urlList | 
        foreach {
        $url = $_
        Write-Host ("=" * 80)
        Write-Host $url -ForegroundColor Red
        Write-Host ("-" * 80)

        $logFileText | 
            Select-String $url | 
            logsloth -SHOW_FUNC_COUNT -RETURN_LOG_AS_TABLE |
            foreach {
            $row = $_

            $PATTERN_LIST | 
                foreach {
                
                $pattern = $_

                if ($pattern -eq $null) {
                    return
                }

                if ($row.Log -like "*$pattern*") {
                    $statList = $statDic[$pattern]
                    $statList.Add($row)
                }
            }
        }

        Write-Host ""
        Write-Host ""
        Write-Host ""
    }



    $statDic.Keys | 
        foreach {
        $key = $_
        $statList = $statDic[$key]
        Write-Host ("=" * 80)
        Write-Host $key -ForegroundColor Red
        Write-Host ("-" * 80)

        $statList | foreach {
            Write-Host "$([string]::Format("[{0}][{1,5}ms][{2,6}] {3}", $_.TimeStamp, $_.Period, $_.TID, $_.Log))"
        }

        Write-Host ""
        Write-Host ""
        Write-Host ""
    }
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-ull-stellite-linux-unit-test-build-run {
    [CmdletBinding()]
    param
    (
    )

    ~/project/stellite/tools/build.py --target-platform=linux --target stellite_http_client build --target-type shared_library --debug
    sudo rsync ~/project/stellite/build_linux/src/out_linux/debug/libstellite_http_client.so ~/project/stellite/example/linux-client/stellite/bin/libstellite_http_client.so
    sudo rm -rf ~/project/stellite/example/linux-client/CMakeCache.txt
    sudo rm -rf ~/project/stellite/example/linux-client/CMakeFiles
    cd ~/project/stellite/example/linux-client
    sudo cmake .
    sudo make
    ./MyStelliteLinuxTest | logsloth -OUT_AS_HTML
    $lastHtmlFile = Get-ChildItem *.html | Sort-Object Name | Select-Object -Last 1
    www $lastHtmlFile
}



# lv2-latency-log-analysis -LOG_FILE_PATH LV2-latency-180712-1438.log -PATTERN_LIST "received chunk data", "OnNewBuffer"
#cat LV2-latency-180712-1438.log -Head 100 | logsloth -SHOW_FUNC_COUNT -RETURN_LOG_AS_TABLE | Out-Null
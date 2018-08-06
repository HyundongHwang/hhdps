#
# lv2.ps1
#




<#
.SYNOPSIS
.EXAMPLE
#>
function logsloth {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelinebyPropertyName = $true)]
        [System.String]
        $LINE,

        [switch]
        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelinebyPropertyName = $true)]
        $TASKID_AS_SYMBOL = $false,

        [switch]
        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelinebyPropertyName = $true)]
        $SHOW_FUNC_COUNT = $false,

        [switch]
        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelinebyPropertyName = $true)]
        $RETURN_LOG_AS_TABLE = $false
    )

    begin {
        $_oldTime = $null
        $_oldTid = 0
        $_threadIndentDic = @{}
        $_funcCountDic = @{}
        $_oldLog
		
        $_funcColorDic = @{}
        $_COLOR_LIST = @("Green", "DarkGray", "DarkGreen", "DarkYellow", "Gray", "Magenta", "Cyan", "DarkCyan", "DarkRed", "Yellow")
        $_COLOR_LIST | Sort-Object { Get-Random } | Set-Variable _COLOR_LIST
        $_clrIdx = 0;
        $_oldClr = "White"

        $_taskIdSymDic = @{}
        $_TASK_SYM_LIST = "¡× ¡Ù ¡Ú ¡Ü ¡Ý ¡Þ ¡ß ¡á ¡â ¡ã ¡ä ¡å ¢· ¢¸ ¢¹ ¢º ¢» ¢¼ ¢½ ¢¾ ¢¿ ¢À ¢Á ¢Â ¢Ã ¢Ä ¢Å ¢Æ ¢Ç ¢È ¢É ¢Ê ¢Ë ¢Ì ¢Í ¢Î ¢Ï ¢Ð ¢Ñ ¢Ò ¢Ó¢Ô ¢Õ ¢Ö ¢× ¢Ø ¢Ù ¢Ú ¢Û ¢Ü ¢Ý ¢Þ ¢ß ¨± ¨² ¨³ ¨´ ¨µ ¨¶ ¨· ¨¸ ¨¹ ¨º ¨» ¨¼ ¨½ ¨¾ ¨¿ ¨À ¨Á ¨Â ¨Ã ¨Ä ¨Å ¨Æ ¨Ç ¨È ¨É ¨Ê ¨Ë ¨Ì ¨Í ¨Î ¨Ï ¨Ð ¨Ñ ¨Ò ¨Ó ¨Ô ¨Õ ¨Ö ¨× ¨Ø ¨Ù ¨Ú ¨Û ¨Ü ¨Ý ¨Þ ¨ß ¨à ¨á ¨â ¨ã ¨ä ¨å ¨æ ¨ç ¨è ¨é ¨ê ¨ë ¨ì ¨í ¨î ¨ï ¨ð ¨ñ ¨ò ¨ó ¨ô ¨õ ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ?"
        $_TASK_SYM_LIST.split(' ', [System.StringSplitOptions]::RemoveEmptyEntries) | Sort-Object { Get-Random } | Set-Variable _TASK_SYM_LIST
        $_taskIdIdx = 0

    }

    process {
        $curTime = $null

        if ($LINE -match "\d\d-\d\d\s\d\d:\d\d:\d\d.\d\d\d") {
            $curTime = [DateTime]::Parse("18-$($matches[0])")
        }
        else {
            Write-Host $LINE -ForegroundColor $_oldClr
            return
        }

        if ($_oldTime -eq $null) {
            $_oldTime = $curTime
        }

        $period = $curTime - $_oldTime
        $_oldTime = $curTime



        $lineTokens = $LINE.Split(" ", [System.StringSplitOptions]::RemoveEmptyEntries)
        $tid = $lineTokens[3]
        $tag = $lineTokens[5]
        $log = [string]::Join( " ", $lineTokens[6..$($lineTokens.Length)] ) 



        $taskId = $null
        $taskSym = $null
        $res = $LINE -match "TASKID\s:\s\d+\s\|"

        if ($res) {
            $res = $matches[0] -match "\d+"
            $taskId = $matches[0]

            if ($_taskIdSymDic.ContainsKey($taskId)) {
                $taskSym = $_taskIdSymDic[$taskId]
            }
            else {
                $taskSym = $_TASK_SYM_LIST[$_taskIdIdx]
                $_taskIdIdx += 1
                $_taskIdSymDic[$taskId] = $taskSym
            }
        }




        if ($_mainTid -eq 0) {
            $_mainTid = $tid
        }

	    

        $funcName = $null
        
        for ( $i = 0; $i -lt $lineTokens.Length; $i++ ) {
            $token = $lineTokens[$i]
            if ($token -match "[.cpp|.h|.cc|.c|.cxx|.hpp]:\d+:") {
                $res = $token -split ":"
                $funcName = "$($res[0])::$($res[2])"
                break
            }
        }

        if ($funcName -eq $null) {
            $funcName = "$tag$([string]::Join( " ", $lineTokens[5..6] ))"
            $log = "$tag$log"
        }

        if (!$_funcCountDic.ContainsKey($funcName)) {
            $_funcCountDic[$funcName] = 1
        }
        else {
            $_funcCountDic[$funcName] = $_funcCountDic[$funcName] + 1
        }

        



        $padCount = 0

        if (!$_threadIndentDic.ContainsKey($tid)) {
            $_threadIndentDic[$tid] = $_threadIndentDic.Count
        }

        $padCount = ($_threadIndentDic[$tid] % 10) * 4 + 1




        if (!$_funcColorDic.ContainsKey($funcName)) {
            $_funcColorDic[$funcName] = $_COLOR_LIST[$_clrIdx];
            $_clrIdx = ($_clrIdx + 1) % $_COLOR_LIST.Length;
        }

        

    
        
        $leftPadding = " " * $padCount;
        $beuatyLog = "[$($lineTokens[0]) $($lineTokens[1])][$([string]::Format("{0,5:N0}", $period.TotalMilliseconds))ms]$($leftPadding)";

        if ($tid -ne $_oldTid) {
            $beuatyLog += "TID[$tid] "
            $_oldTid = $tid
        }

        if ($taskId -ne $null) {
            if ($TASKID_AS_SYMBOL) {
                $beuatyLog += $taskSym * 3
            }
            else {
                $beuatyLog += "TASKID[$taskId] "
            }
        }

        $beuatyLog += $log
        $color = [System.ConsoleColor]::White

        if ($lineTokens[5] -eq "E") {
            $color = [System.ConsoleColor]::Red
        }
        elseif ($_funcColorDic.ContainsKey($funcName)) {
            $color = $_funcColorDic[$funcName]
            $_oldClr = $_funcColorDic[$funcName]
        }

        Write-Host $beuatyLog -ForegroundColor $color

        if($RETURN_LOG_AS_TABLE) {
            $row = New-Object psobject
            $row | Add-Member TimeStamp "$($lineTokens[0]) $($lineTokens[1])"
            $row | Add-Member Period "$([string]::Format("{0,5:N0}", $period.TotalMilliseconds))"
            $row | Add-Member TID $tid
            $row | Add-Member Color $color
            $row | Add-Member FuncName $funcName
            $row | Add-Member Log $log
            $row | Add-Member OldLog $_oldLog
            $_oldLog = $log
            return $row
        }
    }

    end {
        if($SHOW_FUNC_COUNT) {

            $_funcCountDic.Keys | 
            sort -Descending { 
                $funcName = $_
                $funcCount = $_funcCountDic[$funcName]
                return $funcCount } |
            foreach {
                $funcName = $_
                $funcCount = $_funcCountDic[$funcName]
                $statLog = "$([string]::Format("{0,-100} | {1,10}", $funcName, $funcCount))"
                Write-Host $statLog
            } # foreach
        } # if
    } # end
}




<#
.SYNOPSIS
.EXAMPLE
#>
function lv2-latency-log-capture
{
    [CmdletBinding()]
    param
    (
    )

    $PACKAGE_NAME = "com.navercorp.simpleullplayer"

    adb -d logcat -c
    $pidStr = (adb shell ps | Select-String $PACKAGE_NAME).ToString().Split(" ", [System.StringSplitOptions]::RemoveEmptyEntries)[1]
    Write-Host "PID : $pidStr start logcat ..."
    Write-Host ""
    Write-Host ""
    Write-Host ""
    $filePath = "LV2-latency-$([datetime]::Now.ToString("yyMMdd-HHmm")).log"

    adb -d logcat | 
    Select-String Latency |
    Select-String $pidStr |
    Tee-Object -FilePath $filePath |
    Select-String "Request Download Fragment", "OnNewBuffer"
}




<#
.SYNOPSIS
.EXAMPLE
#>
function lv2-latency-log-analysis
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [System.String]
        $LOG_FILE_PATH,

        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
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

        if(!$res) {
            return
        }



        $url = $Matches[0]
    
        if($urlMap.ContainsKey($url)) {
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

                if($pattern -eq $null) {
                    return
                }

                if($row.Log -like "*$pattern*") {
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




lv2-latency-log-analysis -LOG_FILE_PATH LV2-latency-180712-1438.log -PATTERN_LIST "received chunk data", "OnNewBuffer"
#cat LV2-latency-180712-1438.log -Head 100 | logsloth -SHOW_FUNC_COUNT -RETURN_LOG_AS_TABLE | Out-Null
#
# temp.ps1
#



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-hello
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [System.String]
        $WORLD
    )

	$obj = New-Object -typename PSObject
	$obj | Add-Member -MemberType NoteProperty -Name "hello" -Value "Çï·Î¿ì"
	$obj | Add-Member -MemberType NoteProperty -Name "world" -Value $WORLD
	return $obj;
}



hhd-hello -WORLD world



#ps ninja, adb, java, cmake, clang* | kill -Force


<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-android-cleanup-build-process
{
    [CmdletBinding()]
    param
    (
    )

	ps ninja, adb, java, cmake, clang* | kill -Force
	return $obj;
}



hhd-android-cleanup-build-process




ls -Directory -Exclude ".*" | 
foreach { 
	write "`n`n`n`n`n`n`n`n`n`n"
	write "PROJECT DIR : $($_.FullName)"
	write "`n`n`n"
	cd $_.FullName
	./gradlew clean
	./gradlew assembleRelease --daemon --stacktrace
	
	ls "*-release.apk" -Recurse | 
	foreach { 
		write "`n`n`n"
		write "APK FILE PATH : $($_.FullName )"
		write "adb install ..."
		write "`n`n`n"
		adb install -r $_.FullName 
	}

	cd ..
	pause
} | tee -FilePath build.log







ls -Directory |
where { $_.FullName -notlike "*assembly*"} | 
where { $_.FullName -notlike "*InfusedApps*"} | 
where { $_.FullName -notlike "*WinSxS*"} |
foreach {
  cd $_
  ls *.exe -Recurse
  cd ..
}







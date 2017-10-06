<#
.SYNOPSIS
.EXAMPLE
#>
function mycomplexfunc
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [System.Diagnostics.Process]
        $process,

        [System.String]
        $prefix,

        [System.String[]]
        $strArray
    )

    $obj = New-Object -typename PSObject

    $obj | Add-Member -MemberType NoteProperty -Name prefix -Value $prefix
    $obj | Add-Member -MemberType NoteProperty -Name ProcessName -Value $process.Name
    $obj | Add-Member -MemberType NoteProperty -Name ProcessId -Value $process.Id

    write ("strArray.Length : " + $strArray.Length)

    if ($strArray.Length -gt 0) 
    {
        $rand = New-Object -TypeName System.Random
        $idx = $rand.Next($strArray.Length)

        write ("idx : " + $idx)

        $randValue = $strArray[$idx]

        write ("randValue : " + $randValue)

        $obj | Add-Member -MemberType NoteProperty -Name randValue -Value $randValue
    }

    Write-Output $obj
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-network-get-pub-ip
{
    [CmdletBinding()]
    param
    (
    )

    $myPubIp = (Invoke-WebRequest -Uri http://icanhazip.com).Content
    return $myPubIp   
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-wmi-get-program
{
    [CmdletBinding()]
    param
    (
    )

    gwmi -Class win32_product
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-gcm-get-script-content
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [System.String]
        $cmdname
    )

    return (gcm $cmdname).ScriptBlock
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-file-append-time
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [System.IO.FileInfo]
        $file,

        [switch]
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        $changedatealwaysnew = $false
    )

    if($file.Name.StartsWith("."))
    {
        write "${file}.Name start with . so skip ..."
        return
    }

    $isProcessed = $false
    $date6 = $file.LastWriteTime.ToString("yyMMdd")
    $isPrefixNum = $false

    if($file.Name.Length -gt 6)
    {
        $first6 = $file.Name.SubString(0, 6)

        for($i = 0; $i -lt $first6.Length; $i++)
        {
            $isPrefixNum = @("0", "1", "2", "3", "4", "5", "6", "7", "8", "9") -contains $first6[$i]

            if ($isPrefixNum -eq $false) 
            {
                $isPrefixNum = $false
                break;
            }
        }
    }

    if($isPrefixNum)
    {
        if ($changedatealwaysnew) 
        {
            $newFileName = $date6 + $file.Name.Substring(6, $file.Name.Length - 6)
            mv $file $newFileName
            write "${file}.Name -> ${newFileName} !!!"
        }
        else 
        {
            write "${file}.Name is PrefixNum and is not changedatealwaysnew ..."
        }
    }
    else 
    {
        $newFileName = $date6 + " " + $file.Name
        write "${file}.Name -> ${newFileName}"
        mv $file $newFileName
    }
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-file-write-for-test
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [System.IO.FileInfo]
        $file
    )
        
    Read-Host | Out-File $file
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-network-get-ip-mac-address
{
    [CmdletBinding()]
    param
    (
    )

    Get-WmiObject win32_networkadapterconfiguration | 
        select description, macaddress, ipaddress | 
        ? { $_.macaddress -ne $null} | 
        fl
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-image-get-win10-spotlight-lock-screen
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [System.String]
        $dirName = "tmp"
    )

    $fileList = ls ~\AppData\Local\Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets\* | ? { $_.Length -gt 100000 }
    write $fileList
    md $dirName
    $fileList | % { cp $_.FullName "$dirName\$($_.Name).png" }
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-cert-from-website
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [System.String]
        $url
    )

    $req = [Net.WebRequest]::Create($url)
    $req.GetResponse() 
    $cert = $req.ServicePoint.Certificate
    $bytes = $cert.Export([Security.Cryptography.X509Certificates.X509ContentType]::Cert)
    $certFilePath = "$pwd\$($req.RequestUri.Host).cer"
    set-content -value $bytes -encoding byte -path $certFilePath
    certutil.exe -dump $certFilePath
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-path-set
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [System.String]
        $PATH_TO_ADD
    )

    if ($env:Path -like "*$PATH_TO_ADD*")
    {
        write "already added !!!"
        return
    }
    
    setx PATH "$env:path;$PATH_TO_ADD" /M
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-storage-sub-dir
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [System.String]
        $DIR
    )

    ls $DIR -Directory |
    foreach {
        $res = hhd-storage-dir -DIR $_.FullName
        return $res
    }
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-storage-dir
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [System.String]
        $DIR
    )

    $dir_name = Resolve-Path $DIR
    $sum_gb = (ls $DIR -Recurse -File | measure -Sum Length).Sum / 1GB
    $res = New-Object psobject
    $res | Add-Member -Name dir_name -Value $dir_name -MemberType NoteProperty
    $res | Add-Member -Name sum_gb -Value ("{0:N2}" -f $sum_gb) -MemberType NoteProperty
    return $res
}




<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-html-download-images
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [System.String]
        $URL,

        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [System.String]
        $PATTERN
    )

    $html = Invoke-WebRequest -Uri $URL -UseBasicParsing

    $html.Images.src |
    where {
        $_ -like "*$PATTERN*"
    } | 
    foreach {
        $imgUrl = $_

        if ($imgUrl.StartsWith("//")) {
            $imgUrl = "http:$imgUrl"
        }
        elseif (!($imgUrl.StartsWith("http"))) {
            $imgUrl = "http://$(([System.Uri]$URL).Host)$imgUrl"
        }

        return $imgUrl
    } |
    foreach {
        $fileName = [System.Web.HttpUtility]::UrlEncode($_) 
        write "$_ ..."
        Invoke-WebRequest -Uri $_ -OutFile $fileName
    }
}


<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-dotnet-get-assembly-info
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [System.String]
        $DLL_PATH
    )



    write ""
    write ""
    write ""
    write "----------------------------------------"
    write "[System.Diagnostics.FileVersionInfo]::GetVersionInfo"
    [System.Diagnostics.FileVersionInfo]::GetVersionInfo($DLL_PATH) | fl

    write ""
    write ""
    write ""
    write "----------------------------------------"
    write "[System.Reflection.Assembly]::LoadFile"
    [System.Reflection.Assembly]::LoadFile($DLL_PATH) | fl
}



<#
.SYNOPSIS
	Display current TCP/IP connections for local or remote system

.FUNCTIONALITY
    Computers

.DESCRIPTION
	Display current TCP/IP connections for local or remote system.  Includes the process ID (PID) and process name for each connection.
	If the port is not yet established, the port number is shown as an asterisk (*).	
	
.PARAMETER ProcessName
	Gets connections by the name of the process. The default value is '*'.
	
.PARAMETER Port
	The port number of the local computer or remote computer. The default value is '*'.

.PARAMETER Address
	Gets connections by the IP address of the connection, local or remote. Wildcard is supported. The default value is '*'.

.PARAMETER Protocol
	The name of the protocol (TCP or UDP). The default value is '*' (all)
	
.PARAMETER State
	Indicates the state of a TCP connection. The possible states are as follows:
		
	Closed       - The TCP connection is closed. 
	Close_Wait   - The local endpoint of the TCP connection is waiting for a connection termination request from the local user. 
	Closing      - The local endpoint of the TCP connection is waiting for an acknowledgement of the connection termination request sent previously. 
	Delete_Tcb   - The transmission control buffer (TCB) for the TCP connection is being deleted. 
	Established  - The TCP handshake is complete. The connection has been established and data can be sent. 
	Fin_Wait_1   - The local endpoint of the TCP connection is waiting for a connection termination request from the remote endpoint or for an acknowledgement of the connection termination request sent previously. 
	Fin_Wait_2   - The local endpoint of the TCP connection is waiting for a connection termination request from the remote endpoint. 
	Last_Ack     - The local endpoint of the TCP connection is waiting for the final acknowledgement of the connection termination request sent previously. 
	Listen       - The local endpoint of the TCP connection is listening for a connection request from any remote endpoint. 
	Syn_Received - The local endpoint of the TCP connection has sent and received a connection request and is waiting for an acknowledgment. 
	Syn_Sent     - The local endpoint of the TCP connection has sent the remote endpoint a segment header with the synchronize (SYN) control bit set and is waiting for a matching connection request. 
	Time_Wait    - The local endpoint of the TCP connection is waiting for enough time to pass to ensure that the remote endpoint received the acknowledgement of its connection termination request. 
	Unknown      - The TCP connection state is unknown.
	
	Values are based on the TcpState Enumeration:
	http://msdn.microsoft.com/en-us/library/system.net.networkinformation.tcpstate%28VS.85%29.aspx
        
    Cookie Monster - modified these to match netstat output per here:
    http://support.microsoft.com/kb/137984

.PARAMETER ComputerName
    If defined, run this command on a remote system via WMI.  \\computername\c$\netstat.txt is created on that system and the results returned here

.PARAMETER ShowHostNames
    If specified, will attempt to resolve local and remote addresses.

.PARAMETER tempFile
    Temporary file to store results on remote system.  Must be relative to remote system (not a file share).  Default is "C:\netstat.txt"

.PARAMETER AddressFamily
    Filter by IP Address family: IPv4, IPv6, or the default, * (both).

    If specified, we display any result where both the localaddress and the remoteaddress is in the address family.

.EXAMPLE
	Get-NetworkStatistics | Format-Table

.EXAMPLE
	Get-NetworkStatistics iexplore -computername k-it-thin-02 -ShowHostNames | Format-Table

.EXAMPLE
	Get-NetworkStatistics -ProcessName md* -Protocol tcp

.EXAMPLE
	Get-NetworkStatistics -Address 192* -State LISTENING

.EXAMPLE
	Get-NetworkStatistics -State LISTENING -Protocol tcp

.EXAMPLE
    Get-NetworkStatistics -Computername Computer1, Computer2

.EXAMPLE
    'Computer1', 'Computer2' | Get-NetworkStatistics

.OUTPUTS
	System.Management.Automation.PSObject

.NOTES
	Author: Shay Levy, code butchered by Cookie Monster
	Shay's Blog: http://PowerShay.com
    Cookie Monster's Blog: http://ramblingcookiemonster.github.io/

.LINK
    http://gallery.technet.microsoft.com/scriptcenter/Get-NetworkStatistics-66057d71
#>
function hhd-network-netstat {
	[OutputType('System.Management.Automation.PSObject')]
	[CmdletBinding()]
	param(
		
		[Parameter(Position=0)]
		[System.String]$ProcessName='*',
		
		[Parameter(Position=1)]
		[System.String]$Address='*',		
		
		[Parameter(Position=2)]
		$Port='*',

		[Parameter(Position=3,
                   ValueFromPipeline = $True,
                   ValueFromPipelineByPropertyName = $True)]
        [System.String[]]$ComputerName=$env:COMPUTERNAME,

		[ValidateSet('*','tcp','udp')]
		[System.String]$Protocol='*',

		[ValidateSet('*','Closed','Close_Wait','Closing','Delete_Tcb','DeleteTcb','Established','Fin_Wait_1','Fin_Wait_2','Last_Ack','Listening','Syn_Received','Syn_Sent','Time_Wait','Unknown')]
		[System.String]$State='*',

        [switch]$ShowHostnames,
        
        [switch]$ShowProcessNames = $true,	

        [System.String]$TempFile = "C:\netstat.txt",

        [validateset('*','IPv4','IPv6')]
        [string]$AddressFamily = '*'
	)
    
	begin{
        #Define properties
            $properties = 'ComputerName','Protocol','LocalAddress','LocalPort','RemoteAddress','RemotePort','State','ProcessName','PID'

        #store hostnames in array for quick lookup
            $dnsCache = @{}
            
	}
	
	process{

        foreach($Computer in $ComputerName) {

            #Collect processes
            if($ShowProcessNames){
                Try {
                    $processes = Get-Process -ComputerName $Computer -ErrorAction stop | select name, id
                }
                Catch {
                    Write-warning "Could not run Get-Process -computername $Computer.  Verify permissions and connectivity.  Defaulting to no ShowProcessNames"
                    $ShowProcessNames = $false
                }
            }
	    
            #Handle remote systems
                if($Computer -ne $env:COMPUTERNAME){

                    #define command
                        [string]$cmd = "cmd /c c:\windows\system32\netstat.exe -ano >> $tempFile"
            
                    #define remote file path - computername, drive, folder path
                        $remoteTempFile = "\\{0}\{1}`${2}" -f "$Computer", (split-path $tempFile -qualifier).TrimEnd(":"), (Split-Path $tempFile -noqualifier)

                    #delete previous results
                        Try{
                            $null = Invoke-WmiMethod -class Win32_process -name Create -ArgumentList "cmd /c del $tempFile" -ComputerName $Computer -ErrorAction stop
                        }
                        Catch{
                            Write-Warning "Could not invoke create win32_process on $Computer to delete $tempfile"
                        }

                    #run command
                        Try{
                            $processID = (Invoke-WmiMethod -class Win32_process -name Create -ArgumentList $cmd -ComputerName $Computer -ErrorAction stop).processid
                        }
                        Catch{
                            #If we didn't run netstat, break everything off
                            Throw $_
                            Break
                        }

                    #wait for process to complete
                        while (
                            #This while should return true until the process completes
                                $(
                                    try{
                                        get-process -id $processid -computername $Computer -ErrorAction Stop
                                    }
                                    catch{
                                        $FALSE
                                    }
                                )
                        ) {
                            start-sleep -seconds 2 
                        }
            
                    #gather results
                        if(test-path $remoteTempFile){
                    
                            Try {
                                $results = Get-Content $remoteTempFile | Select-String -Pattern '\s+(TCP|UDP)'
                            }
                            Catch {
                                Throw "Could not get content from $remoteTempFile for results"
                                Break
                            }

                            Remove-Item $remoteTempFile -force

                        }
                        else{
                            Throw "'$tempFile' on $Computer converted to '$remoteTempFile'.  This path is not accessible from your system."
                            Break
                        }
                }
                else{
                    #gather results on local PC
                        $results = netstat -ano | Select-String -Pattern '\s+(TCP|UDP)'
                }

            #initialize counter for progress
                $totalCount = $results.count
                $count = 0
    
            #Loop through each line of results    
	            foreach($result in $results) {
            
    	            $item = $result.line.split(' ',[System.StringSplitOptions]::RemoveEmptyEntries)
    
    	            if($item[1] -notmatch '^\[::'){
                    
                        #parse the netstat line for local address and port
    	                    if (($la = $item[1] -as [ipaddress]).AddressFamily -eq 'InterNetworkV6'){
    	                        $localAddress = $la.IPAddressToString
    	                        $localPort = $item[1].split('\]:')[-1]
    	                    }
    	                    else {
    	                        $localAddress = $item[1].split(':')[0]
    	                        $localPort = $item[1].split(':')[-1]
    	                    }
                    
                        #parse the netstat line for remote address and port
    	                    if (($ra = $item[2] -as [ipaddress]).AddressFamily -eq 'InterNetworkV6'){
    	                        $remoteAddress = $ra.IPAddressToString
    	                        $remotePort = $item[2].split('\]:')[-1]
    	                    }
    	                    else {
    	                        $remoteAddress = $item[2].split(':')[0]
    	                        $remotePort = $item[2].split(':')[-1]
    	                    }

                        #Filter IPv4/IPv6 if specified
                            if($AddressFamily -ne "*")
                            {
                                if($AddressFamily -eq 'IPv4' -and $localAddress -match ':' -and $remoteAddress -match ':|\*' )
                                {
                                    #Both are IPv6, or ipv6 and listening, skip
                                    Write-Verbose "Filtered by AddressFamily:`n$result"
                                    continue
                                }
                                elseif($AddressFamily -eq 'IPv6' -and $localAddress -notmatch ':' -and ( $remoteAddress -notmatch ':' -or $remoteAddress -match '*' ) )
                                {
                                    #Both are IPv4, or ipv4 and listening, skip
                                    Write-Verbose "Filtered by AddressFamily:`n$result"
                                    continue
                                }
                            }
    	    		
                        #parse the netstat line for other properties
    	    		        $procId = $item[-1]
    	    		        $proto = $item[0]
    	    		        $status = if($item[0] -eq 'tcp') {$item[3]} else {$null}	

                        #Filter the object
		    		        if($remotePort -notlike $Port -and $localPort -notlike $Port){
                                write-verbose "remote $Remoteport local $localport port $port"
                                Write-Verbose "Filtered by Port:`n$result"
                                continue
		    		        }

		    		        if($remoteAddress -notlike $Address -and $localAddress -notlike $Address){
                                Write-Verbose "Filtered by Address:`n$result"
                                continue
		    		        }
    	    			     
    	    			    if($status -notlike $State){
                                Write-Verbose "Filtered by State:`n$result"
                                continue
		    		        }

    	    			    if($proto -notlike $Protocol){
                                Write-Verbose "Filtered by Protocol:`n$result"
                                continue
		    		        }
                   
                        #Display progress bar prior to getting process name or host name
                            Write-Progress  -Activity "Resolving host and process names"`
                                -Status "Resolving process ID $procId with remote address $remoteAddress and local address $localAddress"`
                                -PercentComplete (( $count / $totalCount ) * 100)
    	    		
                        #If we are running showprocessnames, get the matching name
                            if($ShowProcessNames -or $PSBoundParameters.ContainsKey -eq 'ProcessName'){
                        
                                #handle case where process spun up in the time between running get-process and running netstat
                                if($procName = $processes | Where {$_.id -eq $procId} | select -ExpandProperty name ){ }
                                else {$procName = "Unknown"}

                            }
                            else{$procName = "NA"}

		    		        if($procName -notlike $ProcessName){
                                Write-Verbose "Filtered by ProcessName:`n$result"
                                continue
		    		        }
    	    						
                        #if the showhostnames switch is specified, try to map IP to hostname
                            if($showHostnames){
                                $tmpAddress = $null
                                try{
                                    if($remoteAddress -eq "127.0.0.1" -or $remoteAddress -eq "0.0.0.0"){
                                        $remoteAddress = $Computer
                                    }
                                    elseif($remoteAddress -match "\w"){
                                        
                                        #check with dns cache first
                                            if ($dnsCache.containskey( $remoteAddress)) {
                                                $remoteAddress = $dnsCache[$remoteAddress]
                                                write-verbose "using cached REMOTE '$remoteAddress'"
                                            }
                                            else{
                                                #if address isn't in the cache, resolve it and add it
                                                    $tmpAddress = $remoteAddress
                                                    $remoteAddress = [System.Net.DNS]::GetHostByAddress("$remoteAddress").hostname
                                                    $dnsCache.add($tmpAddress, $remoteAddress)
                                                    write-verbose "using non cached REMOTE '$remoteAddress`t$tmpAddress"
                                            }
                                    }
                                }
                                catch{ }

                                try{

                                    if($localAddress -eq "127.0.0.1" -or $localAddress -eq "0.0.0.0"){
                                        $localAddress = $Computer
                                    }
                                    elseif($localAddress -match "\w"){
                                        #check with dns cache first
                                            if($dnsCache.containskey($localAddress)){
                                                $localAddress = $dnsCache[$localAddress]
                                                write-verbose "using cached LOCAL '$localAddress'"
                                            }
                                            else{
                                                #if address isn't in the cache, resolve it and add it
                                                    $tmpAddress = $localAddress
                                                    $localAddress = [System.Net.DNS]::GetHostByAddress("$localAddress").hostname
                                                    $dnsCache.add($localAddress, $tmpAddress)
                                                    write-verbose "using non cached LOCAL '$localAddress'`t'$tmpAddress'"
                                            }
                                    }
                                }
                                catch{ }
                            }
    
    	    		    #Write the object	
    	    		        New-Object -TypeName PSObject -Property @{
		    		            ComputerName = $Computer
                                PID = $procId
		    		            ProcessName = $procName
		    		            Protocol = $proto
		    		            LocalAddress = $localAddress
		    		            LocalPort = $localPort
		    		            RemoteAddress =$remoteAddress
		    		            RemotePort = $remotePort
		    		            State = $status
		    	            } | Select-Object -Property $properties								

                        #Increment the progress counter
                            $count++
                    }
                }
        }
    }
}



<#
.SYNOPSIS
    Convertto-TextASCIIArt converts text string to ASCII Art.
.DESCRIPTION
    The Convertto-TextASCIIArt show normal string or text as big font nicely on console. I have created one font for use (It is not exactly font but background color and cannot be copied), alternatively if you are using online parameter it will fetch more fonts online from 'http://artii.herokuapp.com'.
.PARAMETER Text
    This is common parameter for inbuilt and online and incase not provided default value is '# This is test !', If you are using inbuilt font small letter will convert to capital letter.
.PARAMETER Online
    To use this parameter make sure you have active internet connection, as it will connect to website http://artii.herokuapp.com and and using api it will download the acsii Art
.PARAMETER FontName
    There are wide variaty of font list available on http://artii.herokuapp.com/fonts_list, when using online parameter, Value provided here is case sensetive.
.PARAMETER FontColor
    Below is the list of font color can be used to show ascii art.
    'Black', 'DarkBlue','DarkGreen','DarkCyan', 'DarkRed','DarkMagenta','DarkYellow','Gray','DarkGray','Blue','Green','Cyan','Red','Magenta','Yellow','White'
.PARAMETER FontHight
    This parameter is optional and default value is 5, this is font hight and required for the font I created. Algorithm of this script is depend on the default value.
.INPUTS
    [System.String]
.OUTPUTS
    [console]
.NOTES
    Version:        1.0
    Author:         Kunal Udapi
    Creation Date:  30 September 2017
    Purpose/Change: Personal use to show text to ascii art.
    Useful URLs: http://vcloud-lab.com, http://artii.herokuapp.com/fonts_list
.EXAMPLE
    PS C:\>.\Convertto-TextASCIIArt -Online -Text "http://vcloud-lab.com" -FontColor Gray -Fontname big
  _     _   _              ____         _                 _        _       _                         
 | |   | | | |       _    / / /        | |               | |      | |     | |                        
 | |__ | |_| |_ _ __(_)  / / /_   _____| | ___  _   _  __| |______| | __ _| |__   ___ ___  _ __ ___  
 | '_ \| __| __| '_ \   / / /\ \ / / __| |/ _ \| | | |/ _` |______| |/ _` | '_ \ / __/ _ \| '_ ` _ \ 
 | | | | |_| |_| |_) | / / /  \ V / (__| | (_) | |_| | (_| |      | | (_| | |_) | (__ (_) | | | | | |
 |_| |_|\__|\__| .__(_)_/_/    \_/ \___|_|\___/ \__,_|\__,_|      |_|\__,_|_.__(_)___\___/|_| |_| |_|
               | |                                                                                   
               |_|                                                                                   

    Shows and converts text to cool ascii art from online site http://artii.herokuapp.com using apis.
.EXAMPLE
    PS C:\>.\Convertto-TextASCIIArt -Text '# This !'

      ¦¦  ¦¦     ¦¦¦¦¦¦ ¦¦  ¦¦ ¦¦   ¦¦¦¦     ¦¦
    ¦¦¦¦¦¦¦¦¦¦     ¦¦   ¦¦  ¦¦ ¦¦ ¦¦         ¦¦  
      ¦¦  ¦¦       ¦¦   ¦¦¦¦¦¦ ¦¦   ¦¦       ¦¦  
    ¦¦¦¦¦¦¦¦¦¦     ¦¦   ¦¦  ¦¦ ¦¦     ¦¦    
      ¦¦  ¦¦       ¦¦   ¦¦  ¦¦ ¦¦ ¦¦¦¦       ¦¦  
    
    Shows local font on the script not internet required
#>
function hhd-convertto-ascii-art
{
    [CmdletBinding(SupportsShouldProcess=$True,
    ConfirmImpact='Medium',
    HelpURI='http://vcloud-lab.com',
    DefaultParameterSetName='Inbuilt')]
    Param
    (
        [parameter(Position=0, ParameterSetName='Inbuilt', ValueFromPipelineByPropertyName=$true, ValueFromPipeline=$true, HelpMessage='Provide valid text')]
        [parameter(Position=0, ParameterSetName='Online', ValueFromPipelineByPropertyName=$true, ValueFromPipeline=$true, HelpMessage='Provide valid text')]
        [string]$Text = '# This is test !',
        [parameter(Position=2, ParameterSetName='Inbuilt', ValueFromPipelineByPropertyName=$true, HelpMessage='Provide existing font hight')]
        [Alias('Hight')]    
        [string]$FontHight = '5',
        
        [parameter(Position=2, ParameterSetName='Online', ValueFromPipelineByPropertyName=$true, HelpMessage='Provide font name list is avaliable on http://artii.herokuapp.com/fonts_list')]
        [ValidateSet('3-d','3x5','5lineoblique','1943____','4x4_offr','64f1____','a_zooloo','advenger','aquaplan','asc_____','ascii___','assalt_m','asslt__m','atc_____','atc_gran','b_m__200','battle_s','battlesh','baz__bil','beer_pub','bubble__','bubble_b','c1______','c2______','c_ascii_','c_consen','caus_in_','char1___','char2___','char3___','char4___','charact1','charact2','charact3','charact4','charact5','charact6','characte','charset_','coil_cop','com_sen_','computer','convoy__','d_dragon','dcs_bfmo','deep_str','demo_1__','demo_2__','demo_m__','devilish','druid___','e__fist_','ebbs_1__','ebbs_2__','eca_____','etcrvs__','f15_____','faces_of','fair_mea','fairligh','fantasy_','fbr12___','fbr1____','fbr2____','fbr_stri','fbr_tilt','finalass','fireing_','flyn_sh','fp1_____','fp2_____','funky_dr','future_1','future_2','future_3','future_4','future_5','future_6','future_7','future_8','gauntlet','ghost_bo','gothic','gothic__','grand_pr','green_be','hades___','heavy_me','heroboti','high_noo','hills___','home_pak','house_of','hypa_bal','hyper___','inc_raw_','italics_','joust___','kgames_i','kik_star','krak_out','lazy_jon','letter_w','letterw3','lexible_','mad_nurs','magic_ma','master_o','mayhem_d','mcg_____','mig_ally','modern__','new_asci','nfi1____','notie_ca','npn_____','odel_lak','ok_beer_','outrun__','p_s_h_m_','p_skateb','pacos_pe','panther_','pawn_ins','phonix__','platoon2','platoon_','pod_____','r2-d2___','rad_____','rad_phan','radical_','rainbow_','rally_s2','rally_sp','rampage_','rastan__','raw_recu','rci_____','ripper!_','road_rai','rockbox_','rok_____','roman','roman___','script__','skate_ro','skateord','skateroc','sketch_s','sm______','space_op','spc_demo','star_war','stealth_','stencil1','stencil2','street_s','subteran','super_te','t__of_ap','tav1____','taxi____','tec1____','tec_7000','tecrvs__','ti_pan__','timesofl','tomahawk','top_duck','trashman','triad_st','ts1_____','tsm_____','tsn_base','twin_cob','type_set','ucf_fan_','ugalympi','unarmed_','usa_____','usa_pq__','vortron_','war_of_w','yie-ar__','yie_ar_k','z-pilot_','zig_zag_','zone7___','acrobatic','alligator','alligator2','alphabet','avatar','banner','banner3-D','banner3','banner4','barbwire','basic','5x7','5x8','6x10','6x9','brite','briteb','britebi','britei','chartr','chartri','clb6x10','clb8x10','clb8x8','cli8x8','clr4x6','clr5x10','clr5x6','clr5x8','clr6x10','clr6x6','clr6x8','clr7x10','clr7x8','clr8x10','clr8x8','cour','courb','courbi','couri','helv','helvb','helvbi','helvi','sans','sansb','sansbi','sansi','sbook','sbookb','sbookbi','sbooki','times','tty','ttyb','utopia','utopiab','utopiabi','utopiai','xbrite','xbriteb','xbritebi','xbritei','xchartr','xchartri','xcour','xcourb','xcourbi','xcouri','xhelv','xhelvb','xhelvbi','xhelvi','xsans','xsansb','xsansbi','xsansi','xsbook','xsbookb','xsbookbi','xsbooki','xtimes','xtty','xttyb','bell','big','bigchief','binary','block','broadway','bubble','bulbhead','calgphy2','caligraphy','catwalk','chunky','coinstak','colossal','contessa','contrast','cosmic','cosmike','crawford','cricket','cursive','cyberlarge','cybermedium','cybersmall','decimal','diamond','digital','doh','doom','dotmatrix','double','drpepper','dwhistled','eftichess','eftifont','eftipiti','eftirobot','eftitalic','eftiwall','eftiwater','epic','fender','fourtops','fraktur','goofy','graceful','gradient','graffiti','hex','hollywood','invita','isometric1','isometric2','isometric3','isometric4','italic','ivrit','jazmine','jerusalem','katakana','kban','l4me','larry3d','lcd','lean','letters','linux','lockergnome','madrid','marquee','maxfour','mike','mini','mirror','mnemonic','morse','moscow','mshebrew210','nancyj-fancy','nancyj-underlined','nancyj','nipples','ntgreek','nvscript','o8','octal','ogre','os2','pawp','peaks','pebbles','pepper','poison','puffy','pyramid','rectangles','relief','relief2','rev','rot13','rounded','rowancap','rozzo','runic','runyc','sblood','script','serifcap','shadow','short','slant','slide','slscript','small','smisome1','smkeyboard','smscript','smshadow','smslant','smtengwar','speed','stacey','stampatello','standard','starwars','stellar','stop','straight','tanja','tengwar','term','thick','thin','threepoint','ticks','ticksslant','tinker-toy','tombstone','trek','tsalagi','twopoint','univers','usaflag','weird','whimsy')]
        [Alias('Font')]
        [string]$FontName = 'big',

        [parameter(ParameterSetName = 'Online', Position=0, Mandatory=$false)]
        [Switch]$Online,

        [parameter(Position=1, ParameterSetName='Inbuilt', ValueFromPipelineByPropertyName=$true, ValueFromPipeline=$true, HelpMessage='Provide valid console color')]
        [parameter(ParameterSetName = 'Online', Position=1, Mandatory=$false, HelpMessage='Provide valid console color')]  
        [Alias('Color')]
        [ValidateSet('Black', 'DarkBlue','DarkGreen','DarkCyan', 'DarkRed','DarkMagenta','DarkYellow','Gray','DarkGray','Blue','Green','Cyan','Red','Magenta','Yellow','White')]
        [string]$FontColor = 'Yellow'
    )



    Begin {
        #$NonExistFont = $null
        if ($PsCmdlet.ParameterSetName -eq 'Inbuilt') {
            $a = {<#a 07#> Write-Host $(" " * 6) -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#a#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host "  " -NoNewline; Write-Host "  " -BackgroundColor $FontColor  -NoNewline; Write-Host " "
            <#a#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host "  " -NoNewline; Write-Host "  " -BackgroundColor $FontColor  -NoNewline; Write-Host " "
            <#a#> Write-Host $(" " * 6) -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#a#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host "  " -NoNewline; Write-Host "  " -BackgroundColor $FontColor  -NoNewline; Write-Host " "} 
            $b = {<#b 07#> Write-Host $(" " * 4) -BackgroundColor $FontColor -NoNewline; Write-Host $(" " * 3) 
            <#b#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host "  " -NoNewline; Write-Host "  " -BackgroundColor $FontColor   -NoNewline; Write-Host " "
            <#b#> Write-Host $(" " * 6) -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#b#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host "  " -NoNewline; Write-Host "  " -BackgroundColor $FontColor  -NoNewline; Write-Host " "
            <#b#> Write-Host $(" " * 4) -BackgroundColor $FontColor -NoNewline; Write-Host $(" " * 3) } 
            $c = {<#c 07#> Write-Host $(" " * 5) -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#c#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host $(" " * 4) 
            <#c#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host $(" " * 4)
            <#c#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host $(" " * 4)
            <#c#> Write-Host $(" " * 5) -BackgroundColor $FontColor -NoNewline; Write-Host " "}
            $d = {<#d 07#> Write-Host $(" " * 4) -BackgroundColor $FontColor -NoNewline; Write-Host $(" " * 3)
            <#d#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host "  " -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#d#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host "  " -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#d#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host "  " -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#d#> Write-Host $(" " * 4) -BackgroundColor $FontColor -NoNewline; Write-Host $(" " * 3)}  
            $e = {<#e 06#> Write-Host $(" " * 5) -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#e#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host $(" " * 4)
            <#e#> Write-Host $(" " * 4) -BackgroundColor $FontColor -NoNewline; Write-Host "  " 
            <#e#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host $(" " * 4)
            <#e#> Write-Host $(" " * 5) -BackgroundColor $FontColor -NoNewline; Write-Host " "}
            $f = {<#f 07#> Write-Host $(" " * 5) -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#f#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host $(" " * 4)
            <#f#> Write-Host $(" " * 4) -BackgroundColor $FontColor -NoNewline; Write-Host "  "
            <#f#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host $(" " * 4)
            <#f#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host $(" " * 4)}
            $g = {<#g 07#> Write-Host $(" " * 6) -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#g#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host $(" " * 5)
            <#g#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " " -NoNewline; Write-Host " " -NoNewline -BackgroundColor $FontColor; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#g#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host "  " -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#g#> Write-Host $(" " * 6) -BackgroundColor $FontColor -NoNewline; Write-Host " "}
            $h = {<#h 07#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host "  " -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " " 
            <#h#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host "  " -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " " 
            <#h#> Write-Host $(" " * 6) -BackgroundColor $FontColor -NoNewline; Write-Host " " 
            <#h#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host "  " -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#h#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host "  " -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "}
            $i = {<#i 03#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " " 
            <#i#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "  
            <#i#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " " 
            <#i#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " " 
            <#i#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "}
            $j = {<#j 07#> Write-Host "  " -NoNewline; Write-Host $(" " * 4) -BackgroundColor $FontColor -NoNewline; Write-Host " " 
            <#j#> Write-Host $(" " * 4) -NoNewline; Write-Host "  " -NoNewline -BackgroundColor $FontColor; Write-Host " "  
            <#j#> Write-Host $(" " * 4) -NoNewline; Write-Host "  " -NoNewline -BackgroundColor $FontColor; Write-Host " " 
            <#h#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host "  " -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#j#> Write-Host $(" " * 6) -BackgroundColor $FontColor -NoNewline; Write-Host " "}
            $k = {<#k 09#> Write-Host "  " -NoNewline -BackgroundColor $FontColor; Write-Host $(" " * 3) -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#k#> Write-Host "  " -NoNewline -BackgroundColor $FontColor; Write-Host " " -NoNewline; Write-Host "  " -NoNewline -BackgroundColor $FontColor; Write-Host $(" " * 3)
            <#k#> Write-Host $(" " * 3) -BackgroundColor $FontColor -NoNewline; Write-Host $(" " * 5)
            <#k#> Write-Host "  " -NoNewline -BackgroundColor $FontColor; Write-Host " " -NoNewline; Write-Host "  " -NoNewline -BackgroundColor $FontColor; Write-Host $(" " * 3)
            <#k#> Write-Host "  " -NoNewline -BackgroundColor $FontColor; Write-Host $(" " * 3) -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "}
            $l = {<#l 05#> Write-Host "  " -NoNewline -BackgroundColor $FontColor; Write-Host "  " -NoNewline; Write-Host " "
            <#l#> Write-Host "  " -NoNewline -BackgroundColor $FontColor; Write-Host $(" " * 3)
            <#l#> Write-Host "  " -NoNewline -BackgroundColor $FontColor; Write-Host $(" " * 3)
            <#l#> Write-Host "  " -NoNewline -BackgroundColor $FontColor; Write-Host $(" " * 3)
            <#l#> Write-Host "  " -NoNewline -BackgroundColor $FontColor; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "}
            $m = {<#m 09#> Write-Host "  " -NoNewline -BackgroundColor $FontColor; Write-Host $(" " * 4) -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#m#> Write-Host $(" " * 3) -NoNewline -BackgroundColor $FontColor; Write-Host "  " -NoNewline; Write-Host $(" " * 3) -NoNewline -BackgroundColor $FontColor; Write-Host " "
            <#m#> Write-Host "  " -NoNewline -BackgroundColor $FontColor; Write-Host " " -NoNewline ; Write-Host "  " -NoNewline -BackgroundColor $FontColor ; Write-Host " " -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#m#> Write-Host "  " -NoNewline -BackgroundColor $FontColor; Write-Host $(" " * 4) -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#m#> Write-Host "  " -NoNewline -BackgroundColor $FontColor; Write-Host $(" " * 4) -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "}
            $n = {<#n 09#> Write-Host $(" " * 3) -NoNewline -BackgroundColor $FontColor; Write-Host $(" " * 3) -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#n#> Write-Host "  " -NoNewline -BackgroundColor $FontColor; Write-Host " " -NoNewline; Write-Host " " -NoNewline -BackgroundColor $FontColor; Write-Host "  " -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#n#> Write-Host "  " -NoNewline -BackgroundColor $FontColor; Write-Host "  " -NoNewline; Write-Host " " -NoNewline -BackgroundColor $FontColor ; Write-Host " " -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#n#> Write-Host "  " -NoNewline -BackgroundColor $FontColor; Write-Host $(" " * 3) -NoNewline; Write-Host " " -NoNewline -BackgroundColor $FontColor; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#n#> Write-Host "  " -NoNewline -BackgroundColor $FontColor; Write-Host $(" " * 4) -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "}
            $o = {<#o 07#> Write-Host $(" " * 6) -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#o#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host "  " -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#o#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host "  " -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#o#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host "  " -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#o#> Write-Host $(" " * 6) -BackgroundColor $FontColor -NoNewline; Write-Host " "}
            $p = {<#p 07#> Write-Host $(" " * 6) -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#p#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host "  " -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#p#> Write-Host $(" " * 6) -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#p#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host $(" " * 5) 
            <#p#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host $(" " * 5)}
            $q = {<#q 09#> Write-Host "  " -NoNewline; Write-Host $(" " * 4) -BackgroundColor $FontColor -NoNewline; Write-Host $(" " * 3)
            <#q#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host $(" " * 4) -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#q#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host $(" " * 4) -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#q#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host "  " -NoNewline; Write-Host "  " -NoNewline -BackgroundColor $FontColor; Write-Host $(" " * 3)
            <#q#> Write-Host "  " -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host "  " -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "}
            $r = {<#r 07#> Write-Host $(" " * 6) -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#r#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host "  " -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#r#> Write-Host $(" " * 6) -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#r#> Write-Host $(" " * 4) -BackgroundColor $FontColor -NoNewline; Write-Host $(" " * 3)
            <#r#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host "  " -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "}
            $s = {<#s 07#> Write-Host "  " -NoNewline; Write-Host $(" " * 4) -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#s#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host $(" " * 5)
            <#s#> Write-Host "  " -NoNewline; Write-Host "  " -NoNewline -BackgroundColor $FontColor; Write-Host $(" " * 3)
            <#s#> Write-Host $(" " * 4) -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#s#> Write-Host $(" " * 4) -BackgroundColor $FontColor -NoNewline; Write-Host "  " -NoNewline; Write-Host " "}
            $t = {<#t 07#> Write-Host $(" " * 6) -BackgroundColor $FontColor -NoNewline; Write-Host " " 
            <#t#> Write-Host "  " -NoNewline; Write-Host "  " -NoNewline -BackgroundColor $FontColor; Write-Host $(" " * 3)
            <#t#> Write-Host "  " -NoNewline; Write-Host "  " -NoNewline -BackgroundColor $FontColor; Write-Host $(" " * 3)
            <#t#> Write-Host "  " -NoNewline; Write-Host "  " -NoNewline -BackgroundColor $FontColor; Write-Host $(" " * 3) 
            <#t#> Write-Host "  " -NoNewline; Write-Host "  " -NoNewline -BackgroundColor $FontColor; Write-Host $(" " * 3)}
            $u = {<#u 07#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host "  " -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#u#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host "  " -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#u#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host "  " -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#u#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host "  " -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#u#> Write-Host $(" " * 6) -BackgroundColor $FontColor -NoNewline; Write-Host " "}
            $v = {<#v 11#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host $(" " * 6) -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#v#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host $(" " * 6) -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#v#> Write-Host " " -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host $(" " * 4) -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host "  "
            <#v#> Write-Host "  " -NoNewline; Write-Host "  " -NoNewline -BackgroundColor $FontColor; Write-Host "  " -NoNewline; Write-Host "  " -NoNewline -BackgroundColor $FontColor; Write-Host $(" " * 3)
            <#v#> Write-Host $(" " * 4) -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host $(" " * 5)}
            $w = {<#W 09#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host  $(" " * 4) -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#W#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host  $(" " * 4) -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#W#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " " -NoNewline ; Write-Host "  " -NoNewline -BackgroundColor $FontColor; Write-Host " " -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#W#> Write-Host $(" " * 3) -BackgroundColor $FontColor -NoNewline; Write-Host "  " -NoNewline; Write-Host $(" " * 3) -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#W#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host  $(" " * 4) -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "}
            $x = {<#x 09#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host $(" " * 4) -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#x#> Write-Host " " -NoNewline ; Write-Host "  " -NoNewline -BackgroundColor $FontColor; Write-Host "  " -NoNewline; Write-Host "  " -NoNewline -BackgroundColor $FontColor; Write-Host "  " 
            <#x#> Write-Host $(" " * 3) -NoNewline; Write-Host "  " -NoNewline -BackgroundColor $FontColor; Write-Host $(" " * 4) 
            <#x#> Write-Host " " -NoNewline ; Write-Host "  " -NoNewline -BackgroundColor $FontColor; Write-Host "  " -NoNewline; Write-Host "  " -NoNewline -BackgroundColor $FontColor; Write-Host "  " 
            <#x#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host $(" " * 4) -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "}
            $y = {<#y 11#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host $(" " * 4) -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#y#> Write-Host " " -NoNewline;  Write-Host "  " -NoNewline -BackgroundColor $FontColor; Write-Host "  " -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host "  "
            <#y#> Write-Host $(" " * 3) -NoNewline; Write-Host "  " -NoNewline -BackgroundColor $FontColor; Write-Host $(" " * 4) 
            <#y#> Write-Host $(" " * 3) -NoNewline; Write-Host "  " -NoNewline -BackgroundColor $FontColor; Write-Host $(" " * 4) 
            <#y#> Write-Host $(" " * 3) -NoNewline; Write-Host "  " -NoNewline -BackgroundColor $FontColor; Write-Host $(" " * 4)}
            $z = {<#z 07#> Write-Host $(" " * 6) -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#z#> Write-Host $(" " * 4) -NoNewline; Write-Host "  " -NoNewline -BackgroundColor $FontColor ; Write-Host " " 
            <#z#> Write-Host "  " -NoNewline; Write-Host "  " -NoNewline -BackgroundColor $FontColor; Write-Host $(" " * 3) 
            <#z#> Write-Host "  " -NoNewline -BackgroundColor $FontColor; Write-Host $(" " * 5)
            <#z#> Write-Host $(" " * 6) -BackgroundColor $FontColor -NoNewline; Write-Host " "}
            $hyphen = {<#- 05#> Write-Host $(" " * 5)
            <#-#> Write-Host $(" " * 5)
            <#-#> Write-Host $(" " * 4) -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#-#> Write-Host $(" " * 5)
            <#-#> Write-Host $(" " * 5)}
            $Hash = {<## 11#> Write-Host "  " -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host "  " -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host (" " * 3)
            <###> Write-Host $(" " * 10) -BackgroundColor $FontColor -NoNewline; Write-Host " " 
            <###> Write-Host "  " -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host "  " -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host (" " * 3)
            <###> Write-Host $(" " * 10) -BackgroundColor $FontColor -NoNewline; Write-Host " " 
            <###> Write-Host "  " -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host "  " -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host (" " * 3)}
            $AtRate = {<#@ 09#> Write-Host " " -NosNewline; Write-Host $(" " * 6) -BackgroundColor $FontColor -NoNewline; Write-Host "  "
            <#@#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host "  " -NoNewline; Write-Host (" " * 4) -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#@#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " " -NoNewline; Write-Host " " -BackgroundColor $FontColor -NoNewline; Write-Host "  " -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#@#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host "  " -NoNewline; Write-Host " " -BackgroundColor $FontColor -NoNewline; Write-Host " " -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#@#> Write-Host " " -NoNewline; Write-Host $(" " * 4) -BackgroundColor $FontColor -NoNewline; Write-Host " " -NoNewline;  Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "}
            $Exlaim = {<#! 03#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " " 
            <#!#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "  
            <#!#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " " 
            <#!#> Write-Host $(" " * 3)
            <#!#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "}
            $Dot = {<#. 03#> Write-Host $(" " * 3)
            <#.#> Write-Host $(" " * 3)  
            <#.#> Write-Host $(" " * 3) 
            <#.#> Write-Host $(" " * 3)
            <#.#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "}
            $Forward = {<#. 07#> Write-Host $(" " * 4) -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#/#> Write-Host $(" " * 3) -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host "  "
            <#/#> Write-Host "  " -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host $(" " * 3)
            <#/#> Write-Host $(" " * 1) -NoNewline ; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host $(" " * 4)
            <#/#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host $(" " * 5)}
            $Colun = {<#: 03#> Write-Host $(" " * 3)
            <#:#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " " 
            <#:#> Write-Host $(" " * 3)  
            <#:#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#:#> Write-Host $(" " * 3)}
            $Space = {<#  02#> Write-Host $(" " * 2)
            <# #> Write-Host $(" " * 2)
            <# #> Write-Host $(" " * 2)
            <# #> Write-Host $(" " * 2)
            <# #> Write-Host $(" " * 2)}
            $1 = {<#1 04#> Write-Host $(" " * 3) -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#1 #> Write-Host " " -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#1 #> Write-Host " " -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#1 #> Write-Host " " -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#1 #> Write-Host " " -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "}
            $2 = {<#2 06#> Write-Host $(" " * 5) -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#2#> Write-Host $(" " * 3) -NoNewline; Write-Host "  " -NoNewline -BackgroundColor $FontColor ; Write-Host " " 
            <#z#> Write-Host $(" " * 5) -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#z#> Write-Host "  " -NoNewline -BackgroundColor $FontColor; Write-Host $(" " * 4)
            <#z#> Write-Host $(" " * 5) -BackgroundColor $FontColor -NoNewline; Write-Host " "}
            $3 = {<#3 06#> Write-Host $(" " * 5) -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#3#> Write-Host $(" " * 3) -NoNewline;  Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " " 
            <#3#> Write-Host $(" " * 5) -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#3#> Write-Host $(" " * 3) -NoNewline;  Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " " 
            <#3#> Write-Host $(" " * 5) -BackgroundColor $FontColor -NoNewline; Write-Host " "}
            $4 = {<#4 06#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " " -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#4#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " " -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#4#> Write-Host $(" " * 5) -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#4#> Write-Host $(" " * 3) -NoNewline;  Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " " 
            <#4#> Write-Host $(" " * 3) -NoNewline;  Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "}
            $5 = {<#5 06#> Write-Host $(" " * 5) -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#s#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host $(" " * 4)
            <#s#> Write-Host $(" " * 5) -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#s#> Write-Host $(" " * 3) -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#s#> Write-Host $(" " * 5) -BackgroundColor $FontColor -NoNewline; Write-Host " "}
            $6 = {<#6 06#> Write-Host $(" " * 5) -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#6#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host $(" " * 4)
            <#6#> Write-Host $(" " * 5) -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#6#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " " -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#6#> Write-Host $(" " * 5) -BackgroundColor $FontColor -NoNewline; Write-Host " "}
            $7 = {<#7 06#> Write-Host $(" " * 5) -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#7#> Write-Host $(" " * 3) -NoNewline;  Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " " 
            <#7#> Write-Host $(" " * 3) -NoNewline;  Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " " 
            <#7#> Write-Host $(" " * 3) -NoNewline;  Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " " 
            <#7#> Write-Host $(" " * 3) -NoNewline;  Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " "}
            $8 = {<#8 06#> Write-Host $(" " * 5) -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#8#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " " -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " " 
            <#8#> Write-Host $(" " * 5) -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#8#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " " -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " " 
            <#8#> Write-Host $(" " * 5) -BackgroundColor $FontColor -NoNewline; Write-Host " "}
            $9 = {<#9 06#> Write-Host $(" " * 5) -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#9#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " " -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " " 
            <#9#> Write-Host $(" " * 5) -BackgroundColor $FontColor -NoNewline; Write-Host " "
            <#9#> Write-Host $(" " * 3) -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " " 
            <#9#> Write-Host $(" " * 5) -BackgroundColor $FontColor -NoNewline; Write-Host " "}
            $0 = {<#0 06#> Write-Host " " -NoNewline ;Write-Host $(" " * 3) -BackgroundColor $FontColor -NoNewline; Write-Host "  "
            <#0#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " " -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " " 
            <#0#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " " -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " " 
            <#0#> Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " " -NoNewline; Write-Host "  " -BackgroundColor $FontColor -NoNewline; Write-Host " " 
            <#0#> Write-Host " " -NoNewline; Write-Host $(" " * 3) -BackgroundColor $FontColor -NoNewline; Write-Host "  "}
        }#if
    }
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            'Inbuilt' {    
                [char[]]$AllCharacters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890'
                foreach ($singleChar in $AllCharacters) {
                    $CharScript = Get-Variable -Name $singleChar | Select-Object -ExpandProperty Value
                    $CharScript = ($CharScript -split "`r`n")
                    New-Variable -Name $singleChar -Value $CharScript -Force
                }
                $hyphen = $hyphen -split "`r`n"
                $Hash = $Hash -split "`r`n"
                $AtRate = $AtRate -split "`r`n"
                $Exlaim = $Exlaim -split "`r`n"
                $Dot = $Dot -split "`r`n"
                $Forward = $Forward -split "`r`n"
                $Colun = $Colun -split "`r`n"
                $Space = $Space -split "`r`n"
    
                $textlength = $text.Length 
                [char[]]$TextBreakDown = $text 
      
                $wordart = @() 
                $FindWidth  = @()
                $NonExistFont = @()
    
                for ($ind= 0; $ind -lt $FontHight; $ind++) { 
                    $Conf = 1 
                    foreach ($character in $TextBreakDown) { 
                        $NoFont = $True
                        Switch -regex ($character) {
                            '-' {
                                $charname =  Get-Variable -Name hyphen
                                break
                            } #-
                            '#' {
                                $charname =  Get-Variable -Name Hash
                                break
                            } ##
                            '@' {
                                $charname =  Get-Variable -Name AtRate
                                break
                            } #-
                            '!' {
                                $charname =  Get-Variable -Name Exlaim
                                break
                            } #!
                            '\.' {
                                $charname =  Get-Variable -Name Dot
                                break
                            } #.
                            ':' {
                                $charname =  Get-Variable -Name Colun
                                break
                            } #.
                            '/' {
                                $charname =  Get-Variable -Name Forward
                                break
                            } #.
                            '\s' {
                                $charname =  Get-Variable -Name space
                                break
                            } #.
                            "[A-Za-z_0-9]" {
                                $charname = Get-Variable -Name $character
                                break
                            } 
                            default {
                                $NoFont = $false
                                break
                            } #default
                        } #switch
                    
                        if ($NoFont -eq $True) {
                            if ($Conf -eq $textlength) { 
                                $info = $charname.value[$ind] 
                                $wordart += $info
                            } #if conf
                            else {
                                $info = $charname.value[$ind] 
                                $wordart += "{0} {1}" -f $info, '-NoNewLine'
                            } #else conf
                            $wordart += "`r`n"
                    
                            #Get First Line to calculate width
                            if ($ind -eq 0) {
                                $FindWidth += $charname.value[$ind]
                            } #if ind
                    
                            #Calculate font width
                            if ($ind -eq 0) {
                                $AllFirstLines = @()
                                $FindWidth = $FindWidth.trim() | Where-Object {$_ -ne ""}
                                $CharWidth = $FindWidth | foreach {$_.Substring(4,2)}
                                $BigFontWidth = $CharWidth | Measure-Object -Sum | Select-Object -ExpandProperty Sum
                            } #if ind
    
                        } #if NoFont
                        else {
                            $NonExistFont += $character
                        } #else NoFont
                        $Conf++
                    } #foreach character
                } #for
                $TempFilePath = [System.IO.Path]::GetTempPath()
                $TempFileName = "{0}{1}" -f $TempFilePath, 'Show-BigFontOnConsole.ps1'
                $wordart | foreach {$_.trim()} | Out-File $TempFileName
                & $TempFileName
                if ($NonExistFont -ne $null) {
                    $NonExistFont = $NonExistFont | Sort-Object | Get-Unique
                    $NonResult = $NonExistFont -join " "
                    Write-Host "`n`nSkipping as, No ascii fonts found for $NonResult" -BackgroundColor DarkRed
                } # if NonExistFont
            } #Inbuilt
            'Online' {
                if ($text -eq '# This is test !') {
                    $text = 'http://vcloud-lab.com'
                }
                $testEncode = [uri]::EscapeDataString($Text)
                $url = "http://artii.herokuapp.com/make?text=$testEncode&font=$FontName"
                Try {
                    $WebsiteApi = Invoke-WebRequest -Uri $url -ErrorAction Stop
                    Write-Host $WebsiteApi.Content -ForegroundColor $FontColor
                }
                catch {
                    $errMessage = "Check your internet connection, Verify below url in browser`n"
                    $errMessage += $url
                    Write-Host $errMessage -BackgroundColor DarkRed
                }
            } #Online
        } #switch pscmdlet
    }
    end {
    }
}

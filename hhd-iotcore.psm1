<#
.SYNOPSIS
.EXAMPLE
    hhdiotconnect -servername "minwinpc" -password "p@ssw0rd"
#>
function hhdiotconnect
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [System.String]
        $servername,

        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [System.String]
        $password
    )

    write "start winrm service ..."
    net start winrm

    write "add TrustedHosts ..."
    Set-Item WSMan:\localhost\Client\TrustedHosts -Value $servername

    $passwordEnc = ConvertTo-SecureString $password -AsPlainText -Force
    $cred = New-Object System.Management.Automation.PSCredential("$servername\administrator", $passwordEnc)

    write "enter pssession ..."
    Enter-PSSession -ComputerName $servername -Credential $cred
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhdiotconnectminwinpc
{
    [CmdletBinding()]
    param
    (
    )

    hhdiotconnect -servername "minwinpc" -password "p@ssw0rd"
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhdiotconnectfirstrp3
{
    [CmdletBinding()]
    param
    (
    )

    hhdiotconnect -servername "firstrp3" -password "p@ssw0rd"
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhdiotmountdrivefirstrp3
{
    [CmdletBinding()]
    param
    (
    )

    write "
`$servername = `"firstrp2`"
`$password = `"password`"
`$passwordEnc = ConvertTo-SecureString `$password -AsPlainText -Force
`$cred = New-Object System.Management.Automation.PSCredential(`"`$servername\administrator`", `$passwordEnc)
New-PSDrive -Name iot -PSProvider FileSystem -Root \\`$servername\c$ -Credential `$cred
    ";
}
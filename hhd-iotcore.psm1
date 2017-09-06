<#
.SYNOPSIS
.EXAMPLE
    hhd-iot-connect -servername "minwinpc" -password "p@ssw0rd"
#>
function hhd-iot-connect
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [System.String]
        $SERVER_NAME,

        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [System.String]
        $PASSWORD
    )

    write "start winrm service ..."
    net start winrm

    write "add TrustedHosts ..."
    Set-Item WSMan:\localhost\Client\TrustedHosts -Value $SERVER_NAME

    $passwordEnc = ConvertTo-SecureString $PASSWORD -AsPlainText -Force
    $cred = New-Object System.Management.Automation.PSCredential("$SERVER_NAME\administrator", $passwordEnc)

    write "enter pssession ..."
    Enter-PSSession -ComputerName $SERVER_NAME -Credential $cred
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-iot-connect-minwinpc
{
    [CmdletBinding()]
    param
    (
    )

    hhd-iot-connect -servername "minwinpc" -password "p@ssw0rd"
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-iot-connect-firstrp3
{
    [CmdletBinding()]
    param
    (
    )

    hhd-iot-connect -servername "firstrp3" -password "p@ssw0rd"
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-iot-mount-drive-firstrp3
{
    [CmdletBinding()]
    param
    (
    )

    write "
`$SERVER_NAME = `"firstrp2`"
`$PASSWORD = `"password`"
`$passwordEnc = ConvertTo-SecureString `$PASSWORD -AsPlainText -Force
`$cred = New-Object System.Management.Automation.PSCredential(`"`$SERVER_NAME\administrator`", `$passwordEnc)
New-PSDrive -Name iot -PSProvider FileSystem -Root \\`$SERVER_NAME\c$ -Credential `$cred
    ";
}
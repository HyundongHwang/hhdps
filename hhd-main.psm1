write "main start ..."
write "OutputEncoding = UTF8 ..."
$OutputEncoding = New-Object -TypeName System.Text.UTF8Encoding
    
write "Set-ExecutionPolicy Bypass ..."
Set-ExecutionPolicy Bypass -Scope Process -Force
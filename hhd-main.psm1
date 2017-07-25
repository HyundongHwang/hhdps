write "main start ..."
write "OutputEncoding = [System.Text.Encoding]::UTF8 ..."
$OutputEncoding = [System.Text.Encoding]::UTF8

# powershell_ise 에서 실행된다면 필요한 구문이다.
# write "[System.Console]::OutputEncoding = [Text.UTF8Encoding]::UTF8 ..."
# git status
# [System.Console]::OutputEncoding = [Text.UTF8Encoding]::UTF8

write "env:LC_ALL=C.UTF-8 ..."
$env:LC_ALL="C.UTF-8"

write "Set-ExecutionPolicy Bypass -Scope Process -Force ..."
Set-ExecutionPolicy Bypass -Scope Process -Force
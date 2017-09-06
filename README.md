<!-- TOC -->

- [hhdps](#hhdps)
    - [설치](#설치)
    - [모듈 & 함수 리스팅](#모듈--함수-리스팅)

<!-- /TOC -->

<br>
<br>
<br>

# hhdps

- 개인적인 윈도우 개발환경을 위한 파워쉘 모듈, 함수, 조각코드 모음
- 모든 함수들은 프롬프트에서 자동완성이 쉽게 되기 위해서 `hhd-{카테고리}-{액션}-{디테일}` 형식으로 구성되어 있다.

## 설치

```powershell
cd /
rm hhdps-master -Force -Recurse
rm tmp.zip
Invoke-WebRequest "https://github.com/HyundongHwang/hhdps/archive/master.zip" -OutFile tmp.zip
Expand-Archive tmp.zip -DestinationPath .
.\hhdps-master\hhd-install.ps1
rm tmp.zip
```


## 모듈 & 함수 리스팅

```powershell
PS C:\> gcm hhd-*

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Function        hhd-android-adb-file-copy-from-device              0.0        hhd-android
Function        hhd-android-adb-file-copy-to-device                0.0        hhd-android
Function        hhd-android-adb-logcat                             0.0        hhd-android
Function        hhd-android-adb-shell-dumpsys                      0.0        hhd-android
Function        hhd-android-adb-shell-ls-important                 0.0        hhd-android
Function        hhd-android-adb-start-app                          0.0        hhd-android
Function        hhd-android-download-apk-from-device               0.0        hhd-android
Function        hhd-android-gradle-assemble-debug                  0.0        hhd-android
Function        hhd-android-gradle-assemble-release                0.0        hhd-android
Function        hhd-android-gradle-clean                           0.0        hhd-android
Function        hhd-android-gradle-signing-report                  0.0        hhd-android
Function        hhd-android-gradle-version                         0.0        hhd-android
Function        hhd-android-install-apk                            0.0        hhd-android
Function        hhd-android-keytool-generate                       0.0        hhd-android
Function        hhd-android-keytool-show-from-keystore-file        0.0        hhd-android
Function        hhd-android-packages-show-in-device                0.0        hhd-android
Function        hhd-android-sdk-dir-ls                             0.0        hhd-android
Function        hhd-android-uninstall                              0.0        hhd-android
Function        hhd-azure-current                                  0.0        hhd-azure
Function        hhd-azure-get-website-log-hhdyidbot                0.0        hhd-azure
Function        hhd-azure-login                                    0.0        hhd-azure
Function        hhd-azure-login-auto                               0.0        hhd-azure
Function        hhd-azure-sql-database-detail                      0.0        hhd-azure
Function        hhd-azure-start-all-website                        0.0        hhd-azure
Function        hhd-azure-stop-all-website                         0.0        hhd-azure
Function        hhd-azure-storage-upload-file                      0.0        hhd-azure
Function        hhd-cd-add-path                                    0.0        hhd-cd
Function        hhd-cert-from-website                              0.0        hhd-etc
Function        hhd-dotnet-get-assembly-info                       0.0        hhd-etc
Function        hhd-file-append-time                               0.0        hhd-etc
Function        hhd-file-write-for-test                            0.0        hhd-etc
Function        hhd-gcm-get-script-content                         0.0        hhd-etc
Function        hhd-git-add-commit-push                            0.0        hhd-git
Function        hhd-git-colored-output                             0.0        hhd-git
Function        hhd-git-diff                                       0.0        hhd-git
Function        hhd-git-graph                                      0.0        hhd-git
Function        hhd-git-posh-init                                  0.0        hhd-git
Function        hhd-git-reset-clean                                0.0        hhd-git
Function        hhd-git-stash-apply                                0.0        hhd-git
Function        hhd-git-stash-save                                 0.0        hhd-git
Function        hhd-git-status                                     0.0        hhd-git
Function        hhd-html-download-images                           0.0        hhd-etc
Function        hhd-image-get-win10-spotlight-lock-screen          0.0        hhd-etc
Function        hhd-install-git                                    0.0        hhd-git
Function        hhd-iot-connect                                    0.0        hhd-iotcore
Function        hhd-iot-connect-firstrp3                           0.0        hhd-iotcore
Function        hhd-iot-connect-minwinpc                           0.0        hhd-iotcore
Function        hhd-iot-mount-drive-firstrp3                       0.0        hhd-iotcore
Function        hhd-kill                                           0.0        hhd-process
Function        hhd-kill-all-powershell-without-me                 0.0        hhd-process
Function        hhd-kill-vs-garbage                                0.0        hhd-process
Function        hhd-module-install-import                          0.0        hhd-module
Function        hhd-module-load-from-dll                           0.0        hhd-module
Function        hhd-network-get-ip-mac-address                     0.0        hhd-etc
Function        hhd-network-get-pub-ip                             0.0        hhd-etc
Function        hhd-network-netstat                                0.0        hhd-etc
Function        hhd-nuget-restore                                  0.0        hhd-module
Function        hhd-onedrive-upload                                0.0        hhd-onedrive
Function        hhd-path-set                                       0.0        hhd-etc
Function        hhd-ps                                             0.0        hhd-process
Function        hhd-storage-dir                                    0.0        hhd-etc
Function        hhd-storage-sub-dir                                0.0        hhd-etc
Function        hhd-vs2017-open-file                               0.0        hhd-visual-studio
Function        hhd-vs2017-open-hhdps                              0.0        hhd-visual-studio
Function        hhd-wmi-get-program                                0.0        hhd-etc
```
; DBUMMO MUSHclient Package Installer
;
; Thank you Fiendish of Aardwolf.
;
; Finally, an installer generator for the DBUMMO MUSHclient Package?
;
;--------------------------------
SetCompressor /SOLID /FINAL lzma
; We want to get version information at compile time. The docs say to
; make a second installer that can be "!system"ed to generate a
; text file with a "!define" in it and then "!include" that file.
; We can even compile that second installer here.
!makensis "get_version.nsi"

; Find version string and put it into PackageVersion variable.
!system "GetDBUMMOPackageVersion.exe"
!include "PackageVersion.txt"
!delfile "PackageVersion.txt"

; Show details while installing? options are hide|show|nevershow
ShowInstDetails show

; Name of the package
Name "DBUMMO MUSHclient ${PackageVersion}"

; File to write
OutFile "DBUMMO_MUSHclient_${PackageVersion}.exe"

; rtf or txt file - remember if it is txt, it must be in the DOS text format (\r\n)
LicenseData "hello.rtf"

; Default installation directory
InstallDir "$DESKTOP\MUSHclient\"

; Registry key to check for directory (so if you install again, it will
; overwrite the old one automatically)
InstallDirRegKey HKCU "Software\DBUMMOMUSHclient" "Install_Dir"

; Request application privileges?
;RequestExecutionLevel admin

; Text to prompt the user to enter a directory
DirText "This will install the DBUMMO MUSHclient Package ( ${PackageVersion} )."

Page license
Page directory
Page instfiles
;--------------------------------

; Installation section
Section "" ; No components page, name not important

; Set output path to the installation directory.
SetOutPath $INSTDIR

; Write the installation path into the registry
WriteRegStr HKCU "Software\DBUMMOMUSHclient" "Install_Dir" "$INSTDIR"

; Add most files always, e"x"cluding the listed ones.
SetOverwrite on
AllowSkipFiles off
File /r /x state /x mushclient_prefs.sqlite /x MUSHclient.ini /x .gitignore /x appveyor.yml MUSHclient\*
; removed this but will add it back in once I have the files created. /x Aardwolf.db /x Aardwolf.mcl
; Add the next files only if not already there.
; You could technically do this in one line after SetOverwrite off
; with Files /r MUSHclient\* again, but then the installer reports
; double the required space even though it's all just duplicates.
SetOverwrite off
;File MUSHclient\Aardwolf.db
File MUSHclient\mushclient_prefs.sqlite
File MUSHclient\MUSHclient.ini
SetOutPath $INSTDIR\worlds
;File MUSHclient\worlds\Aardwolf.mcl
SetOutPath $INSTDIR\worlds\plugins\state
File MUSHclient\worlds\plugins\state\*
SetOutPath $INSTDIR

SectionEnd ; Installation section

; Script, run at compile time by installer builder, to extract the latest version identifier from AardwolfPackageChanges.txt

; http://nsis.sourceforge.net/LineRead
Function LineRead
	!define LineRead `!insertmacro LineReadCall`
 
	!macro LineReadCall _FILE _NUMBER _RESULT
		Push `${_FILE}`
		Push `${_NUMBER}`
		Call LineRead
		Pop ${_RESULT}
	!macroend
 
	Exch $1
	Exch
	Exch $0
	Exch
	Push $2
	Push $3
	Push $4
	ClearErrors
 
	IfFileExists $0 0 error
	IntOp $1 $1 + 0
	IntCmp $1 0 error 0 plus
	StrCpy $4 0
	FileOpen $2 $0 r
	IfErrors error
	FileRead $2 $3
	IfErrors +3
	IntOp $4 $4 + 1
	Goto -3
	FileClose $2
	IntOp $1 $4 + $1
	IntOp $1 $1 + 1
	IntCmp $1 0 error error
 
	plus:
	FileOpen $2 $0 r
	IfErrors error
	StrCpy $3 0
	IntOp $3 $3 + 1
	FileRead $2 $0
	IfErrors +4
	StrCmp $3 $1 0 -3
	FileClose $2
	goto end
	FileClose $2
 
	error:
	SetErrors
	StrCpy $0 ''
 
	end:
	Pop $4
	Pop $3
	Pop $2
	Pop $1
	Exch $0
FunctionEnd

; http://nsis.sourceforge.net/StrRep with uninstaller parts removed
!define StrRep "!insertmacro StrRep"
!macro StrRep output string old new
    Push `${string}`
    Push `${old}`
    Push `${new}`
    Call StrRep
    Pop ${output}
!macroend
 
!macro Func_StrRep
    Function StrRep
        Exch $R2 ;new
        Exch 1
        Exch $R1 ;old
        Exch 2
        Exch $R0 ;string
        Push $R3
        Push $R4
        Push $R5
        Push $R6
        Push $R7
        Push $R8
        Push $R9
 
        StrCpy $R3 0
        StrLen $R4 $R1
        StrLen $R6 $R0
        StrLen $R9 $R2
        loop:
            StrCpy $R5 $R0 $R4 $R3
            StrCmp $R5 $R1 found
            StrCmp $R3 $R6 done
            IntOp $R3 $R3 + 1 ;move offset by 1 to check the next character
            Goto loop
        found:
            StrCpy $R5 $R0 $R3
            IntOp $R8 $R3 + $R4
            StrCpy $R7 $R0 "" $R8
            StrCpy $R0 $R5$R2$R7
            StrLen $R6 $R0
            IntOp $R3 $R3 + $R9 ;move offset by length of the replacement string
            Goto loop
        done:
 
        Pop $R9
        Pop $R8
        Pop $R7
        Pop $R6
        Pop $R5
        Pop $R4
        Pop $R3
        Push $R0
        Push $R1
        Pop $R0
        Pop $R1
        Pop $R0
        Pop $R2
        Exch $R1
    FunctionEnd
!macroend
!insertmacro Func_StrRep

OutFile "GetAardwolfPackageVersion.exe"
SilentInstall silent

Section

; Get file version
${LineRead} "MUSHclient\AardwolfPackageChanges.txt" "3" $R0

${StrRep} $R0 $R0 "$\r$\n" ""
${StrRep} $R0 $R0 " snapshot" ""

; http://nsis.sourceforge.net/Invoking_NSIS_run-time_commands_on_compile-time
FileOpen $R1 "$EXEDIR\PackageVersion.txt" w
FileWrite $R1 '!define PackageVersion "$R0"' ; Write it to a !define for use in main script
FileClose $R1

SectionEnd

#include-once
#include <WindowsConstants.au3>

#NoTrayIcon
;Opt("TrayAutoPause", 0)
;Opt("TrayMenuMode", 11)

Global Const $tempo_update = IniRead(@ScriptDir & "\config.ini", "update", "tempo_update_ms", "3600000") ; a cada 1 hora

AdlibRegister("verifica_update", $tempo_update)

;variavel USB monitor
Global Const $DBT_DEVICEARRIVAL         = 0x8000 ; A device or piece of media has been inserted and is now available.
Global Const $DBT_DEVICEQUERYREMOVE     = 0x8001 ; Permission is requested to remove a device or piece of media. Any application can deny this request and cancel the removal.
Global Const $DBT_DEVICEREMOVECOMPLETE  = 0x8004 ; A device or piece of media has been removed.

Dim $Drives
Dim $Drive_Type = "ALL"

GUICreate("")

;sobi as lib do windows

Global Const $RegisterStatus = GUIRegisterMsg($WM_DEVICECHANGE, "WindowProc")

UpdateDrives()

While 1
   $GuiMsg = GUIGetMsg()
WEnd

Func WindowProc(Const $hWnd, Const $msg, Const $wParam, Const $lParam)
    #forceref $hWnd, $msg

Switch $wParam
   Case $DBT_DEVICEARRIVAL ; if a user inserts the device
			$New = FindNewDrive()
			$Label = DriveGetLabel($New)
			LogFile($Label&"("&$New&") - Preparando para verifica")
					 if $New <> "" then run("verifica.exe "&$New)
			LogFile($Label&"("&$New&") - Verificação concluida")
			UpdateDrives()
			
   Case $DBT_DEVICEQUERYREMOVE ; if a user soft ejects the device			
			UpdateDrives()
   Case $DBT_DEVICEREMOVECOMPLETE ; if the user physically removes the device
			UpdateDrives()
			
EndSwitch

EndFunc   ;==>WindowProc

; This just jumps through the new Drive List, comparing them until it finds the entry that is in the new one that isn't in the old one
Func FindNewDrive()
$Temp = DriveGetDrive("ALL")
if $Temp <> "" then
   For $i = 1 to $Temp[0]
	  $Old = False
		 For $j = 1 to $DRIVES[0]
			If $DRIVES[$j] == $Temp[$i] Then $Old = True
			Next
   If $Old == False Then Return $Temp[$i]
   Next
Else
   Return ""
EndIf
EndFunc;==>FindNewDrive

; Just to keep things neat, and so if Variables Ever Change, this makes updating easier
Func UpdateDrives()
$Drives = DriveGetDrive( $Drive_Type )
EndFunc;==>UpdateDrives

Func verifica_update()
   Run("update.exe")
EndFunc

Func LogFile($log)
   DirCreate(@ScriptDir & "\logs")
   FileWriteLine(@ScriptDir & "\logs\"&@YEAR&@MON&@MDAY&".log", @HOUR & ":" & @MIN & ":" & @SEC & " -> " & $log)
EndFunc
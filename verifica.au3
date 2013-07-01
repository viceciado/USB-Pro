#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include-once
#include <SQLite.au3>
#include <SQLite.dll.au3>
#include <WindowsConstants.au3>

#include "md5.au3"

#NoTrayIcon

;Opt("TrayAutoPause", 0)
;Opt("TrayMenuMode", 11)

;variavel DB
Global $DB, $Base_dados = @ScriptDir&"\DataBase.db", $tab_virus = "Virus", $tab_ext = "ext", $tab_exp = "expressao"
Global $titulo = "USB proteção A v0.3.0.0 - verificando "&$cmdline[1]
Global Const $smart_ext = IniRead(@ScriptDir & "\config.ini", "scan", "ext", "exe|js|lnk|bat|ini")
Global Const $smart_max_bit = IniRead(@ScriptDir & "\config.ini", "scan", "max_bit", "1048576")

If ProcessExists(@ScriptName) Then
   ProcessSetPriority(@ScriptName, 4)
EndIf

varredura($cmdline[1])


Func varredura($sDrive)

			_SQLite_Startup()
			$DB=_SQLite_Open($Base_dados)
			
			Global $quant_arq = DirGetSize($sDrive,1), $arq_atual = 0

			
		 Select

			case DriveGetType ($sDrive) = "FIXED"
			   if  DriveStatus($sDrive) <> "NOTREADY" Then
				  $t = MsgBox (4, "Aviso" ,"Você adicionol uma unidade de grande porte," & @LF & "a verificação pode demorar!" & @LF & "Deseja verifica-la mesmo assim?")
					 If $t = 6 Then
						ProgressOn($titulo, "Verificando", "")
						Scanear($sDrive)
					 EndIf
			   EndIf
				
			 case DriveGetType ($sDrive) = "REMOVABLE"
			   if  DriveStatus($sDrive) <> "NOTREADY" Then
				  ProgressOn($titulo, "Verificando", "")
				  Scanear($sDrive)
			   EndIf
				  
			case DriveGetType ($sDrive) = "NETWORK"
			   MsgBox(0,"Aviso","O sitema não ira verificar unidade de REDE!")
				  
			case DriveGetType ($sDrive) = "CDROM"
			   MsgBox(0,"Aviso","O sitema não pode verificar unidade otica!")
			
			case else
			   MsgBox(0,"Aviso","O sitema não pode identificar o tipo de unidade!")
			   
		 EndSelect

			   _SQLite_Shutdown()
endfunc


Func Scanear($SourceFolder)
    local $szDrive, $szDir, $szFName, $szExt
	Local $Search, $File, $FileAttributes, $FullFilePath
	
	$Search = FileFindFirstFile($SourceFolder & "\*.*")
	
	While 1
		 
		 $porcento = Round($arq_atual * 100 / $quant_arq[1])
		 If $Search = -1 Then
			ExitLoop
		 EndIf
			$File = FileFindNextFile($Search)
				If @error Then ExitLoop
			$FullFilePath = $SourceFolder & "\" & $File
		If StringInStr(FileGetAttrib($FullFilePath),"D") Then
			If StringInStr(FileGetAttrib($FullFilePath),"H") Then
			   FileSetAttrib($FullFilePath, "-HRS")
			   LogFile("Pasta oculta: "&$FullFilePath&" - DESOCULTADA")
			   Beep(1000, 100)
			EndIf
			Scanear($FullFilePath)
			
		 Else
			$arq_atual += 1
			ProgressSet($porcento, $File, "Verificando "&$porcento&"%")
			_base_virus($FullFilePath)
		EndIf
	WEnd
	FileClose($Search)
 EndFunc
 
 
 Func _base_virus($arquivo)
	
	$ext = pega_ext($arquivo)
	
	if StringInStr($smart_ext, $ext) AND FileGetSize($arquivo) < $smart_max_bit Then
	   
	  $arq_md5 = md51($arquivo)
	  Local $Data, $aRow, $sMsg
	
	  _SQLite_QuerySingleRow($DB,"SELECT * FROM "&$tab_virus&" WHERE MD5='"&$arq_md5&"'",$Data)
	  If $Data[0] <> "" Then
				  $nome_app = pega_app($arquivo)
				  if ProcessExists($nome_app) Then
					 ProcessClose($nome_app)
				  EndIf
			   FileSetAttrib($arquivo,"-HRS")
			   FileDelete($arquivo)
			   LogFile("Infecção: "&$Data[1]&" - "&$arquivo&" - DELETADA")
	  EndIf
   
	  _SQLite_QuerySingleRow($DB,"SELECT * FROM "&$tab_ext&" WHERE ext='"&$ext&"'",$Data)
	  If $Data[0] <> "" Then
			   FileSetAttrib($arquivo,"-HRS")
			   FileDelete($arquivo)
			   Beep(1000, 200)
			   LogFile("Extenção suspeita: "&$Data[0]&" - "&$arquivo&" - DELETADA")
	  EndIf

	  _SQLite_Query($DB, "SELECT * FROM "&$tab_exp&" WHERE ext='"&$ext&"'", $Data)
	  While _SQLite_FetchData($Data, $aRow) = $SQLITE_OK
		 verif_exp_arq($arquivo, $aRow[2], $aRow[3])
	  WEnd

   EndIf

EndFunc
 

Func pega_ext($arq)
    $sExt = StringSplit($arq, '.' )
	Return $sExt[$sExt[0]]
EndFunc
 
Func pega_app($arq)
    $sExt = StringSplit($arq, '\' )
	Return $sExt[$sExt[0]]
EndFunc
 
Func MD51($Filename)
Global $BufferSize = 0x25000

Global $FileHandle = FileOpen($Filename, 16)

$MD5CTX = _MD5Init()
For $i = 1 To Ceiling(FileGetSize($Filename) / $BufferSize)
	_MD5Input($MD5CTX, FileRead($FileHandle, $BufferSize))
Next

   $Hash = _MD5Result($MD5CTX)
   FileClose($FileHandle)
   
$Hash = StringRight($Hash,32)

Return $Hash
EndFunc

Func verif_exp_arq($file,$exp,$n_virus)
	$line = _FileCountLines($file)
	While $line >= 1
		$datei = FileReadLine($file, $line)
			
		 $array = StringRegExp($datei, $exp, 2)

			if (UBound($array) - 1) > 0 Then
			   ProgressOff()
			   $t = MsgBox (4, "Arquivo Suspeito" ,"De acordo com as expressões analizadas nesses arquivo" & @LF & "ha uma grande probabilidade de ser um virus." & @LF & "Deseja excluir-los?" & @LF & @LF & $file)
			   If $t = 6 Then
				  FileSetAttrib($file,"-HRS")
				  FileDelete($file)
				  Beep(1000, 200)
				  LogFile("Arquivo suspeito: "&$file&" - "&$n_virus&" - DELETADA - OPÇÃO DO USUARIO")
			   ElseIf $t = 7 Then
				  LogFile("Arquivo suspeito: "&$file&" - "&$n_virus&" - NÃO DELETADO - OPÇÃO DO USUARIO")
			   EndIf
			   ProgressOn($titulo, "Verificando", "")
			   ExitLoop
			EndIf
		$line -= 1
	WEnd
 EndFunc

Func LogFile($log)
   DirCreate(@ScriptDir & "\logs")
   FileWriteLine(@ScriptDir & "\logs\"&@YEAR&@MON&@MDAY&".log", @HOUR & ":" & @MIN & ":" & @SEC & " -> " & $log)
EndFunc
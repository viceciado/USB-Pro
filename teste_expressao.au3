#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

;Local $result = StringInStr("I am a String", "RING")
;MsgBox(0, "Search result:", $result)
#include <File.au3>

;Scanear(@ScriptDir & "\virus")
;busca_arq(@ScriptDir & "\MD5.au3","MD5Init|Dll")
busca_arq2(@ScriptDir & "\virus\novos\ie9e9e.js.txt")

Func Scanear($SourceFolder)
    local $szDrive, $szDir, $szFName, $szExt
	Local $Search, $File, $FileAttributes, $FullFilePath
	
	$Search = FileFindFirstFile($SourceFolder & "\*.*")
	
	While 1
		 
		 If $Search = -1 Then
			ExitLoop
		 EndIf
			$File = FileFindNextFile($Search)
				If @error Then ExitLoop
			$FullFilePath = $SourceFolder & "\" & $File
		If StringInStr(FileGetAttrib($FullFilePath),"D") Then
			Scanear($FullFilePath)
		 Else
			if FileGetSize($FullFilePath) < 1048576 Then verif_exp_arq ($FullFilePath)
		EndIf
	WEnd
	FileClose($Search)
 EndFunc



Func busca_arq($file,$espresao)
	$line = _FileCountLines($file)
	While $line >= 1
		$datei = FileReadLine($file, $line)
			   
			   Local $arr = StringSplit($espresao, "|") 
				  If IsArray($arr) Then
					 $iMax = (UBound($arr)-1); get array size
					 While $iMax >= 1
						   Local $result = StringInStr($datei, $arr[$iMax])
						   if $result > 0 Then ConsoleWrite("Arquivo:" &$file& @LF & "Linha " & $line & @LF &" caluna:" & $result & @LF)
						   Sleep(500)
						   $iMax -= 1
					 WEnd
				  EndIf
			
		$line -= 1
	WEnd
 EndFunc
 
 Func busca_arq2($file)
	$line = _FileCountLines($file)
	While $line >= 1
		$datei = FileReadLine($file, $line)
			
		 $array = StringRegExp($datei, '(.*?)=function(.*?){return .*?.pop(.*?)}|try{(.*?)=".*?".split(.*?)', 2)
		 
									   
		 ;'(.*?)=function(.*?){return .*?.split(.*?)}'
		;'(.*?)=function(){return .*?.pop()},(.*?)="",(.*?)="",(.*?)=}'

		 
		 For $i = 0 To UBound($array) - 1
			if (UBound($array) - 1) > 0 Then
			   MsgBox(0, "Virus", $file& " - " &$array[$i])
			Else
			   MsgBox(0, "Não e virus", $file & " - " & $array[$i])
			EndIf
		 Next
		 
		$line -= 1
	WEnd
 EndFunc
		 
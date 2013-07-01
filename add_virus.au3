#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
;variavel DB
#include-once
#include <SQLite.au3>
#include <SQLite.dll.au3>
#include <WindowsConstants.au3>

#include "md5.au3"


Global $DB, $Base_dados = @ScriptDir&"\DataBase.db", $tab_virus = "Virus"

add_md5()

Func add_md5()
   $message = "Selecione o virus para ser armazenado no DB."
   $viros_nome = InputBox("Nome do virus", "Coloque um nome ou sitoma do virus")
	$md5_add = InputBox("MD5 do virus", "colouqe o MD5 correspondente ao virus")
	  if @Error = 0 And $md5_add<>"" And $viros_nome<>"" And StringLen($md5_add)<>32 Then
		 _SQLite_Startup()
		 $DB=_SQLite_Open($Base_dados)
		 _DataAddEx($md5_add,$viros_nome)
		 _SQLite_Shutdown()
	  EndIf
EndFunc
   
Func add_md5_file()
   $viros_nome = InputBox("Nome do virus", "Coloque um nome ou sitoma do virus")
		 if @Error = 0 And StringLen($viros_nome)>4 Then
			$message = "Selecione o virus para ser armazenado no DB."
			$arquivo_add = FileOpenDialog($message, "", "Virus (*.*)", 1)

			_SQLite_Startup()
			$DB=_SQLite_Open($Base_dados)
		 if FileExists($arquivo_add) Then _DataAddEx(MD51($arquivo_add),$viros_nome)
			_SQLite_Shutdown()
		 EndIf   
EndFunc


Func _DataAddEx($MD5,$Nome="Virus")
	
	Local $Data
    
	_SQLite_QuerySingleRow($DB,"SELECT * FROM "&$tab_virus&" WHERE MD5='"&$MD5&"'",$Data)
    
	If $Data[0] <> "" Then
        ;console("MD5: "&$Data[0]&" já cadastrado")
		MsgBox(3,"Atenção", $Data[0]&" já cadastrado")
    Else
        _SQLite_Exec($DB,"INSERT INTO "&$tab_virus&" (MD5,Nome) VALUES ('"&$MD5&"','"&$Nome&"');")
		MsgBox(3,"Atenção", $MD5&" cadastrado com sucesso!!!")
    EndIf
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
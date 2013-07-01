#include <GUIConstants.au3>
#include <Array.au3>

;add função md5
#include "md5.au3"

Opt("TrayAutoPause", 0)
Opt("TrayMenuMode", 11)

Global Const $win_title = IniRead(@ScriptDir & "\config.ini", "patch", "Nome_app", "USB-proteção")
Global Const $url = IniRead(@ScriptDir & "\config.ini", "patch", "url", "http://www.masternetinformatica.com.br/usb_pro/")

If WinExists($win_title) Then Exit
   
   $connect = _GetNetworkConnect()

If $connect Then
   
   ProgressOn("Metin2 Master", "Procurando Atualização", "Aguarde...")
   get_hash_list()
   
Else
   
   Rodar()

EndIf

;funcão retorna MD5
func file_hash($Filename)
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

;Ddownlooad de lista de md5 dos arquivos
Func get_hash_list()
	  InetGet($url & "/index.php" , "image.jpg", 1,0 );downloads file & md5 sum in to image.jpg to avoid extra client atention on file. For now this is seciurity isue.
	  if @error then
		 Rodar()
	  EndIf
	  sort_hash_list()
EndFunc


;Compares client side files with recieved data
Func sort_hash_list()

$data = get_file_text("image.jpg");open downloadaded seciurity info
FileDelete("image.jpg")

$file_arr = StringSplit($data, "|")

For $a = 1 to $file_arr[0]-1 Step 1
$original_file = StringSplit($file_arr[$a], ":")
$system_hash = file_hash($original_file[1]); check files in "loader.exe_root/system" change for your dir. If you whant to chek file in main dir where is loader then revome 'system/'&

if $original_file[2] <> $system_hash Then
if ProcessExists($original_file[1]) then ProcessClose($original_file[1])
FileDelete($original_file[1])
$size = InetGetSize($url & "/" & $original_file[1]);location whre is you original required client files. Same loc as you seted in file_list.php
$hDownload = InetGet($url & "/" & $original_file[1], @ScriptDir & "/" & $original_file[1], 1, 1); from whre to take Original required client files and whre to save them
   Do
	  $Byteatual 	= InetGetInfo($hDownload, 0)
	  $Arq_port    = Floor(($Byteatual / $size) * 100)
	  ;ProgressSet($Arq_port, "Atulizando : "&$original_file[1] & " Aguarde... ")
	  Sleep(100)
   Until InetGetInfo($hDownload, 2)

InetClose($hDownload)

EndIf
Next
   
   Rodar()

EndFunc


Func get_file_text($file_name)
$file = FileOpen($file_name, 0)
; Check if file opened for reading OK
If $file = -1 Then
    MsgBox(0, "Erro", "Não foi possivel abri o arquivo.")
    Exit
EndIf
$chars = FileRead($file)
FileClose($file)
FileDelete($file)
return $chars
EndFunc


Func _GetNetworkConnect()
    Local Const $NETWORK_ALIVE_LAN = 0x1  ;net card connection
    Local Const $NETWORK_ALIVE_WAN = 0x2  ;RAS (internet) connection
    Local Const $NETWORK_ALIVE_AOL = 0x4  ;AOL
    
    Local $aRet, $iResult
    
    $aRet = DllCall("sensapi.dll", "int", "IsNetworkAlive", "int*", 0)
    
    If BitAND($aRet[1], $NETWORK_ALIVE_LAN) Then $iResult &= "LAN connected" & @LF
    If BitAND($aRet[1], $NETWORK_ALIVE_WAN) Then $iResult &= "WAN connected" & @LF
    If BitAND($aRet[1], $NETWORK_ALIVE_AOL) Then $iResult &= "AOL connected" & @LF
    
    Return $iResult
 EndFunc
 
Func Rodar()
   if ProcessExists("USB-pro.exe") then ProcessClose("USB-pro.exe")
   Run("USB-pro.exe")
   Exit
EndFunc
#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         Instalador USB-pro

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------
#RequireAdmin
#NoTrayIcon

$t = MsgBox (4, "Remoção USB proteção" ,"Deseja remover o USB proteção?")

If $t = 6 Then

   If ProcessExists("USB-pro.exe") Then
	  ProcessClose("USB-pro.exe")
   EndIf
   
   If ProcessExists("verifica.exe") Then
	  ProcessClose("verifica.exe")
   EndIf
   
   If ProcessExists("update.exe") Then
	  ProcessClose("update.exe")
   EndIf
     
   SplashTextOn ("Remoção USB proteção", "Removendo USB proteção", 250, 100,-1,-1,-1,-1,14,600)
   
   RegDelete("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", "USB-pro")
   if @error Then MsgBox(0, "Erro", "Ouve um problema na remoção! Tente novamente. cod 1")
	  
   RegDelete("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\USB-pro")
   if @error Then MsgBox(0, "Erro", "Ouve um problema na remoção! Tente novamente. cod 2")
	  
   FileDelete(@AppDataCommonDir & "\USB-pro\USB-pro.exe")
   FileDelete(@AppDataCommonDir & "\USB-pro\verifica.exe")
   FileDelete(@AppDataCommonDir & "\USB-pro\update.exe")
   FileDelete(@AppDataCommonDir & "\USB-pro\DataBase.db")
   FileDelete(@AppDataCommonDir & "\USB-pro\sqlite3.dll")
   
   SplashTextOn ("Remoção USB proteção", "Remoção concluida.", 250, 100,-1,-1,-1,-1,14,600)
   
   Run(@SystemDir & '\cmd.exe /C del /F /Q "' & @AppDataCommonDir & '"\USB-pro\desinstalador.exe && rmdir /S /Q "' & @AppDataCommonDir & '\USB-pro"', @TempDir, @SW_HIDE)
   
   Exit 0
   

ElseIf $t = 7 Then
    SplashTextOn ("", "Operação canselada", 250, 100,-1,-1, -1,-1,14,600)
    Sleep (2000)
EndIf

;Run("Explorer.exe " & @AppDataCommonDir)
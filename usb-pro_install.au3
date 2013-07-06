#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         Instalador USB-pro
Edição: Eduardo Viana :)

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------
#RequireAdmin
#NoTrayIcon


If ProcessExists(@ScriptName) Then
	  ProcessSetPriority(@ScriptName, 4)
EndIf

$t = MsgBox (4, "USB prote��o" ,"Deseja instalar o USB prote��o?")

If $t = 6 Then

   If ProcessExists("USB-pro.exe") Then
	  ProcessClose("USB-pro.exe")
   EndIf
   
   SplashTextOn ("Instala��o USB prote��o", "Instalado USB prote��o", 250, 100,-1,-1,-1,-1,14,600)

   FileInstall("update.exe", @TempDir & "\update.exe", 1)
   FileInstall("USB-pro.exe", @TempDir & "\USB-pro.exe", 1)
   FileInstall("verifica.exe", @TempDir & "\verifica.exe", 1)
   FileInstall("DataBase.db", @TempDir & "\DataBase.db", 1)
   FileInstall("sqlite3.dll", @TempDir & "\sqlite3.dll", 1)
   FileInstall("desinstalar.exe", @TempDir & "\desinstalar.exe", 1)

   FileMove(@TempDir & "\update.exe", @AppDataCommonDir & "\USB-pro\", 9)
   FileMove(@TempDir & "\USB-pro.exe", @AppDataCommonDir & "\USB-pro\", 9)
   FileMove(@TempDir & "\verifica.exe", @AppDataCommonDir & "\USB-pro\", 9)
   FileMove(@TempDir & "\DataBase.db", @AppDataCommonDir & "\USB-pro\", 9)
   FileMove(@TempDir & "\sqlite3.dll", @AppDataCommonDir & "\USB-pro\", 9)
   FileMove(@TempDir & "\desinstalar.exe", @AppDataCommonDir & "\USB-pro\", 9)
   
   RegWrite("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\USB-pro")
   RegWrite('HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\USB-pro', 'DisplayIcon', "REG_SZ",  @AppDataCommonDir & '\USB-pro\USB-pro.exe,0')
   RegWrite('HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\USB-pro', 'DisplayName', "REG_SZ", 'USB-pro')
   RegWrite('HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\USB-pro', 'NoModify', "REG_DWORD", '1')
   RegWrite('HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\USB-pro', 'NoRepair', "REG_DWORD", '1')
   RegWrite('HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\USB-pro', 'Publisher', "REG_SZ", 'Maxuel Aguiar')
   RegWrite('HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\USB-pro', 'UninstallString', "REG_SZ", '"' & @AppDataCommonDir & '\USB-pro\desinstalar.exe"')

   RegWrite('HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run', 'USB-pro', "REG_SZ", '"' & @AppDataCommonDir & '\USB-pro\USB-pro.exe"')
   if @error Then MsgBox(0, "Erro", "Ouve um problema na instala��o! Tente novamente")
	  
   SplashTextOn ("Instala��o USB prote��o", "A instalação foi finalizada com sucesso no PC: " & @computername , 250, 100,-1,-1,-1,-1,14,600)
   
   Run(@AppDataCommonDir & "\USB-pro\update.exe")
   
   Exit

ElseIf $t = 7 Then
    SplashTextOn ("USB proteção", "Instalação Cancelada", 250, 100,-1,-1,-1,-1,14,600)
    Sleep (2000)
EndIf

;Run("Explorer.exe " & @AppDataCommonDir)

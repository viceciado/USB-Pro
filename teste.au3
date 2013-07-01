#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

ProgressOn("Progress Bar", "Sample progress bar", "Working...")
 
 For $i = 0 To 100
 	ProgressSet($i)
 	Sleep(5)
 Next
 
 ProgressSet(100, "Done!")
 Sleep(750)
 ProgressOff()
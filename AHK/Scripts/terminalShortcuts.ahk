; Enables Linux terminal shortcuts on Windows command prompt

; Open cmd by Ctrl (Left) + Alt (Left) + T
>^>!t::
	Run cmd, %HOMEDRIVE%%HOMEPATH%
	return

#IfWinActive, ahk_class ConsoleWindowClass

; Delete entire words with Ctrl + W
^w::
	Send ^{Backspace}
	return

; Close command prompt with Ctrl + Shift + W
^+w::
	WinClose
	return

#If


; IN CASE YOU FORGOT: Shift + Right Click on any folder can bring up an option to open a command prompt/powershell there.

; https://www.autohotkey.com/boards/viewtopic.php?t=72228
; https://stackoverflow.com/questions/9228950/what-is-the-alternative-for-users-home-directory-on-windows-command-prompt

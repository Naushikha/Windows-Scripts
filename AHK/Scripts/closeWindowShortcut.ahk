; Close some stubborn applications that don't conform to the standard Ctrl + W

SetTitleMatchMode, 2
#IfWinActive, ahk_exe Teams.exe
^w::WinClose
#If

; Windows Mail
#IfWinActive, ahk_exe ApplicationFrameHost.exe
^w::WinClose
#If


; https://superuser.com/questions/250435/how-can-i-change-the-default-shortcut-in-windows-for-closing-programs
; https://www.autohotkey.com/board/topic/118350-how-to-enable-auto-hotkey-in-certain-program-only/

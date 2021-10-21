; Maps Linux desktop switching shortcuts into Windows Win + Ctrl + ArrowKeys


^!Right::SendInput ^#{Right}

^!Left::SendInput ^#{Left}

^!+Right::
	WinGetTitle, Title, A
	WinSet, ExStyle, ^0x80, %Title%
	sleep, 300
	Send #^{Right}
	sleep, 300
	WinSet, ExStyle, ^0x80, %Title%
	WinActivate, %Title%
	return

^!+Left::
	WinGetTitle, Title, A
	WinSet, ExStyle, ^0x80, %Title%
	sleep, 300
	Send #^{Left}
	sleep, 300
	WinSet, ExStyle, ^0x80, %Title%
	WinActivate, %Title%
	return


; https://superuser.com/questions/951355/autohotkey-custom-shortcut-to-switch-to-next-previous-desktop-in-windows-10
; https://superuser.com/questions/950452/how-to-quickly-move-current-window-to-another-task-view-desktop-in-windows-10
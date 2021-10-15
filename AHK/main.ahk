; MASTER SCRIPT FILE, LOADS ALL MY SCRIPTS
; Add a shortcut to this file into %APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup

; Hide Windows show desktop button in taskbar
#Include Scripts\hideShowDesktopButton.ahk

; Close window shortcut (Ctrl+W) for some unsupported applications
#Include Scripts\closeWindowShortcut.ahk

; Fix for Ctrl+Backspace in File Explorer, Notepad etc.
#Include Scripts\fixCtrlBackspace.ahk

; Use Linux terminal shortcuts in Windows
#Include Scripts\terminalShortcuts.ahk

; Switch desktops easily like in Linux using Ctrl + Alt + > / <
#Include Scripts\switchDesktops.ahk

repoList := Object()
selectedList := Array()
savedCommands := ""

FileRead, projectDirectory, %A_WorkingDir%\data\projectDirectory.txt

Loop, Read, %A_WorkingDir%\data\repoList.txt
{
	repoList[A_Index] := StrSplit(A_LoopReadLine,",")
}

Loop, Read, %A_WorkingDir%\data\savedCommands.txt
{
	savedCommands .= A_LoopReadLine "|"
}

Gui, Add, ListView, AltSubmit Checked r10 w600 NoSort gListViewChecks, [=]|Repository|Location
for index, element in repoList
{
	LV_Add(Check, , element[1], element[2])
	selectedList.Push(1)
}
LV_ModifyCol()
LV_Modify(0, "Check")
toggleStatus := 1

Gui, Add, Button, default xm gToggleSelection, Toggle Selection
Gui, Add, Text,, Command:
Gui, Font, bold s11, Arial
Gui, Add, ComboBox, w600 Choose1 vCommand gCbAutoComplete, %savedCommands%
Gui, Font,
Gui, Add, Text, ym, `nProject Location: `n`n%projectDirectory%`n
Gui, Add, Button, default gRunCommand, `n` ` ` Run Command` ` ` `n`n
Gui, Add, Checkbox, Checked vSoundEnabled, Enable SFX
Gui, Add, Checkbox, y+105 vNeedLogin, Require SSH login

Gui, Show,, Git Repository Manager
Return

GuiClose:
ExitApp

ListViewChecks:
	If (A_GuiEvent == "I")
	If (ErrorLevel == "C"){
		selectedList[A_EventInfo] := 1
	}
	Else If (ErrorLevel == "c"){
		selectedList[A_EventInfo] := 0
	}
	If (A_GuiEvent = "DoubleClick") ; Feature to double click on a repo to git bash to it
	{
		If (A_EventInfo == 1) ; First repo is the main repo, handle it differently
		{
			Run, "C:\Program Files\Git\git-bash.exe" "--cd=%projectDirectory%"
		}
		Else
		{
			selectedRepo := repoList[A_EventInfo][2]
			Run, "C:\Program Files\Git\git-bash.exe" "--cd=%projectDirectory%\%selectedRepo%"
		}
	}
Return

RunCommand:
Gui, Submit
	RepoNameList := ""
	for index, element in selectedList
	{
		If (element == 1)
		{
			RepoNameList .=repoList[index][1] . ", "
		}
	}
	MsgBox, 52,, EXECUTING COMMAND`, `n`n%Command%` `n`nON SELECTED REPOS`, `n`n%RepoNameList% `n`nCONTINUE ?
	IfMsgBox Yes
	{
		RepoLocationList := ""
		for index, element in selectedList
		{
			If (element == 1)
			{
				RepoLocationList.=repoList[index][2] . " "
			}
		}
		Run, "C:\Program Files\Git\git-bash.exe" "data\gitBashMagic.sh" "%projectDirectory%" "%Command%" "%RepoLocationList%" "%NeedLogin%" "%SoundEnabled%"
	}
	Gui, Show
Return

ToggleSelection:
	If (toggleStatus == 1)
	{
		LV_Modify(0, "-Check")
		toggleStatus := 0
	}
	Else If (toggleStatus == 0)
	{
		LV_Modify(0, "Check")
		toggleStatus := 1
	}
	for index, element in selectedList
	{
		selectedList[index] := toggleStatus
	}
Return

/*
	https://www.autohotkey.com/boards/viewtopic.php?f=76&t=78304
	=======================================================================================
	 Function:			CbAutoComplete
	 Description:		Auto-completes typed values in a ComboBox.

	 Author:			Pulover [Rodolfo U. Batista]
	 Usage:
		Gui, Add, ComboBox, w200 h50 gCbAutoComplete, Billy|Joel|Samual|Jim|Max|Jackson|George
	=======================================================================================
*/
CbAutoComplete() {
	; CB_GETEDITSEL = 0x0140, CB_SETEDITSEL = 0x0142
	If ((GetKeyState("Delete", "P")) || (GetKeyState("Backspace", "P")))
		Return
	GuiControlGet, lHwnd, Hwnd, %A_GuiControl%
	SendMessage, 0x0140, 0, 0,, ahk_id %lHwnd%
	MakeShort(ErrorLevel, Start, End)
	GuiControlGet, CurContent,, %lHwnd%
	GuiControl, ChooseString, %A_GuiControl%, %CurContent%
	If (ErrorLevel) {
		ControlSetText,, %CurContent%, ahk_id %lHwnd%
		PostMessage, 0x0142, 0, MakeLong(Start, End),, ahk_id %lHwnd%
		Return
	}
	GuiControlGet, CurContent,, %lHwnd%
	PostMessage, 0x0142, 0, MakeLong(Start, StrLen(CurContent)),, ahk_id %lHwnd%
}

; Required for: CbAutoComplete()
MakeLong(LoWord, HiWord) {
	Return, (HiWord << 16) | (LoWord & 0xffff)
}

; Required for: CbAutoComplete()
MakeShort(Long, ByRef LoWord, ByRef HiWord) {
	LoWord := Long & 0xffff, HiWord := Long >> 16
}

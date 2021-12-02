repoList := Object()
selectedList := Array()
savedCommands := ""
savedSelections := ""

FileRead, projectDirectory, data\projectDirectory.txt

Loop, Read, data\repoList.txt
{
	repoList[A_Index] := StrSplit(A_LoopReadLine,",")
}

Loop, Read, data\savedCommands.txt
{
	savedCommands .= A_LoopReadLine "|"
}

Loop Files, data\selections\*.*
{
	global savedSelections .= A_LoopFileName "|"
}	

Gui, Add, ListView, AltSubmit Checked r10 w600 NoSort gListViewChecks, [=]|Repository|Location
for index, element in repoList
{
	LV_Add(Check, , element[1], element[2])
	selectedList.Push(1)
}
LV_ModifyCol() ; Auto adjust column widths
LV_Modify(0, "Check") ; Check all rows by default
toggleStatus := 1

Gui, Add, Button, xm gToggleSelection, Toggle Selection
Gui, Add, Button, yp x+5 gSelectSave, Save Selection
Gui, Add, Text, y+5 x+-180, Command:
Gui, Font, bold s11, Arial
Gui, Add, ComboBox, w600 Choose1 vCommand gCbAutoComplete, %savedCommands%
Gui, Font,
Gui, Add, Text, ym, `nProject Location: `n`n%projectDirectory%`n
Gui, Add, Button, default gRunCommand, `n` ` ` Run Command` ` ` `n`n
Gui, Add, Checkbox, Checked vSoundEnabled, Enable SFX
Gui, Add, Text, y+18, Saved Selections:
Gui, Add, ComboBox, w100 vSelection gGetSelection, %savedSelections%
Gui, Add, Button, gSelectDelete, ` ` Delete Selection` ` 
Gui, Add, Checkbox, y+20 x+-100 vNeedLogin, Require SSH login

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
		Process, Close, conhost.exe ; Remove any residual conhosts lying around in the RAM (~6MB!)
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

SelectSave:
	Gui, Submit, NoHide
	SelectedRepos := ""
	for index, element in selectedList
	{
		If (element == 1)
		{
			SelectedRepos .= index . " "
		}
	}
	InputBox, FileName, Repo Selection, Save selection as:, , 300, 125
	if (ErrorLevel == 0)
	{
		if FileExist("data\selections\" . FileName)
		{
			MsgBox, 52,, Selection '%FileName%' already exists.`nOverwrite file?
			IfMsgBox Yes
			{
				FileDelete, data\selections\%FileName%
			}
			Else Return
		}
		FileAppend, %SelectedRepos%, data\selections\%FileName%
		Reload
	}
Return
SelectDelete:
	Gui, Submit, NoHide
	if FileExist("data\selections\" . Selection)
	{
		MsgBox, 52,, Delete selection '%Selection%'?
		IfMsgBox Yes
		{
			FileDelete, data\selections\%Selection%
			Reload
		}
	}
Return

GetSelection:
	Gui, Submit, NoHide
	if FileExist("data\selections\" . Selection)
	{
		FileRead, tmpSelection, data\selections\%Selection%
		tmpSelection := StrSplit(Trim(tmpSelection), A_Space)
		global selectedList := Array()
		currSel := 1
		for index, element in repoList
		{
			if (tmpSelection[currSel] == index)
			{
				selectedList.Push(1)
				LV_Modify(index, "Check") ; Check row
				currSel++
			}
			else
			{
				selectedList.Push(0)
				LV_Modify(index, "Check-") ; Uncheck row
			}
		}
		toggleStatus := 0
	}
Return

RunCommand:
	Gui, Submit, NoHide
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
		Process, Close, conhost.exe ; Remove any residual conhosts lying around in the RAM (~6MB!)
		Run, "C:\Program Files\Git\git-bash.exe" "data\gitBashMagic.sh" "%projectDirectory%" "%Command%" "%RepoLocationList%" "%NeedLogin%" "%SoundEnabled%"
	}
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

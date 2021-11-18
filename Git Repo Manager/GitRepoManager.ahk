repoList := Object()
selectedList := Array()

FileRead, projectDirectory, %A_WorkingDir%\data\projectDirectory.txt

Loop, Read, %A_WorkingDir%\data\repoList.txt
{
	repoList[A_Index] := StrSplit(A_LoopReadLine,",")
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
Gui, Add, Edit, w600 vCommand, git status
Gui, Add, Text, ym, `nProject Location: `n`n%projectDirectory%`n
Gui, Add, Button, default gRunCommand, `nRun Command`non`nSelected Repositories`n`n
Gui, Add, Checkbox, y+95 vNeedLogin, Require SSH login

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
	MsgBox, 52,, EXECUTING COMMAND `n`n '%Command%' `n`n ON `n`n %RepoNameList% `n`n CONTINUE ?
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
		;Run, "%A_WorkingDir%\data\runGitCmd.bat" "%projectDirectory%" "%Command%" "%RepoLocationList%"
		Run, "C:\Program Files\Git\git-bash.exe" "data\gitBashMagic.sh" "%projectDirectory%" "%Command%" "%RepoLocationList%" "%NeedLogin%"
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

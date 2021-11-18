@echo off

set PROJECT_DIR=%1
set GIT_COMMAND=%2
set GIT_COMMAND=%GIT_COMMAND:"=%
set REPO_LIST=%3
set REPO_LIST=%REPO_LIST:"=%

cd /d %PROJECT_DIR%

start start-ssh-agent.cmd

call :check_given_repos
EXIT /B 0 

:check_given_repos

	set /a count=1
	for %%a in (%REPO_LIST%) do (
		cd /d %PROJECT_DIR%
		cd %%a
		echo.
		echo -----------------------------------
		echo %%a
		echo -----------------------------------
		%GIT_COMMAND%
		set /a count+=1	
	)
	set /a count-=1
	echo.
	echo -----------------------------------
	echo Worked on %count% repositories!
	echo.
	echo.
	echo.
	
pause

@echo off
setlocal enabledelayedexpansion
for /f "tokens=*" %%G in ('dir /b /a:d') do (
echo Working on %%G
set dat=%%G
echo Date is !dat!
set dat=!dat:~-10!
echo Date is !dat!
set res=%%G
set res=!res:~3,-13!
echo Res is !res!
for /f "tokens=* delims= " %%a in ("!res!") do set res=%%a
set "res=!dat! - !res!"
echo Final is !res!
move ^"%%G^" ^"!res!^"
echo Moved!
echo ------------------
)
pause
@ECHO OFF
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
REM �ϐ���`
SET GROUP=%1
SET INIFILE="C:\temp\01_Tool\bat\test.ini"

REM �����������x���Ăяo��
CALL :Initialize
IF !ERRORLEVEL! NEQ 0 EXIT /B 1

ECHO �������J�n���܂��B

REM SQL�ϐ���`���x���Ăяo��
CALL :SETSQLVAR
IF !ERRORLEVEL! NEQ 0 GOTO :ERROREND
REM �m�F
IF NOT DEFINED SVR (
	ECHO �ϐ�����`�ł��Ă��܂���B���������������A���͊��t�@�C���̒�`�����������m�F���Ă��������B
	EXIT /B 1
)

ECHO %SVR%
ECHO %DB%

REM ################################################################
:NOMALEND
ECHO ����I�����܂����B
EXIT /B 0
REM ################################################################
:ERROREND
ECHO �ُ�I�����܂����B
EXIT /B 1

REM ################################################################
:Initialize
FOR /F "usebackq" %%L IN ('!INIFILE!') DO (
	SET INIFILE=%%~fL
	IF NOT EXIST !INIFILE! (
		ECHO ���t�@�C�������݂��܂���B
		EXIT /B 1
	)
)

IF !ERRORLEVEL! EQU 0 (EXIT /B 0) ELSE (EXIT /B 1)

REM ################################################################
:SETSQLVAR
SET STATUS=0
IF "!GROUP!" EQU "" (
	ECHO ��������ł��B�w�肵�Ă��������B
	EXIT /B 1
)
REM ��`
FOR /F "eol=; usebackq delims== tokens=1-2" %%L IN ("!INIFILE!") DO (
	IF !STATUS! EQU 0 (
		IF "%%L" EQU "[!GROUP!]" (
			SET STATUS=1
		)
		
	) ELSE (
		IF "%%M" EQU "" (
			EXIT /B 0
		) ELSE (
			SET %%L=%%M
			IF !ERRORLEVEL! NEQ 0 EXIT /B 1
		)
	)
)
IF !ERRORLEVEL! EQU 0 (EXIT /B 0) ELSE (EXIT /B 1)

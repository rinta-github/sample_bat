@ECHO OFF
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
REM ######################################################################################
REM # �y���́zSample.bat
REM # �y�����T�v�z�T���v���p
REM # �y���s���@�zSample.bat <����>
REM # �y�����z���t�@�C����[]�����w��
REM ######################################################################################
REM �ϐ���`
SET GROUP=%1
SET INIFILE=%~dpn0.ini
SET LOGDIR=C:\temp\01_Tool\bat

REM [Initialize]���x���Ăяo��
CALL :Initialize
IF !ERRORLEVEL! NEQ 0 EXIT /B 1

REM �����J�n���b�Z�[�W�o��
ECHO %DATE% %TIME% �������J�n���܂��B
ECHO %DATE% %TIME% �������J�n���܂��B>>%LOGFILE% 2>&1

REM [SETENVVAR]���x���Ăяo��
CALL :SETENVVAR
IF !ERRORLEVEL! NEQ 0 GOTO :ERROREND
REM �ϐ���`�m�F
IF NOT DEFINED SVR (
	ECHO �ϐ�����`�ł��Ă��܂���B���������������A���͊��t�@�C���̒�`�����������m�F���Ă��������B
	EXIT /B 1
)

REM ######################################################################################
REM # �y���x�����zNOMALEND
REM # �y�����T�v�z����I������
REM ######################################################################################
:NOMALEND
ECHO %DATE% %TIME% ����I�����܂����B
ECHO %DATE% %TIME% ����I�����܂����B>>%LOGFILE% 2>&1
EXIT /B 0
REM ######################################################################################
REM # �y���x�����zERROREND
REM # �y�����T�v�z�ُ�I������
REM ######################################################################################
:ERROREND
ECHO %DATE% %TIME% �ُ�I�����܂����B���O�t�@�C�����m�F���Ă��������B
ECHO %DATE% %TIME% �ُ�I�����܂����B���O�t�@�C�����m�F���Ă��������B>>%LOGFILE% 2>&1�B
EXIT /B 1

REM ######################################################################################
REM # �y���x�����zInitialize
REM # �y�����T�v�z��������
REM ######################################################################################
:Initialize
REM ini�t�@�C�����`
FOR /F "usebackq" %%L IN ('!INIFILE!') DO (
	SET INIFILE=%%~fL
	REM ini�t�@�C�����ݔ���
	IF NOT EXIST !INIFILE! (
		ECHO ���t�@�C�������݂��܂���B
		EXIT /B 1
	)
)

REM ���O�f�B���N�g�����`
FOR /F "usebackq" %%L IN ('!LOGDIR!') DO (
	SET LOGDIR=%%~fL
	REM �����Ƀo�b�N�X���b�V���t�^
	SET BACKSLASH=!LOGDIR:~-1,1!
	IF !BACKSLASH! NEQ \ (
		SET LOGDIR=!LOGDIR!\
	)
	REM ���O�f�B���N�g�����ݔ���
	IF NOT EXIST !LOGDIR! (
		ECHO ���O�f�B���N�g�������݂��܂���B
		EXIT /B 1
	)
)

REM ���O�t�@�C��(��΃p�X)�쐬
SET HHMMSS=%TIME:~0,8%
SET DATETIME=%DATE:/=%%HHMMSS::=%
SET LOGFILE=%LOGDIR%%~n0_%DATETIME%.log

IF !ERRORLEVEL! EQU 0 (EXIT /B 0) ELSE (EXIT /B 1)

REM ######################################################################################
REM # �y���x�����zSETENVVAR
REM # �y�����T�v�z���t�@�C�����ϐ���`
REM ######################################################################################
:SETENVVAR
SET STATUS=0
IF "!GROUP!" EQU "" (
	ECHO ��������ł��B�w�肵�Ă��������B
	EXIT /B 1
)
REM �ϐ���`
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

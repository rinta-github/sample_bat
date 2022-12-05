@ECHO OFF
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
REM 変数定義
SET GROUP=%1
SET INIFILE="C:\temp\01_Tool\bat\test.ini"

REM 初期処理ラベル呼び出し
CALL :Initialize
IF !ERRORLEVEL! NEQ 0 EXIT /B 1

ECHO 処理を開始します。

REM SQL変数定義ラベル呼び出し
CALL :SETSQLVAR
IF !ERRORLEVEL! NEQ 0 GOTO :ERROREND
REM 確認
IF NOT DEFINED SVR (
	ECHO 変数が定義できていません。引数が正しいか、又は環境ファイルの定義が正しいか確認してください。
	EXIT /B 1
)

ECHO %SVR%
ECHO %DB%

REM ################################################################
:NOMALEND
ECHO 正常終了しました。
EXIT /B 0
REM ################################################################
:ERROREND
ECHO 異常終了しました。
EXIT /B 1

REM ################################################################
:Initialize
FOR /F "usebackq" %%L IN ('!INIFILE!') DO (
	SET INIFILE=%%~fL
	IF NOT EXIST !INIFILE! (
		ECHO 環境ファイルが存在しません。
		EXIT /B 1
	)
)

IF !ERRORLEVEL! EQU 0 (EXIT /B 0) ELSE (EXIT /B 1)

REM ################################################################
:SETSQLVAR
SET STATUS=0
IF "!GROUP!" EQU "" (
	ECHO 引数が空です。指定してください。
	EXIT /B 1
)
REM 定義
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

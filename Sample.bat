@ECHO OFF
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
REM ######################################################################################
REM # 【名称】Sample.bat
REM # 【処理概要】サンプル用
REM # 【実行方法】Sample.bat <引数>
REM # 【引数】環境ファイルの[]内を指定
REM ######################################################################################
REM 変数定義
SET GROUP=%1
SET INIFILE=%~dpn0.ini
SET LOGDIR=C:\temp\01_Tool\bat

REM [Initialize]ラベル呼び出し
CALL :Initialize
IF !ERRORLEVEL! NEQ 0 EXIT /B 1

REM 処理開始メッセージ出力
ECHO %DATE% %TIME% 処理を開始します。
ECHO %DATE% %TIME% 処理を開始します。>>%LOGFILE% 2>&1

REM [SETENVVAR]ラベル呼び出し
CALL :SETENVVAR
IF !ERRORLEVEL! NEQ 0 GOTO :ERROREND
REM 変数定義確認
IF NOT DEFINED SVR (
	ECHO 変数が定義できていません。引数が正しいか、又は環境ファイルの定義が正しいか確認してください。
	EXIT /B 1
)

REM ######################################################################################
REM # 【ラベル名】NOMALEND
REM # 【処理概要】正常終了処理
REM ######################################################################################
:NOMALEND
ECHO %DATE% %TIME% 正常終了しました。
ECHO %DATE% %TIME% 正常終了しました。>>%LOGFILE% 2>&1
EXIT /B 0
REM ######################################################################################
REM # 【ラベル名】ERROREND
REM # 【処理概要】異常終了処理
REM ######################################################################################
:ERROREND
ECHO %DATE% %TIME% 異常終了しました。ログファイルを確認してください。
ECHO %DATE% %TIME% 異常終了しました。ログファイルを確認してください。>>%LOGFILE% 2>&1。
EXIT /B 1

REM ######################################################################################
REM # 【ラベル名】Initialize
REM # 【処理概要】初期処理
REM ######################################################################################
:Initialize
REM iniファイル整形
FOR /F "usebackq" %%L IN ('!INIFILE!') DO (
	SET INIFILE=%%~fL
	REM iniファイル存在判定
	IF NOT EXIST !INIFILE! (
		ECHO 環境ファイルが存在しません。
		EXIT /B 1
	)
)

REM ログディレクトリ整形
FOR /F "usebackq" %%L IN ('!LOGDIR!') DO (
	SET LOGDIR=%%~fL
	REM 末尾にバックスラッシュ付与
	SET BACKSLASH=!LOGDIR:~-1,1!
	IF !BACKSLASH! NEQ \ (
		SET LOGDIR=!LOGDIR!\
	)
	REM ログディレクトリ存在判定
	IF NOT EXIST !LOGDIR! (
		ECHO ログディレクトリが存在しません。
		EXIT /B 1
	)
)

REM ログファイル(絶対パス)作成
SET HHMMSS=%TIME:~0,8%
SET DATETIME=%DATE:/=%%HHMMSS::=%
SET LOGFILE=%LOGDIR%%~n0_%DATETIME%.log

IF !ERRORLEVEL! EQU 0 (EXIT /B 0) ELSE (EXIT /B 1)

REM ######################################################################################
REM # 【ラベル名】SETENVVAR
REM # 【処理概要】環境ファイル内変数定義
REM ######################################################################################
:SETENVVAR
SET STATUS=0
IF "!GROUP!" EQU "" (
	ECHO 引数が空です。指定してください。
	EXIT /B 1
)
REM 変数定義
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

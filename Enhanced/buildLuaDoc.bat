@rem get lua functions from VB description
@set LUA_DEV=C:\Program Files (x86)\Lua\5.1
@set LUA_PATH=;;"C:\Program Files (x86)\Lua\5.1\lua\?.luac"
@set SAVEPATH=%PATH%
@set PATH=%PATH%;%LUA_DEV%
@set MYHOME=C:\Users\Michael\Documents\GitHub\Sources\Enhanced
@set MYCODE=C:/Command/CMANO_Dev/CommandCiv/Command_Core/
@set DESTN=%TEMP%
@set DESTN=C:\Users\Michael\Documents\GitHub\CommandLua.github.io\beta
@echo Home folder = %MYHOME%
@echo Using temporary folder = %TEMP%
@call ldoc_start.bat -c %MYHOME%/config.ld -l %MYHOME% -d %DESTN% %MYHOME%/vb_lua.lua
@rem cleanup temporary files
@del %TEMP%\vb_lua.txt %TEMP%\vb_lua2.txt %TEMP%\vb_lua3.txt 2>%TEMP%/null
@set PATH=%SAVEPATH%
pause
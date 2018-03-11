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
@call ldoc_start.bat -v -c %MYHOME%/config.ld -l %MYHOME% -d %DESTN% %MYHOME%/command.lua
@cp %DESTN%\index.html %TEMP%
@rem replace <em></em> with _ as these are being incoorectly set by ldoc
@awk '{ gsub(/^\074em\076+/,"_");print }' %TEMP%\index.html |awk '{ gsub(/^\074\/em\076+/,"_");print }' > %DESTN%\index.html
@rem cleanup temporary files
@del %TEMP%\vb_lua.txt %TEMP%\vb_lua2.txt %TEMP%\vb_lua3.txt 2>%TEMP%/null
@set PATH=%SAVEPATH%
pause
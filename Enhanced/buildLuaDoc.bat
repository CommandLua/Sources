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
@echo Code folder = %MYCODE%
@echo Using temporary folder = %TEMP%
@egrep "'>>"  %MYCODE%/LUA/*.vb %MYCODE%/LUA/WRAPPERS/*.vb >%TEMP%/vb_lua.txt
@rem trim spaces and first '
@awk '{ sub(/^[ \047]+/, ""); print }' %TEMP%/vb_lua.txt >%TEMP%/vb_lua3.txt
@rem trim file name from results, and the leading >>
@cut -d: -f3- %TEMP%/vb_lua3.txt | cut -c3- >%TEMP%/vb_lua2.txt
@rem remove old lua file
@del %DESTN%\vb_lua.lua 2>%TEMP%/null
@rem add header details
gawk -f %MYHOME%/CMANO_pre.awk %TEMP%/vb_lua2.txt >"%MYHOME%/vb_lua.lua"
@call ldoc_start.bat -c %MYHOME%/config.ld -l %MYHOME% -d %DESTN% %MYHOME%/vb_lua.lua
@call ldoc_start.bat -c %MYHOME%/config.ld -l %MYHOME% -d %DESTN% %MYHOME%/vb_lua.lua --tags todo 2>%MYCODE%/../../todo.list
@rem cleanup temporary files
@del %TEMP%\vb_lua.txt %TEMP%\vb_lua2.txt %TEMP%\vb_lua3.txt 2>%TEMP%/null
@set PATH=%SAVEPATH%
pause
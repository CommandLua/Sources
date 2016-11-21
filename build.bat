
luarocks path > rock_path.bat
call rock_path.bat
del rock_path.bat

rmdir doc /s /q
"C:\Program Files (x86)\Lua\lua52.exe" LDoc-1.4.3\ldoc.lua .
xcopy .\doc .\git-home /s /e /Y
cd git-home
git commit -a -m "Automatic On-Build Commit"
git push
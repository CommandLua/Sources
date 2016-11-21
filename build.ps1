$env:LUA_PATH="C:\Users\Ben Chung\AppData\Roaming/luarocks/share/lua/5.2/?.lua;C:\Users\Ben Chung\AppData\Roaming/luarocks/share/lua/5.2/?/init.lua;C:\Program Files (x86)\lua\\systree/share/lua/5.2/?.lua;C:\Program Files (x86)\lua\
\systree/share/lua/5.2/?/init.lua;C:\Program Files (x86)\LuaRocks\lua\?.lua;C:\Program Files (x86)\LuaRocks\lua\?\init.lua;"
$env:LUA_CPATH="C:\Users\Ben Chung\AppData\Roaming/luarocks/lib/lua/5.2/?.dll;C:\Program Files (x86)\lua\\systree/lib/lua/5.2/?.dll;C:\Program Files (x86)\lua\?.dll;C:\Program Files (x86)\lua\loadall.dll;.\?.dll;C:\Program Files (x
86)\lua\?52.dll;.\?52.dll"


Remove-Item doc -r -force
Start-Process -FilePath "C:\Program Files (x86)\Lua\lua52.exe" -ArgumentList "LDoc-1.4.3\ldoc.lua ." -Wait -NoNewWindow
Copy-Item .\doc\* .\git-home -Force -Recurse
Set-Location "git-home"
git commit -a -m "Automatic On-Build Commit"
git push
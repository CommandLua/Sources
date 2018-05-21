format = 'markdown'
project = 'CommandLua'
title = 'Command Lua Documentation'
template = true
--style='!pale'
style='!fixed'
topics = '.\\Samples' 
--file = { ".\\mock" } 
--kind_names={topic='Examples',module='Reference'}
kind_names={module='Reference'}
full_description = 'Lua is a case sensitive language. For direct access to object properties as in \'unit.name\', the property will be programmed to be in lower case. \n When accessing the properties through the Functions below, both the keyword/property and the value are case insensitive; the code will worry about matching them up.'
not_luadoc=true
sort=true
custom_tags={'remark',title='Remarks'}
no_lua_ref=true
new_type('Selector','Selector',false) 
new_type('Wrapper','Wrapper/Descriptor',false) 
new_type('DataType','Data types',false) 
new_type('Notes','Notes',false) 
new_type('dummy','dummy',true) 
--examples = {'.\\examples', exclude = {'examples/slow.lua'}}
examples = {'.\\Examples'}
wrap=true
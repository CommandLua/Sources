BEGIN{
print "-------"
print "-- @module ScenEdit"
print "--"
print "-- Lua is a case sensitve language."
print "--"
print "-- When accessing object properties directly as in 'unit.name', the property should be in lower which will match the Lua generated code. There may be a <i>few</i> special cases (e.g. mission.SISH=true which is a shortcut for scrub_if_side_human) which will be documented below."
print "--"
print "-- However, when accessing the properties through the module functions below, both the keyword/property and the value are case insensitive; the code will worry about matching them up."
print "--"
print "--<u><b>Selector</b></u><br>"
print "-- These define the information required as part of the 'select' process for the functions. In the case of functions that 'add' things, these are also key elements to the adding process."
print "-- Other properties may be included in the 'selector' such as when updating an existing table."
print "--"
print "-- When selecting units, it is preferrable to use the GUID as the identifier for a precise match. If not, then the side and name for a more limited search. And as a last option, just the name which search all units in the scenario. When using just the name, usually the first matching name is returned. This is okay if the names are unique."
print "-- Thus including the side, it will only check the units on that side for a match."
print "--"
print "--<u><b>Wrapper</b></u><br>"
print "-- These define the information that is returned from some functions. This information can be usually modified either directly (object.field) or by a wrapper Set(..) function. The particular wrapper Set(..) function is preferred as some validation is performed on the input to ensure that it is within the bounds of the field being updated."
print "--"
print "--<u><b>Data type</b></u><br>"
print "-- These cover any special considerations for the data, such as longitude/latitude; degrees, DMS, N/S, E/W, etc."
print "--"
print "--"
print "--<u><b>Error handling</b></u><br>"
print "--Usually when a Lua script fails, an error is thrown that ends the script at that point. While this may be okay in most cases, it is not often desired. <br>Whenever a Command Lua function gets an error, it will normally return a 'nil', and the error message will be available as a Lua global variables; '\\_errmsg\\_' will have the last error message, '\\_errfnc\\_' the Command Lua function that gave the error, and '\\_errnum\\_' the error code (0 is no error, and any value >0 will be an error). Thus if you get back a 'nil', you can check to see if that is due to an error or no data."
print "--"
print "--Example: <br>without the new error handling, the script below would probably terminate after the SE_AddMission() and the rest of script would not run.<br> local mission = ScenEdit_AddMission('USA','Marker strike','strike',{type='land'})<br>if mission == nil then<br> if \\_errno\\_ ~= 0 then print('Failed to add:' .. \\_errmsg\\_) else print('Something else') end<br> else print(mission)<br>...do some more command lua stuff...<br>end<br>"
print "--"
print
}
{print $0}



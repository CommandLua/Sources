--- Command Lua API
-- @module ScenEdit


--- Set the current scene weather.
-- This function takes 4 numbers that describe the desired weather conditions. These
-- conditions are applied globally.
-- @param[type=number] temp The current baseline temperature (in deg C). Varies by latitude.
-- @param[type=number] rate The rainfall rate, 0-50.
-- @param[type=number] percentage The amount of sky that is covered in cloud, 0.0-1.0
-- @param[type=number] state The current sea state 0-9.
-- @usage ScenEdit_SetWeather(math.random(0,25), math.random(0,50), math.random(0,10)/10.0, math.random(0,9))
function ScenEdit_SetWeather(temp, rate, percentage, state)
end

--- Assign a unit to a mission.
-- Takes a unit and mission descriptor, then assigns the unit to the mission if it exists. Produces a pop up
-- error (not catchable) if the unit or mission does not exist.
-- @param[type=string] unit The name or GUID of the unit to assign
-- @param[type=string] mission The mission to execute
-- @usage ScenEdit_AssignUnitToMission("Bar #1", "Strike")
function ScenEdit_AssignUnitToMission(unit, mission)
end

--- Set the side posture towards another.
-- Sets side A's posture towards side B to the specified posture.
-- Posture codes:
--
-- <style>
-- tr:not(:first-child) { border-top: 1px solid black;}
-- td { padding: .5em; }
-- </style>
-- <table style="border-spacing: 0.5rem;">
-- <tr><td>F</td><td>Friendly</td></tr>
-- <tr><td>H</td><td>Hostile</td></tr>
-- <tr><td>N</td><td>Neutral</td></tr>
-- <tr><td>U</td><td>Unfriendly</td></tr>
-- </table>
--
-- @param[type=string] sideAName Side A's name
-- @param[type=string] sideBName Side B's name
-- @param[type=string] posture The posture of side A towards side B
-- @usage ScenEdit_SetSidePosture("LuaSideA", "LuaSideB", "H")
function ScenEdit_SetSidePosture(sideAName, sideBName, posture)
end

--[[--
 Sets the EMCON of the selected object. Select the object by specifying the type and the object's name.
 
 Type is the type of object to set the EMCON on. It can be one of 4 values:

 * **Side** - Set an entire side's EMCON (e.g. United States using active radar)
 * **Mission** - Set the EMCON for a mission (e.g. Minesweepers active sonar)
 * **Group** - Set the EMCON for an entire group (e.g Package #20 active radar)
 * **Unit** - Set the EMCON for a single group (e.g. Hornet #14 passive radar)

 emcon is a compound structure. The string follows the following grammar, with each clause separated by a semicolon (;)

 * `Inherit` indicates that the output EMCON should be at least the parent's EMCON. Inherit must come first.
 * A transmitter "set" statement. Each is of the form `type=status`, where type can be any one of `Radar`, `Sonar`, and `OECM`, and status can be any one of `Passive` or `Active`.

 @param[type=string] type The type of the thing to set the EMCON on.
 @param[type=string] name The name or GUID of the object to select.
 @param[type=string] emcon The new EMCON for the object.
 @usage ScenEdit_SetEMCON('Side', 'NATO', 'Radar=Active;Sonar=Passive')
 @usage ScenEdit_SetEMCON('Mission', 'ASW Patrol #1', 'Inherit;Sonar=Active')
 @usage ScenEdit_SetEMCON('Unit', 'Camel 2', 'OECM=Active')
]]
function ScenEdit_SetEMCON(type, name, emcon)
end

--[[--
Run a script in a file.
This function runs a script in the file `script`. This file must be inside the [Command base directory]/Lua directory, or else the game will not be able to load it.

@param script The script to run. The file that is looked for will be of the form [Command base directory]/Lua/[`script`]
@usage ScenEdit_RunScript('cklib.lua')
]]
function ScenEdit_RunScript(script)
end

--[[--
Reference point descriptor.

For creation, *every* field must be defined.

If selecting a unit (that is, using the descriptor as a selector) (e.g. @{ScenEdit_SetReferencePoint|SetReferencePoint}), one of the two following sets of fields must be define:

* `name` and `side`, to select a reference point `name` belonging to `side`
* `guid`, if the unique ID of the reference point is known.

If both are given, then the method defaults to finding the reference point with the correct GUID.

@table ReferencePoint
@field[type=string] name The name of the reference point
@field[type=latlon] latitude The latitude of the reference point
@field[type=latlon] longitude The longitude of the reference point
@field[type=string] guid The unique identifier for the reference point
@field[type=string] side The side the reference point is visible to
@field[type=bool] highlighted True if the point should be selected
]]
RefPoint = {
 name, 
 latitude, 
 longitude , 
 guid, 
 side, 
 highlighted, 
}

--[[--
Reference point selector.

To select a unit, specify either
* `name` and `side`, to select a reference point `name` belonging to `side`
* `guid`, if the unique ID of the reference point is known.

If both are given, then the method defaults to finding the reference point with the correct GUID.

@table ReferencePointSelector
@field[type=string] side The side the reference point is visible to
@field[type=string] name The name of the reference point
@field[type=string] guid The unique identifier for the reference point
]]

RefPointSelector = {
 name, 
 side, 
 guid
}


--[[--
Add a new reference point.
Based on `descriptor`, a table of type @{ReferencePoint}, this function adds a new reference point into the scene. 
@param[type=ReferencePoint] descriptor The reference point to create.
@usage ScenEdit_AddReferencePoint({side="United States", name="Downed Pilot", lat=0.1, lon=4, highlighted=true})
@return[type=ReferencePoint] The reference point descriptor for the new reference point.
]]
function ScenEdit_AddReferencePoint(descriptor)
 -- body
end

--[[--
Delete a reference point.
Given a reference point selector, this function will remove it from the scene.
@param[type=ReferencePointSelector] selector The reference point selector describing the reference point to delete.
]]
function ScenEdit_DeleteReferencePoint(selector)
 -- body
end

--[[--
Update a reference point with new values.
Given a @{ReferencePoint|descriptor with a valid selector}, the function will find the correct reference point and update it to the values contained in the descriptor.
Values may be omitted from the descriptor if they are intended to remain unmodified.
@param[type=ReferencePoint] descriptor A descriptor with a valid selector.
@usage ScenEdit_SetReferencePoint({side="United States", name="Downed Pilot", lat=0.5})
@usage ScenEdit_SetReferencePoint({side="United States", name="Downed Pilot", lat=0.5, lon="N50.50.50", highlighted = true})
]]
function ScenEdit_SetReferencePoint(descriptor)
 -- body
end
--[[--
Represents a unit in the scene. 
This structure can be used as either a descriptor (e.g. when returned or when creating a new unit) 
or as a selector (e.g. when used to find a unit).

When being used as a selector, a unit can be discovered in 1 of two ways:

 1. Name and side, which is slower
 2. GUID, which is faster

If both are specified, the GUID is chosen over the name and side selection, which are then considered parts of the descriptor. 

Excluding GUID, any field may be modified.

Note that "PlayerSide", while not a valid side in the scene, may be used to select the player's side 
unambiguously.

@field[type=string] type The type of object, may be 'Facility', 'Ship', 'Submarine', or 'Aircraft' (descriptor).
@field[type=string] name The unit's name.
@field[type=string] side The unit's side.
@field[type=latlon] latitude The latitude of the unit (descriptor).
@field[type=latlon] longitude The longitude of the unit (descriptor).
@field[type=number] DBID The database ID of the unit (descriptor).
@field[type=number] altitude The altitude of the unit in meters (descriptor).
@field[type=bool,opt] autodetectable True if the unit is automatically detected (descriptor).
@field[type=bool,opt] holdfire True if the unit should not fire (descriptor).
@field[type=string] guid The unit's unique ID. 
@field[type=number,opt] heading The unit's heading (descriptor).
@field[type=string,opt] proficiency The unit proficiency, one of 0, 1, 2, 3, 4 (descriptor).
@field[type=string,opt] newname If a descriptor, the unit's new name (descriptor).
@field[type=list latlon] course The unit's course, as lat/lon pairs
@field[type=bool,opt] RTB If used in SetUnit, then if to trigger the unit to return to base
@field[type=Fuel] fuel A table enabling access to the unit's fuel status
@field[type=string] mission The name of the mission the unit is assigned to (can be altered)
@table Unit
]]
Unit = {
 type, 
 name, 
 side, 
 latitude, 
 longitude, 
 DBID,
 altitude, 
 autodetectable, 
 holdfire, 
 guid, 
 heading,
 proficiency,
 newname,
 course,
 RTB,
 fuel,
 mission
}

--[[--
A table describing the fuel state of a given unit. This entire table should be replaced in a single go - so to update a unit's fuel, see the example.

Fuel IDs:

<style>
tr:not(:first-child) { border-top: 1px solid black;}
td { padding: .5em; }
</style>
<table style="border-spacing: 0.5rem;">
<tr><td>1001</td><td>'no fuel'</td></tr>
<tr><td>2001</td><td>aviation fuel</td></tr>
<tr><td>3001</td><td>diesel fuel</td></tr>
<tr><td>3002</td><td>oil fuel</td></tr>
<tr><td>3003</td><td>gas fuel</td></tr>
<tr><td>4001</td><td>battery life</td></tr>
<tr><td>4002</td><td>AIP</td></tr>
<tr><td>5001</td><td>rocket fuel</td></tr>
<tr><td>5002</td><td>torpedo fuel</td></tr>
<tr><td>5003</td><td>weapon coast</td></tr>
</table>
@field[type=FuelState] code The fuel state of the unit. Note that 'code' is a placeholder - it should be replaced with a valid fuel ID, as listed above.
@usage local fuel = u.fuel
       fuel[3001].current = 400
       u.fuel = fuel
]]
Fuel = {
	code
}

--[[--
Describes the current fuel state of a unit


@field[type=number] current The current fuel of the unit
@field[type=number] max How much can be stored in the unit
]]
FuelState = {
	current,
	max
}

--[[--
Use to select a unit in the scene based on either the side and name or the unique identifier (GUID).

You can use either
1. `name` and `side`
2. `guid`
If both are given, then the GUID is used preferentially.

@field[type=string] name The name of the unit to select (for option #1)
@field[type=string] side The name of the unit to select (for option #1)
@field[type=string] guid The guid of the unit to select (for option #2)
@table UnitSelector
]]
UnitSelector = {
	name,
	side,
	guid
}

--[[--
Adds a unit to the scene based on a descriptor.

@param[type=Unit] unit The unit to add
@return[type=Unit] A complete descriptor for the added unit
@usage ScenEdit_AddUnit({type = 'Aircraft', name = 'F-15C Eagle', loadoutid = 16934, 
 heading = 0, dbid = 3500, side = 'NATO', Latitude="N46.00.00",Longitude="E25.00.00",
 altitude="5000 ft",autodetectable="false",holdfire="true",proficiency=4})
@usage ScenEdit_AddUnit({type = 'Air', name = 'F-15C Eagle', loadoutid = 16934, dbid = 3500, side = 'NATO', Lat="5.123",Lon="-12.51",alt=5000})

]]
function ScenEdit_AddUnit(unit)
end

--[[--
Sets the properties of a unit that already exists.

@param[type=Unit] unit The unit to edit. Must be at least a selector.
@return[type=Unit] A complete descriptor for the added unit
@usage ScenEdit_SetUnit({side="United States", name="USS Test", lat = 5})
@usage ScenEdit_SetUnit({side="United States", name="USS Test", lat = 5})
@usage ScenEdit_SetUnit({side="United States", name="USS Test", lat = 5, lon = "N50.20.10"})
@usage ScenEdit_SetUnit({side="United States", name="USS Test", newname="USS Barack Obama"})
@usage ScenEdit_SetUnit({side="United States", name="USS Test", heading=0, HoldPosition=1, HoldFire=1,Proficiency="Ace", Autodetectable="yes"})
]]
function ScenEdit_SetUnit(unit)
end

--[[--
Deletes a unit based on a selector.
@param[type=Unit] unit The unit to delete. Must be at least a selector.
@usage ScenEdit_DeleteUnit({side="United States", name="USS Abcd"})
]]
function ScenEdit_DeleteUnit(unit)
end

--[[--
Fetches a unit based on a selector.

This function is mostly identical to @{ScenEdit_SetUnit} except that if no unit is selected by the selector portion of `unit`, 
then the function returns nil instead of producing an exception.

@param[type=UnitSelector] unit The unit to select.
@return[type=Unit] A complete unit descriptor if the unit exists or nil otherwise.
@usage ScenEdit_GetUnit({side="United States", name="USS Test"})
]]
function ScenEdit_GetUnit(unit)
end

--[[--
Sets a persistent value in the key value store.

This function allows you to add values, associated with keys, to a persistent store that is retained when the game is saved and resumed. Keys and values are both represented as non-nil strings.

@param[type=string] key The key to associate with
@param[type=string] value The value to associate
@usage ScenEdit_SetKeyValue("A","B")
ScenEdit_GetKeyValue("A") -- returns "B"
]]
function ScenEdit_SetKeyValue(key, value) end

--[[--
Gets a persistent value.

This function retrieves a value put into the store by @{ScenEdit_SetKeyValue}. The keys must be identical.

@param[type=string] key The key to fetch the associated value of
@return[type=string] The value associated with the key. "" if none exists.
@usage ScenEdit_SetKeyValue("A","2")
ScenEdit_GetKeyValue("A") -- returns "2"
]]
function ScenEdit_GetKeyValue(key) end

--[[--
Selects a thing, one of a side, group, mission, or unit.

This selector can only be used with the doctrine mechanism, with other systems relying on different selection mechanisms.

@param[type=string] side The side to select/from
@param[type=string] mission The name of the mission to select
@param[type=string] name The name of the unit to select
@param[type=string] group The name of the group to select
]]
DoctrineSelector = {
 side,
 mission,
 name,
 group
}

--[[--
Describes a doctrine.

At the current time, a bug exists where Lua booleans do not work for bool fields. To work around this issue, 
use one of `"1"`, `"true"` or `"yes"` for true or `"0"`, `"false"`, or `"no"` for false.

For each field, adding the suffix "_player_editable" determines if the player can alter the setting.

@param[type=bool] use_nuclear_weapons True iff the unit should be able to employ nuclear weapons
@param[type=bool] engage_non_hostile_targets True iff the unit should attempt hostile action against units that are not hostile
@param[type=bool] rtb_when_winchester True iff the unit should return to base when out of weapons
@param[type=bool] ignore_plotted_course True iff the unit should ignore plotted courses
@param[type=string] engaging_ambiguous_targets One of "Ignore", "Optimistic", or "Pessimistic"
@param[type=bool] automatic_evasion True iff the unit should automatically evade incoming missiles
@param[type=bool] maintain_standoff True iff the unit should try to avoid approaching its target, only valid for ships
@param[type=bool] use_refuel_unrep One of "Always" or "Never"
@param[type=bool] engage_opportunity_targets True iff the unit should take opportunistic shots
@param[type=bool] use_sams_in_anti_surface_mode True iff SAMs should be used to engage surface targets
@param[type=bool] ignore_emcon_while_under_attack True iff EMCON should be ignored and all systems should go active when engaged
@param[type=bool] quick_turnaround_for_aircraft One of "Yes", "FightersAndASW", or "No"
@param[type=bool] air_operations_tempo One of "Surge" or "Sustained"
@param[type=bool] kinematic_range_for_torpedoes One of "AutomaticAndManualFire", "ManualFireOnly", or "No"
@param[type=string] weapon_control_status_air '0','1','2' which correspond to Free, Tight, and Hold.
@param[type=string] weapon_control_status_surface '0','1','2' which correspond to Free, Tight, and Hold.
@param[type=string] weapon_control_status_subsurface '0','1','2' which correspond to Free, Tight, and Hold.
@param[type=string] weapon_control_status_land '0','1','2' which correspond to Free, Tight, and Hold.
]]
Doctrine = {
 use_nuclear_weapons,
 engage_non_hostile_targets,
 rtb_when_winchester,
 ignore_plotted_course,
 engaging_ambiguous_targets,
 automatic_evasion,
 maintain_standoff,
 use_refuel_unrep,
 engage_opportunity_targets,
 use_sams_in_anti_surface_mode,
 ignore_emcon_while_under_attack,
 quick_turnaround_for_aircraft,
 air_operations_tempo,
 kinematic_range_for_torpedoes,
 weapon_control_status_air,
 weapon_control_status_surface,
 weapon_control_status_subsurface,
 weapon_control_status_land,
}
--[[--
Set the doctrine of the designated object.

This function uses selector to find the thing to modify, then modifies the doctrine of that object based on the given object.

@param[type=DoctrineSelector] selector The selector for the object to modify
@param[type=Doctrine] doctrine The doctrine to update the object to
@usage ScenEdit_SetDoctrine({side="Soviet Union"}, {kinematic_range_for_torpedoes = "AutomaticAndManualFire",use_nuclear_weapons= "yes" })
@usage ScenEdit_SetDoctrine({side="Soviet Union", mission="ASW PATROL"}, {kinematic_range_for_torpedoes = "AutomaticAndManualFire",use_nuclear_weapons= "yes" })
@usage ScenEdit_SetDoctrine({side="Soviet Union", name="Bear #2"}, {use_nuclear_weapons= "yes" })
]]
function ScenEdit_SetDoctrine(selector, doctrine)
end

--[[--
Gets the doctrine of the designated object.

This function looks up the doctrine of the object selected by selector, and throws an exception if the unit does not exist.

@param[type=DoctrineSelector] selector The selector for the object to look up
@return[type=Doctrine] The doctrine of the selected object
@usage ScenEdit_GetDoctrine({side="Soviet Union"}).use_nuclear_weapons
]]
function ScenEdit_GetDoctrine(selector)
end

--[[--
Gets the current time.
@return[type=number] The UTC Unix timestamp of the current time in-game.
]]
function ScenEdit_CurrentTime()
end

--[[--
Adds an aircraft to the scene.
<b>Not recommended, use @{ScenEdit_AddUnit} instead</b>

Note that the parameters `lat` and `lon` are specified by the parameter `latlonspec`. If `latlonspec` is `"DEG"`, then `lat` and `lon` should be a simple
floating point number. If `latlonspec` is `"DEC"`, then `lat` and `lon` should be in the format of `"N/S/E/W deg.min.sec".

@param[type=string] sideName The name of the side for the new aircraft
@param[type=string] unitName The name of the new aircraft
@param[type=number] dbid The database ID of the new aircraft
@param[type=number] loadoutID The database ID of the aircraft's loadout
@param[type=string] latlonspec The formatting specification for `lat` and `lon`.
@param[type=latlon] lat The latitude of the new aircraft
@param[type=latlon] lon The longitude of the new aircraft
@usage ScenEdit_AddAircraft("USA", "Eagles", 3222, 3177, "DEG", 1.1, 1.1)
]]
function ScenEdit_AddAircraft(sideName, unitName, dbid, loadoutID, latlonspec, lat, lon)
end


--[[--
Adds a ship to the scene.
<b>Not recommended, use @{ScenEdit_AddUnit} instead</b>

Note that the parameters `lat` and `lon` are specified by the parameter `latlonspec`. If `latlonspec` is `"DEG"`, then `lat` and `lon` should be a simple
floating point number. If `latlonspec` is `"DEC"`, then `lat` and `lon` should be in the format of `"N/S/E/W deg.min.sec".

@param[type=string] sideName The name of the side for the new ship
@param[type=string] unitName The name of the new ship
@param[type=number] dbid The database ID of the new ship
@param[type=string] latlonspec The formatting specification for `lat` and `lon`.
@param[type=latlon] lat The latitude of the new ship
@param[type=latlon] lon The longitude of the new ship
@usage ScenEdit_AddShip('Blue', 'Boat', 745, 'DEC', '23.1', '-40.2')
]]
function ScenEdit_AddShip(sideName, unitName, dbid, latlonspec, lat, lon)
end



--[[--
Adds a submarine to the scene.
<b>Not recommended, use @{ScenEdit_AddUnit} instead</b>

Note that the parameters `lat` and `lon` are specified by the parameter `latlonspec`. If `latlonspec` is `"DEG"`, then `lat` and `lon` should be a simple
floating point number. If `latlonspec` is `"DEC"`, then `lat` and `lon` should be in the format of `"N/S/E/W deg.min.sec".

@param[type=string] sideName The name of the side for the new submarine
@param[type=string] unitName The name of the new submarine
@param[type=number] dbid The database ID of the new submarine
@param[type=string] latlonspec The formatting specification for `lat` and `lon`.
@param[type=latlon] lat The latitude of the new submarine
@param[type=latlon] lon The longitude of the new submarine
@usage ScenEdit_AddSubmarine('Blue', 'Duck', 112, 'DEC', '23.1', '-40.2')
]]
function ScenEdit_AddSubmarine(sideName, unitName, dbid, latlonspec, lat, lon)
end


--[[--
Adds an aircraft to the scene.
<b>Not recommended, use @{ScenEdit_AddUnit} instead</b>

Note that the parameters `lat` and `lon` are specified by the parameter `latlonspec`. If `latlonspec` is `"DEG"`, then `lat` and `lon` should be a simple
floating point number. If `latlonspec` is `"DEC"`, then `lat` and `lon` should be in the format of `"N/S/E/W deg.min.sec".

@param[type=string] sideName The name of the side for the new facility
@param[type=string] unitName The name of the new facility
@param[type=number] dbid The database ID of the new facility
@param[type=number] orientation The heading of the new facility
@param[type=string] latlonspec The formatting specification for `lat` and `lon`.
@param[type=latlon] lat The latitude of the new facility
@param[type=latlon] lon The longitude of the new facility
@usage ScenEdit_AddFacility("Orange", "Here", 19, 0, "DEC", "N 40.26.30", "W 80.00.00")
]]
function ScenEdit_AddFacility(sideName, unitName, dbid, orientation, latlonspec, lat, lon)
end

--[[--
Ends the current scenario.
]]
function ScenEdit_EndScenario() end

--[[--
Get a given side's score.

@param[type=string] side The name of the side
@return[type=num] The side's score
@usage ScenEdit_GetScore("PlayerSide")
]]
function ScenEdit_GetScore(side)
end

--[[--
Sets a given side's score.

@param[type=string] side The name of the side
@param[type=num] score The new score for the side
@param[type=string] reason The reason for the score to change
@usage ScenEdit_GetScore("PlayerSide", 20)
]]
function ScenEdit_SetScore(side,score,reason) end

--[[--
Gets the unit that fired the current trigger - nil if otherwise.

@return[type=Unit] The triggering unit
@usage ScenEdit_UnitX()
]]
function ScenEdit_UnitX() end

--[[--
Opens a message box with the given string.

@param[type=string] string The string to display to the user
@param[type=num] style The style of the message box
@return No return value - user response is lost.
]]
function ScenEdit_MsgBox(string, style) end

--[[--
Imports an inst file.

@param[type=string] side The side to import the inst file as
@param[type=string] filename The filename of the inst file
]]
function ScenEdit_ImportInst(side, filename) end

--[[--
Import an attachment into the scene.

@param[type=string] attachment Either the name of the attachment or the GUID of the attachment
]]
function ScenEdit_UseAttachment(attachment) end

--[[--
Use an attachment on a side (used for .inst files as attachments).

@param[type=string] attachment Either the name of the attachment or the GUID of the attachment
@param[type=string] sidename The name of the side to import the attachment into
]]
function ScenEdit_UseAttachmentOnSide(attachment, sidename) end

--[[--
Defines a warhead to detonate.

@param[type=number] warheadid The ID of the warhead to detonate - find by weapon
@param[type=number] lat The latitude of the detonation
@param[type=number] lon The longitude of the detonation
@param[type=number] altitude The altitude of the detonation
]]
Explosion = {
 warheadid,
 lat,
 lon,
 altitude
}


--[[--
Detonates a warhead at a specified location.

@param[type=Explosion] explosion The explosion descriptor.
]]
function ScenEdit_AddExplosion(explosion)
end


--[[--
Defines a warhead to detonate.

@param[type=string] ActionNameOrID The name or ID of the special action
@param[type=bool] IsActive If the action is visible to the player
@param[type=bool] IsRepeatable If the player can use the action multiple times
@param[type=string] NewName If specified, the new name of the action
@param[type=string] Description If specified, the new description for the action
]]
SpecialAction = {
 ActionNameOrID,
 IsActive,
 IsRepeatable,
 NewName,
 Description
}

--[[--
Sets the properties of an already existing special action with the specified information.

@param[type=SpecialAction] action_info The special action to modify
]]
function ScenEdit_SetSpecialAction(action_info)
end


--[[--
Requests that a unit be hosted to another

@param[type=string] HostedUnitNameOrID The name or GUID of the unit to put into the host
@param[type=string] SelectedHostNameOrID The name or GUID of the host to put the unit into
]]
HostUnit = {
	HostedUnitNameOrID,
	SelectedHostNameOrID
}

--[[--
Hosts a unit to the specified host. The unit will be moved from any location, including flying or hostes elsewhere.

@param[type=HostUnit] host_info The information about the hosting request
]]
function ScenEdit_HostUnitToParent(host_info)
end


--[[--
Gets the posture of one side towards another. 

@param[type=string] sideA The name of the first side
@param[type=string] sideB The name of the second side
@return The posture of sideA towards sideB, one of 'N', 'F', 'H', or 'A'.
]]
function ScenEdit_GetSidePosture(sideA,sideB) end


--[[--
Returns true iff the scene has started.

@return If the scene has started
]]
function ScenEdit_GetScenHasStarted() end


--[[--
Sets the loadout for a unit

@param[type=LoadoutInfo] loadoutinfo The loadout information to apply
]]
function ScenEdit_SetLoadout(loadoutinfo)end


--[[--
Information on a loadout to add/alter

@param[type=string] UnitNameOrID The name or GUID of the unit to change the loadout on
@param[type=number] LoadoutID The ID of the new loadout
@param[type=number] TimeToReady_Minutes How many minutes until the loadout is ready
@param[type=bool] IgnoreMagazines If the new loadout should rely on the magazines having the right weapons ready
]]
LoadoutInfo = {
	UnitNameOrID, 
	LoadoutID, 
	TimeToReady_Minutes, 
	IgnoreMagazines
}


--[[--
Returns true iff sidename is the human

@param[type=string] sidename The name of the side to check if is human
@return True iff the side specified is human
]]
function ScenEdit_GetSideIsHuman(sidename)end



--[[--
Changes the side of a unit

@param[type=SideDescription] sidedesc The description of how to change the unit's side
]]
function ScenEdit_SetUnitSide(sidedesc)end

--[[--
Information on how to change a unit's side. ORDER IS IMPORTANT

@param[type=string] side The original side
@param[type=string] name The name/GUID of the unit
@param[type=string] newside The new side
]]
SideDescription = {
	side,
	name,
	newside
}

--[[--
Returns the player's current side.

@return The player's side
]]
function ScenEdit_PlayerSide()
end

--[[--
	Displays a special message consisting of the HTML text `message` to side `side.

@param[type=string] side The side to display the message on
@param[type=string] message The HTML text to display to the player
]]
function ScenEdit_SpecialMessage(side, message)
	-- body
end

--[[--
	Returns the elevation in meters of a given position

@param[type=Point] location The position to find the elevation of
@return The elevation of the point in meters
]]
function World_GetElevation(location) end


--[[--
Information about a geographic point.

@param[type=number] latitude The latitude of the point
@param[type=number] longitude The longitude of the point
]]
Point = {
	latitude, 
	longitude
}


--[[--
Gets a side object from the perspective of the player.

@param[type=SideSelector] side The side to get information about
@return[type=SideInfo] Information about the side selected, from the perspective of the player
]]
function VP_GetSide(side)
end


--[[--
Information to select a particular side. 

@param[type=string] GUID The GUID of the side to select. Preferred.
@param[type=string] Name The name of the side to select.
]]
SideSelector = {
	GUID,
	Name
}


--[[--
Get the perspective of the specified side.

@param[type=string] objectid The GUID of the side.
@param[type=string] Name The name of the side.
@param[type={SideUnit,...}] Units Units of the designated side.
@param[type={SideContact,...}] Contacts The side's current contacts.
]]
SideInfo = {
	objectid,
	Name,
	Units, 
	Contacts
}

--[[--
Information known about a specific unit. 

@param[type=string] objectid The GUID of the unit.
@param[type=string] Name The name of the unit.
]]
SideUnit = {
	objectid,
	Name
}
--[[--
The information known about a specific contact. 

@param[type=string] objectid The GUID of the contact. Note that this is not the GUID of the unit, you must use VP_GetUnit to resolve it.
@param[type=string] Name The name of the contact.
]]
SideContact = {
	objectid,
	Name
}

--[[
Gets the information known about a unit, based on the unit's name or GUID.


@param[type=SideContact] contact The contact to interrogate
@return[type=Unit] The unit associated with the contact
]]
function VP_GetUnit(contact) end
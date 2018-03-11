-------
-- @module ScenEdit
--
-- Lua is a case sensitve language.
--
-- When accessing object properties directly as in 'unit.name', the property should be in lower which will match the Lua generated code. There may be a <i>few</i> special cases (e.g. mission.SISH=true which is a shortcut for scrub_if_side_human) which will be documented below.
--
-- However, when accessing the properties through the module functions below, both the keyword/property and the value are case insensitive; the code will worry about matching them up.
--
--<u><b>Selector</b></u><br>
-- These define the information required as part of the 'select' process for the functions. In the case of functions that 'add' things, these are also key elements to the adding process.
-- Other properties may be included in the 'selector' such as when updating an existing table.
--
-- When selecting units, it is preferrable to use the GUID as the identifier for a precise match. If not, then the side and name for a more limited search. And as a last option, just the name which search all units in the scenario. When using just the name, usually the first matching name is returned. This is okay if the names are unique.
-- Thus including the side, it will only check the units on that side for a match.
--
--<u><b>Wrapper</b></u><br>
-- These define the information that is returned from some functions. This information can be usually modified either directly (object.field) or by a wrapper Set(..) function. The particular wrapper Set(..) function is preferred as some validation is performed on the input to ensure that it is within the bounds of the field being updated.
--
--<u><b>Data type</b></u><br>
-- These cover any special considerations for the data, such as longitude/latitude; degrees, DMS, N/S, E/W, etc.
--
--
--<u><b>Error handling</b></u><br>
--Usually when a Lua script fails, an error is thrown that ends the script at that point. While this may be okay in most cases, it is not often desired. <br>Whenever a Command Lua function gets an error, it will normally return a 'nil', and the error message will be available as a Lua global variables; '\_errmsg\_' will have the last error message, '\_errfnc\_' the Command Lua function that gave the error, and '\_errnum\_' the error code (0 is no error, and any value >0 will be an error). Thus if you get back a 'nil', you can check to see if that is due to an error or no data.
--
--Example: <br>without the new error handling, the script below would probably terminate after the SE_AddMission() and the rest of script would not run.<br> local mission = ScenEdit_AddMission('USA','Marker strike','strike',{type='land'})<br>if mission == nil then<br>&emsp;if \_errnum\_ ~= 0 then print('Failed to add:' .. \_errmsg\_) else print('Something else') end<br>else<br>&emsp;print(mission)<br>&emsp;do some more command lua stuff...<br>end<br>
--
--Note:
--Due to how errors are now handle from SR7, if a command fails in the console window, it will show an error. If the command runs outside the console (as in an event script), it will not fail with a visible error but return a nil or  or some other value.
--One issue with commands running in an event is that sometimes they fail with an in-game message that actually stops the rest of the script from running. Now, these event scripts will run without any in-game message showing, and the designer should check the result of the command and handle any error condition, and let the remaining script run as needed.
--
--My intent is have all command errors behave in the same fashion in the console window; and the command errors outside a console behave without stopping the script. Which requires the designer to cater for the specific error conditions.
--
--To emulate the expected outcome from an event, put 'Tool_EmulateNoConsole(true)' at the start of the script to be tested; it is not required in the event code as the script is already not running in a console.
--
--Note also, that the Lua history log should also record the event script errors.
--
--
--<b>Release: 1.14 </b>
--

--[[-- Selects a doctrine.
 .. for on a side, group, mission, or unit

@Selector DoctrineSelector
@param[type=string] side The side to select/from
@param[type=string] mission The name of the mission to select
@param[type=string] unitname The name of the unit to select
@param[type=string] group The name of the group to select
@param[type=bool] escort If a strike mission, adding 'escort=true' will update the escort doctrine
]]


--[[-- Doctrine options.


For each field, adding the suffix "_player_editable" determines if the player can alter the setting. Not applicable to the Withdraw/Deploy options.

 When setting the option, the indicated value or it's number can be used.
@Wrapper Doctrine
@param[type=bool] use_nuclear_weapons True if the unit should be able to employ nuclear weapons
@param[type=bool] engage_non_hostile_targets True if the unit should attempt hostile action against units that are not hostile
@param[type=bool] rtb_when_winchester (obsolete, see the new doctrine options) True if the unit should return to base when out of weapons 
@param[type=bool] ignore_plotted_course True if the unit should ignore plotted course
@param[type=string] engaging_ambiguous_targets Ignore(0), Optimistic(1), or Pessimistic(2)
@param[type=bool] automatic_evasion True if the unit should automatically evade
@param[type=bool] maintain_standoff True if the unit should try to avoid approaching its target, only valid for ships
@param[type=string] use_refuel_unrep Always_ExceptTankersRefuellingTankers(0), Never(1), Always_IncludingTankersRefuellingTankers(2)
@param[type=bool] engage_opportunity_targets True if the unit should take opportunistic shots
@param[type=bool] use_sams_in_anti_surface_mode True if SAMs should be used to engage surface targets
@param[type=bool] ignore_emcon_while_under_attack True if EMCON should be ignored and all systems should go active when engaged
@param[type=string] quick_turnaround_for_aircraft  Yes(0), FightersAndASW(1), No(2)
@param[type=string] air_operations_tempo Surge(0), Sustained(1)
@param[type=string] kinematic_range_for_torpedoes AutomaticAndManualFire(0), ManualFireOnly(1), No(2)
@param[type=string] weapon_control_status_air Free(0), Tight(1), Hold(2)
@param[type=string] weapon_control_status_surface Free(0), Tight(1), Hold(2)
@param[type=string] weapon_control_status_subsurface Free(0), Tight(1), Hold(2)
@param[type=string] weapon_control_status_land Free(0), Tight(1), Hold(2)
@param[type=string] refuel_unrep_allied Yes(0), Yes_ReceiveOnly(1), Yes_DeliverOnly(2), No(3)
@param[type=string] fuel_state_planned Bingo(0), Joker10Percent(1), Joker20Percent(2), Joker25Percent(3), Joker30Percent(4), Joker40Percent(5), Joker50Percent(6), Joker60Percent(7), Joker70Percent(8), Joker75Percent(9), Joker80Percent(10), Joker90Percent(11)
@param[type=string] fuel_state_rtb No(0), YesLastUnit(1), YesFirstUnit(2), YesLeaveGroup(3)
@param[type=string] weapon_state_planned See Weapon Doctrine table below
@param[type=string] weapon_state_rtb No(0), YesLastUnit(1), YesFirstUnit(2), YesLeaveGroup(3)
@param[type=string] gun_strafing No(0), Yes(1)
@param[type=string] jettison_ordnance  No(0), Yes(1)
@param[type=string] avoid_contact  No(0), Yes_ExceptSelfDefence(1), Yes_Always(2)       
@param[type=string] dive_on_threat Yes(0), Yes_ESM_Only(1), Yes_Ships20nm_Aircraft30nm(2), No(3)
@param[type=string] recharge_on_patrol Recharge_Empty(0), Recharge_10_Percent(10), Recharge_20_Percent(20), Recharge_30_Percent(30), Recharge_40_Percent(40), Recharge_50_Percent(50), Recharge_60_Percent(60), Recharge_70_Percent(70), Recharge_80_Percent(80), Recharge_90_Percent(90)
@param[type=string] recharge_on_attack Recharge_Empty(0), Recharge_10_Percent(10), Recharge_20_Percent(20), Recharge_30_Percent(30), Recharge_40_Percent(40), Recharge_50_Percent(50), Recharge_60_Percent(60), Recharge_70_Percent(70), Recharge_80_Percent(80), Recharge_90_Percent(90)
@param[type=string] use_aip  No(0), Yes_AttackOnly(1), Yes_Always(2)
@param[type=string] dipping_sonar Automatically_HoverAnd150ft(0), ManualAndMissionOnly(1)
@param[type=string] withdraw_on_damage Ignore(0), Percent5(1), Percent25(2), Percent50(3), Percent75(4)
@param[type=string] withdraw_on_fuel Ignore(0), Bingo(1), Percent25(2), Percent50(3), Percent75(4), Percent100(5)
@param[type=string] withdraw_on_attack  Ignore(0), Exhausted(1), Percent25(2), Percent50(3), Percent75(4), Percent100(5), LoadFullWeapons(6)
@param[type=string] withdraw_on_defence Ignore(0), Exhausted(1), Percent25(2), Percent50(3), Percent75(4), Percent100(5), LoadFullWeapons(6)
@param[type=string] deploy_on_damage  Ignore(0), Percent5(1), Percent25(2), Percent50(3), Percent75(4) 
@param[type=string] deploy_on_fuel Ignore(0) Bingo(1), Percent25(2), Percent50(3), Percent75(4), Percent100(5) 
@param[type=string] deploy_on_attack  Ignore(0), Exhausted(1), Percent25(2), Percent50(3), Percent75(4), Percent100(5), LoadFullWeapons(6) 
@param[type=string] deploy_on_defence Ignore(0), Exhausted(1), Percent25(2), Percent50(3), Percent75(4), Percent100(5), LoadFullWeapons(6) 


 <b>Weapon doctrine:</b>
 <style>
 tr:not(:first-child) { border-top: 1px solid black;}
 td { padding: .5em; }
 </style>
 <table style="border-spacing: 0.5rem;">
 <tr><td>Value</td><td>Number</td><td>Explanation</td></tr>
 <tr><td>LoadoutSetting</td><td>0</td><td>use setting from database</td></tr>
 <tr><td>Winchester</td><td>2001</td><td>Vanilla Winchester.</td></tr>
 <tr><td>Winchester_ToO</td><td>2002</td><td>Same as above, but engage nearby bogies with guns after we're out of missiles. Applies to air-to-air missile loadouts only. For guns-only air-to-air loadouts and all air-to-ground loadouts the behaviour is the same as above. PREFERRED OPTION!</td></tr>
 <tr><td>ShotgunBVR</td><td>3001</td><td>Disengage after firing all Beyond Visual Range (BVR, air-to-air) or Stand-Off (SO, air-to-ground) weapons. This is a risky option as your fighter aircraft may only have one medium-range air-to-air missile (AAM) left, and attempt to engage 'fresh' flights of bogies. Use with caution.</td></tr>
 <tr><td>ShotgunBVR_WVR</td><td>3002</td><td>Same as above, but if easy targets or threats are nearby then shoot at them with remaining Within Visual Range (WVR, air-to-air) or SR (Short-Range, air-to-ground) weapons before disengaging.</td></tr>
 <tr><td>ShotgunBVR\_WVR\_Guns</td><td>3003</td><td>Same as above, but also engage bogies with guns. Applies to air-to-air (A/A) loadouts only. For air-to-ground (A/G) loadouts the behaviour is the same as above.</td></tr>
 <tr><td>ShotgunOneEngagementBVR</td><td>5001</td><td>Make one engagement with BVR or SO weapons. Continue fighting for as long as there are targets within easy reach and then disengage. This is a safe option as it ensures aircraft do not 'hang around' after they have expended their most potent weapons, and becoming easy targets when engaged by 'fresh' enemy units. </td></tr>
 <tr><td>ShotgunOneEngagementBVR\_Opportunity\_WVR</td><td>5002</td><td>Same as above, but if easy targets or threats are nearby, shoot at them with remaining WVR or Short-Range weapons before disengaging. A target is considered 'easy' when within 120% of the remaining WVR or Strike weapon's maximum range. In other words, the fighter won't spend much energy chasing down a target after the Shotgun weapon state has been reached, and will leave the target area as quickly as possible. PREFERRED OPTION!</td></tr>
 <tr><td>ShotgunOneEngagementBVR\_Opportunity\_WVR_Guns</td><td>5003</td><td>Same as above, but also engage bogies with guns. Applies to air-to-air (A/A) loadouts only. For air-to-ground (A/G) loadouts the behaviour is the same as above.</td></tr>
 <tr><td>ShotgunOneEngagementBVR\_And\_WVR</td><td>5005</td><td>Make one engagement with BVR and WVR, or SO and Strike Weapons. Do not disengage when out of BVR or SO weapons, but continue the engagement with WVR weapons.</td></tr>
 <tr><td>ShotgunOneEngagementBVR\_And\_WVR\_Opportunity\_Guns</td><td>5006</td><td> </td></tr>
 <tr><td>ShotgunOneEngagementWVR</td><td>5011</td><td>Make one engagement with WVR or SR weapons. Continue fighting for as long as there are targets within easy reach and then disengage.</td></tr>
 <tr><td>ShotgunOneEngagementWVR_Guns</td><td>5012</td><td>Same as above but also engage bogies with guns. Applies to air-to-air (A/A) loadouts only. For air-to-ground (A/G) loadouts, the behaviour is the same as above. PREFERRED OPTION!</td></tr>
 <tr><td>ShotgunOneEngagementGun</td><td>5021</td><td>Make one engagement with guns. Continue fighting for as long as there are targets nearby and then disengage.</td></tr>
 <tr><td>Shotgun25</td><td>4001</td><td>Disengage after 1/4 of mission-specific weapons have been expended.</td></tr>
 <tr><td>Shotgun25_ToO</td><td>4002</td><td>Same as above, but if easy targets or threats are nearby then shoot at those too. Also engage bogies with guns. Applies to air-to-air (A/A) loadouts only.</td></tr>
 <tr><td>Shotgun50</td><td>4011</td><td>Disengage after half of mission-specific weapons have been expended.</td></tr>
 <tr><td>Shotgun50_ToO</td><td>4012</td><td>Same as above, but if easy targets or threats are nearby then shoot at those too. Also engage bogies with guns. Applies to air-to-air (A/A) loadouts only.</td></tr>
 <tr><td>Shotgun75</td><td>4021</td><td>Disengage after 3/4 of mission-specific weapons have been expended.</td></tr>
 <tr><td>Shotgun75_ToO</td><td>4022</td><td>Same as above, but if easy targets or threats are nearby then shoot at those too. Also engage bogies with guns. Applies to air-to-air (A/A) loadouts only.</td></tr>
 </table></td></tr>
]]

--[[--
Set the doctrine of the designated object.

This function uses selector to find the thing to modify, then modifies the doctrine of that object based on the given object.
 Can be used to affect doctrine for Side, Mission, Unit/Group

@param[type=DoctrineSelector] selector The selector for the object to modify.
@param[type=Doctrine] doctrine A table of doctrines to update
@usage ScenEdit_SetDoctrine({side="Soviet Union"}, {kinematic_range_for_torpedoes = "AutomaticAndManualFire",use_nuclear_weapons= "yes" })
@usage ScenEdit_SetDoctrine({side="Soviet Union", mission="ASW PATROL"}, {kinematic_range_for_torpedoes = "AutomaticAndManualFire",use_nuclear_weapons= "yes" })
@usage ScenEdit_SetDoctrine({side="Soviet Union", unitname="Bear #2"}, {use_nuclear_weapons= "yes" })
]]
function ScenEdit_SetDoctrine(selector, doctrine) end

--[[--
Gets the doctrine of the designated object.

This function looks up the doctrine of the object selected by selector, and throws an exception if the unit does not exist.

@param[type=DoctrineSelector] selector The selector for the object to look up
@return[type=Doctrine] The doctrine of the selected object
@usage ScenEdit_GetDoctrine({side="Soviet Union"}).use_nuclear_weapons
]]
function ScenEdit_GetDoctrine(selector) end


--[[-- Selects a WRA doctrine.
  .. for on a side, group, mission, or unit.
 weapon_id is mandatory. One of side,mission,unitname or guid is mandatory. One of contact_id or target_type is mandatory

@Selector DoctrineWRASelector
@param[type=string] side The side to select/from
@param[type=string] mission The name of the mission to select
@param[type=string] unitname The name of the unit to select
@param[type=string] guid The unit GUID to select
@param[type=string] weapon_id The weapon database id
@param[type=string] contact_id  A contact GUID  (mutually exclusive with target_type)
@param[type=string] target_type The target type (mutually exclusive with contact_id)
]]


--[[-- WRA Doctrine options.


@Wrapper DoctrineWRA
@param[type=string] weapon_dbid Weapon number [info]
@param[type=string] weapon_name Weapon name [info]
@param[type=TargetTypeWRA] target_type Type of target [info]
@param[type=string] level The doctrine selected (at unit/mission/side) - useful Is just using GUIDs [info]
@param[type={ WRA }] wra The WRA doctrine
]]

--[[-- WRA settings.
 .. absence of fields implies that it is NOT used
@table  WRA
@param[type=string] qty_salvo Weapons per salvo ('Max' or a number)
@param[type=string] shooter_salvo Shooters per salvo ('Max' or a number)
@param[type=string] firing_range Firing range ('Max' or a number)
@param[type=string] self_defence Self-defence range ('Max' or a number)
]]

--[[-- Gets the WRA doctrine.

Returns the WRA setting In a table For the selected side/mission/unit based On the target type. 
Nothing returned Or empty values means that the weapon Is Not For the target type.

@param[type=DoctrineWRASelector] selector The selector for the object to look up
@return[type=DoctrineWRA] The WRA doctrine of the selected object
@usage ScenEdit_GetDoctrineWRA({guid = 'a1a52edf-3541-4b55-bea4-58d4e1ab11dc', contact_id='Boeing 747-8F #610', weapon_id=1575})
@usage ScenEdit_GetDoctrineWRA({side='sidea', target_type='Surface_Contact_Unknown_Type', weapon_id=1575})
]]
function ScenEdit_GetDoctrineWRA(selector) end

--[[-- >Sets the WRA doctrine.

Returns the WRA setting like GetDoctrineWRA

 The values below can be used in the option settings
 'inherit' = reverts to the side level setting
 'system' = reverts to the database level setting (does not apply to 'firing_range')
 'max' = use the appropriate maximum setting
 'none' = not to be used

@param[type=DoctrineWRASelector] selector The selector for the object to update
@param[type={ WRA }] options Table of settings {qty_salvo, shooter_salvo,firing_range,self_defence}. The order IS IMPORTANT as no keys used.
@return[type=DoctrineWRA] The WRA doctrine of the selected object
@usage ScenEdit_SetDoctrineWRA({guid = 'a1a52edf-3541-4b55-bea4-58d4e1ab11dc', target_type='Surface_Contact_Unknown_Type', weapon_id=1575}, {'inherit','inherit','system','inherit'})
@usage ScenEdit_SetDoctrineWRA({guid = 'a1a52edf-3541-4b55-bea4-58d4e1ab11dc', target_type='Surface_Contact_Unknown_Type', weapon_id=1575}, {'max','inherit',90,'inherit'})
]]
function ScenEdit_SetDoctrineWRA(selector, options) end

--[[-- Execute a Lua Event action script.
 .. but does not show results of execution of the action
 
@function ScenEdit_ExecuteEventAction
@param[type=string] EventDescriptionOrID The description or ID of the event action
@return[type=string] "Ok" on execution or nothing.
]]


--[[-- Gets the properties of an event.


@param[type=string] EventDescriptionOrID The event to retrieve
@param[type=number] level The detail required: 0 - full event,  (limit return to 1 - triggers, 2 - conditions, 3 - actions, 4 - event)
@return[type=Event] The event details
]]
function ScenEdit_GetEvent(EventDescriptionOrID, level)end

--[[-- Gets all events.


@param[type=number] level The detail required: 0 - full event,  (limit return to 1 - triggers, 2 - conditions, 3 - actions, 4 - event)
@return[type= { Event} ] Table of event details
]]
function ScenEdit_GetEvents( level)end


--[[--
Special action selector.

@Selector SpecialAction
@param[type=string] GUID The GUID of the special action [READONLY]
@param[type=string] ActionNameOrID The name or ID of the special action
@param[type=bool] IsActive If the action is visible to the player
@param[type=bool] IsRepeatable If the player can use the action multiple times
@param[type=string] NewName If specified, the new name of the action
@param[type=string] Description If specified, the new description for the action
]]


--[[--
Sets the properties of an existing special action.

@param[type=SpecialAction] action_info The special action to modify
]]
function ScenEdit_SetSpecialAction(action_info)end

--[[--
Gets the properties of an existing special action.

@param[type=SpecialAction] action_info The special action to retrieve
]]
function ScenEdit_GetSpecialAction(action_info)end

--[[-- Execute a Lua Special action script
 .. but does not show results of execution of the action
 
@function ScenEdit_ExecuteSpecialAction
@param[type=string] eventNameOrId The name or ID of the event action
@return[type=string] "Ok" on execution or nothing.
]]



--[[-- Event update.

@Selector EventUpdate
@param[type=string] ID The GUID of the event [READONLY]
@param[type=string] Description If specified, the new description for the event
@param[type=string] NewName If specified, the new name of the event
@param[type=bool] IsActive If the event is active
@param[type=bool] IsRepeatable If the event can occur multiple times
@param[type=bool] IsShown If the event is shown in message log
@param[type=integer] Probability Chance of it happening
@param[type=string] Mode Operation to do - 'add', 'update' (default) SE_SetEvent()
]]

--[[-- Sets the attributes of an event.


@param[type=string] EventDescriptionOrID The event name/GUID to perform operation on
@param[type={ EventUpdate }] options The event options 
@return[type={ table } ] Table of event options (new or previous value)
]]
function ScenEdit_SetEvent(EventDescriptionOrID, options)end


--[[-- Trigger update.

@Selector TriggerUpdate
@param[type=string] ID The GUID of the trigger [READONLY]
@param[type=string] Description Description or GUID of trigger
@param[type=string] NewName If specified, the new name of the trigger
@param[type=string] Mode Operation to do - 'list', 'add', 'remove', 'update' (default) SE_Set...()
@param[type=string] Type Type of trigger [required only for 'add' option]
@param[type=various] Other values apply to Type of trigger.
]]

--[[-- Sets the attributes of a trigger.


@param[type={ TriggerUpdate }] options The trigger options 
@return[type={ table } ] Table of trigger options (new or previous value)
]]
function ScenEdit_SetTrigger( options)end


--[[-- Condition update.

@Selector ConditionUpdate
@param[type=string] ID The GUID of the condition [READONLY]
@param[type=string] Description Description or GUID of condition
@param[type=string] NewName If specified, the new name of the condition
@param[type=string] Mode Operation to do - 'list', 'add', 'remove', 'update' (default) SE_Set...()
@param[type=string] Type Type of condition [required only for 'add' option]
@param[type=various] Other values apply to Type of condition.
]]

--[[-- Sets the attributes of an condition.


@param[type={ ConditionUpdate }] options The condition options 
@return[type={ table } ] Table of condition options (new or previous value)
]]
function ScenEdit_SetCondition( options)end


--[[-- Action update.

@Selector ActionUpdate
@param[type=string] ID The GUID of the action [READONLY]
@param[type=string] Description Description or GUID of action
@param[type=string] NewName If specified, the new name of the action
@param[type=string] Mode Operation to do - 'list', 'add', 'remove', 'update' (default) SE_Set...()
@param[type=string] Type Type of action [required only for 'add' option]
@param[type=various] Other values apply to Type of action.
]]

--[[-- Sets the attributes of an action.


@param[type={ ActionUpdate }] options The action options 
@return[type={ table } ] Table of action options (new or previous value)
]]
function ScenEdit_SetAction( options)end


--[[-- Event Trigger/Condition/Action update.

@Selector EventTCAUpdate
@param[type=string] GUID The GUID of the trigger
@param[type=string] Description The description or ID of the T/C/A
@param[type=string] Mode Operation to do - 'add', 'remove', replace', 'update' (default) SE_Set...()
]]

--[[-- Sets the attributes of a T/C/A.


@param[type=string] EventDescriptionOrID The trigger name/GUID to perform operation on
@param[type={ EventTCAUpdate }] options The options 
@return[type={ table } ] Table of options (new or previous value)
]]
function ScenEdit_SetEventTrigger(EventDescriptionOrID, options)end
]]

--[[-- Sets the attributes of a T/C/A.


@param[type=string] EventDescriptionOrID The condition name/GUID to perform operation on
@param[type={ EventTCAUpdate }] options The options 
@return[type={ table } ] Table of options (new or previous value)
]]
function ScenEdit_SetEventCondition(EventDescriptionOrID, options)end
]]

--[[-- Sets the attributes of a T/C/A.


@param[type=string] EventDescriptionOrID The action name/GUID to perform operation on
@param[type={ EventTCAUpdate }] options The options 
@return[type={ table } ] Table of options (new or previous value)
]]
function ScenEdit_SetEventAction(EventDescriptionOrID, options)end

--[[--
Imports an inst file.

@param[type=string] side The side to import the inst file as
@param[type=string] filename The filename of the inst file
]]
function ScenEdit_ImportInst(side, filename) end

--[[--
Export unit(s) to an inst file.

@param[type=string] side The side to import the inst file as
@param[type=table] unitList list of unit(s) to create as INST file
@param[type=table] fileData Table of { filename, name, comment } for the INST file
]]
function ScenEdit_ExportInst(side, unitList, fileData) end


--[[-- Get details of a mission.

@function ScenEdit_GetMission
@param[type=string] SideNameOrId The mission side
@param[type=string] MissionNameOrId The mission name
@return[type=Mission] A mission descriptor if the mission exists or nil otherwise.
@usage local mission = ScenEdit_GetMission('USA','CV CAP Left')
]]


--[[-- New mission options.

@Selector NewMission
@field[type=string] type Mission sub-type (Applies to Patrol and Strike)
@field[type=string] destination Ferry mission destination
@field[type={ string }] zone A table of reference points as names or GUIDs (Can apply to Patrol, Support, Mining, Cargo)
]]

--[[-- Add new mission.

@function ScenEdit_AddMission
@param[type=string] SideNameOrId The mission side
@param[type=string] MissionNameOrId The mission name
@param[type=string] MissionType The mission type (Strike, Ferry, Patrol, etc)
@param[type=NewMission] MissionOptions The mission specific options as a table
@return[type=Mission] A mission descriptor of the added mission or nil otherwise.
@usage local mission = ScenEdit_AddMission('USA','Marker strike','strike',{type='land'})
]]

]]

--[[-- Delete mission.
 .. unassigns any units attached to it.
@function ScenEdit_DeleteMission
@param[type=string] SideNameOrId The mission side
@param[type=string] MissionNameOrId The mission name
@return[type=bool] True if mission has been removed.
@usage local mission = ScenEdit_AddMission('USA','Marker strike','strike',{type='land'})
]]

]]

--[[-- Export mission parameters.
 .. as a XML file in folder Command_base/Defaults.
 [Experimental as this should really be treated like an attachment so can be imported with Scenario]
@function ScenEdit_ExportMission
@param[type=string] SideNameOrId The mission side
@param[type=string] MissionNameOrId The mission name
@return[type={ guid }] Mission GUID exported.
@usage local mission = ScenEdit_ExportMission('USA','Marker strike'})
]]

]]

--[[-- Import mission parameters.
 .. from a XML file in folder Command_base/Defaults.
 [Experimental as this should really be treated like an attachment so can be imported with Scenario]
@function ScenEdit_ImportMission
@param[type=string] SideNameOrId The mission side
@param[type=string] MissionNameOrId The mission name
@return[type={ guid }] Mission GUID imported.
@usage local mission = ScenEdit_ExportMission('USA','Marker strike'})
]]


--[[-- Set details for a mission.

@function ScenEdit_SetMission
@param[type=string] SideName The mission side
@param[type=string] MissionNameOrId The mission name
@param[type=Mission] MissionOptions The mission options as a table.
@return[type=Mission] A mission descriptor if the mission exists or nil otherwise.
@usage local mission = ScenEdit_SetMission('USA','CV CAP Left',{TankerUsage=1,OnStation=2})
]]


--[[-- Assigns targets to a Strike mission.

 'UnitX' can be used as a unit descriptor.
 Contacts can also be assigned. Refer to the VP_ functions for details
@function ScenEdit_AssignUnitAsTarget
@param[type=string|table] AUNameOrIDOrTable The name/GUID of the unit, or a table of `name/GUID` to add to target list
@param[type=string] MissionNameOrID The mission to update
@return[type={ GUID } ] A table of targets added
@usage ScenEdit_AssignUnitAsTarget({'target1', 'target2'}, 'Land strike')
@usage ScenEdit_AssignUnitAsTarget('UnitX', 'Land strike')
]]


--[[-- Removes targets from a Strike mission.

The 'UnitX' can be used as a unit descriptor
@function ScenEdit_RemoveUnitAsTarget
@param[type=string|table] AUNameOrIDOrTable The name/GUID of the unit, or a table of `name/GUID` to remove from target list
@param[type=string] MissionNameOrID The mission 
@return[type={ GUID } ] A table of targets removed
@usage ScenEdit_RemoveUnitAsTarget({'target1', 'target2'}, 'Land strike')
]]

--[[-- Reference point selector.

To select reference point(s), specify either

* `name` and `side`, to select a reference point `name` belonging to `side` [name AND side if possible] or
* `guid`, if the unique ID of the reference point is known [preferred] or
* `area`, table of reference points (name or guid)

 GUID method takes precedence over name/side if both present.

@Selector ReferencePointSelector
@field[type=string] side The side the reference point is visible to
@field[type=string] name The name of the reference point
@field[type=string] guid The unique identifier for the reference point
@field[type={name|guid}] area Table of reference points by name and/or guid (used with the Set()/Get() functions)
]]

--[[-- Add new reference point(s).

This function adds new reference point(s) as defined by a descriptor. 
As this function also calls ScenEdit_SetReferencePoint() at the end, those parameters can also be passed in this function.<br>
It can take a new referrnce point, or a table of new reference points.
The descriptor <b>must</b> contain at least a side, and one set of latitude and longitude, or an area defined by one or more latitude and longitude values.
Points can also be relative to a unit based on bearing and distence. This applies to ALL bearing type rp(s) in the function.
 Field = RelativeTo The unit name/GUID that the RP(s) are relative to

@param[type=ReferencePointSelector|{ReferencePoint}] descriptor The reference point details to be created.
Field 'area' can be <br>(a) Table of reference points {name, longitude, latitude} if 'RelativeTo' not used, or <br>
(b) table of reference points {name, bearing, distance} if 'RelativeTo' used.<br> 
Leaving out name will default it to noraml 'RP-..'
@usage ScenEdit_AddReferencePoint( {side="United States", name="Downed Pilot", lat=0.1, lon=4, highlighted=true})
@usage ScenEdit_AddReferencePoint( {side='sidea', RelativeTo='USN Dewey', bearing=45 ,distance=20, clear=true })
@return[type=ReferencePoint] The reference point wrapper for the new reference point, or the first one in an area.
]]
function ScenEdit_AddReferencePoint(descriptor) end

--[[-- Update a reference point(s) with new values.
 
Given a valid @{ReferencePointSelector} as part of the descriptor, the function wil update the values contained in the descriptor. Values may be omitted from the descriptor if they are intended to remain unmodified. 
The 'area' selector is useful for changing some common attribute, like locking or highlighting, in bulk.
 
 Additional key=value options are; <br>
  NEWNAME='string' to rename a reference point <br>
  TOGGLEHIGHLIGHTED = True to flip the reference point(s) highlight <br>
  CLEAR = True to remove the 'relative to' of the reference point(s)
 
@param[type=ReferencePoint] descriptor A valid selector with other values to update.
@return[type=ReferencePoint] The reference point descriptor for the reference point or first one in the area.
@usage ScenEdit_SetReferencePoint({side="United States", name="Downed Pilot", lat=0.5})
@usage ScenEdit_SetReferencePoint({side="United States", name="Downed Pilot", lat=0.5, lon="N50.50.50", highlighted = true})
@usage ScenEdit_SetReferencePoint({side="United States", area={"rp-100","rp-101","rp-102","rp-103","rp-104"}, highlighted = true})
]]
function ScenEdit_SetReferencePoint(descriptor) end
 
--[[-- Get a set of reference point(s).
 
Given a reference point selector, the function will return a table of the reference point descriptors.
@param[type=ReferencePointSelector] selector 
@return[type={ReferencePoint}] The table of reference point descriptors for the selector
@usage local points = ScenEdit_GetReferencePoints({side="United States", area={"rp-100","rp-101","rp-102","rp-103","rp-104"})
]]
function ScenEdit_GetReferencePoints(selector) end

--[[-- Delete a reference point.
 
Given a reference point selector, this function will remove it.
@param[type=ReferencePointSelector] selector The reference point to delete.
@return[type=bool] True if deleted
]]
function ScenEdit_DeleteReferencePoint(selector) end

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


--[[-- A Position on the map.
 ... is referred to with latitude (north/south) and longitude (east/west) coordinates. 
These can be represented in two forms, degrees minutes seconds, and decimal degrees. The Command Lua API supports both forms.

A set of latitude & longitude to define a point. Within the simulation, the values are recorded in decimal degrees.
@table LatLon
@param[type=number] latitude 
@param[type=number] longitude
]]

--[[-- Latitude.
 ... is degrees N or S of the equator as 'S 60.20.10' or as +/- as -60.336. The data in the tables is held as a signed number.

@DataType Latitude
]]
Latitude()


--[[-- Longitude.
 ... is degrees E or W of Greenwich line as 'W 60.20.10' or  as +/- as -60.336. The data in the tables is held as a signed number.
@DataType Longitude
]]
Longitude()


--[[-- Altitude.
 ... is the height or depth of a unit.
 The altitude is displayed in meters when accessing the data. It can be set using either meters or feet by adding M or FT after it. The default is M if just a number is used.
@DataType Altitude
@usage {altitude='100 FT'} or {altitude='100 M'} or {altitude='100'}
]]
Altitude()


--[[-- TimeStamp.
 ... is a representation of time defined as the number of seconds that have elapsed since 00:00:00 Coordinated Universal Time (UTC), Thursday, 1 January 1970

@DataType TimeStamp
]]
TimeStamp()


--[[-- KeyStore.
The simulation allows for user data to be stored within the save file. This is done by associating `keys` with `values`.
Key/value pairs added to the persistent store is retained when the game is saved and resumed. Keys and values are both represented as non-nil strings.

@param[type=string] key The key to associate the value with
@param[type=string] value The value to keep
@DataType KeyStore
]]
KeyStore()
--[[-- Stance/Posture.
 ... how one side sees another.

 When setting the value, either the number or the description (in quotes) can be used.
@DataType Stance
 Stance codes:

 <style>
 tr:not(:first-child) { border-top: 1px solid black;}
 td { padding: .5em; }
 </style>
 <table style="border-spacing: 0.5rem;">
 <tr><td>0</td><td>Neutral</td></tr>
 <tr><td>1</td><td>Friendly</td></tr>
 <tr><td>2</td><td>Unfriendly</td></tr>
 <tr><td>3</td><td>Hostile</td></tr>
 <tr><td>4</td><td>Unknown</td></tr>
 </table>

]]
Stance()
--[[-- Size.
 ... various size attributes (eg flightsize in mission).

 When setting the value, either the number or the description (in quotes) can be used.
@DataType Size

 Flight size:
 <style>
 tr { border: 1px solid black;}
 td { padding: .5em; }
 </style>
 <table style="border-spacing: 0.5rem;">
 <tr><td>0</td><td>None*</td></tr>
 <tr><td>1</td><td>SingleAircraft</td></tr>
 <tr><td>2</td><td>TwoAircraft</td></tr>
 <tr><td>3</td><td>ThreeAircraft</td></tr>
 <tr><td>4</td><td>FourAircraft</td></tr>
 <tr><td>6</td><td>SixAircraft</td></tr>
 </table>

 Flight quantity:
 <table style="border-spacing: 0.5rem;">
 <tr><td>0</td><td>None</td></tr>
 <tr><td>1</td><td>Flight_x1</td></tr>
 <tr><td>2</td><td>Flight_x2</td></tr>
 <tr><td>3</td><td>Flight_x3</td></tr>
 <tr><td>4</td><td>Flight_x4</td></tr>
 <tr><td>6</td><td>Flight_x6</td></tr>
 <tr><td>8</td><td>Flight_x8</td></tr>
 <tr><td>12</td><td>Flight_x12</td></tr>
 <tr><td>All</td><td>All</td></tr>
 </table>

 Group size:
 <table style="border-spacing: 0.5rem;">
 <tr><td>0</td><td>None*</td></tr>
 <tr><td>1</td><td>SingleVessel</td></tr>
 <tr><td>2</td><td>TwoVessel</td></tr>
 <tr><td>3</td><td>ThreeVessel</td></tr>
 <tr><td>4</td><td>FourVessel</td></tr>
 <tr><td>6</td><td>SixVessel</td></tr>
 </table>

 *This can also be set by using a value of 'all'.

]]
Size()
--[[-- Arcs.
 ... for sensor and mounts.

@DataType Arc
 Arc codes:
<p><img src="http://www.matrixgames.com/forums/upfiles/53563/BF0B90019F484D5CA313DC41D5B13F46.jpg" alt="Arc codes"/><p>

]]
Arc()
--[[-- Target type.
 

@DataType TargetTypeWRA

 <style>
 tr { border: 1px solid black;}
 td { padding: .5em; }
 </style>
 <table style="border-spacing: 0.5rem;">
<tr><td>None </td><td> 1001</td></tr>
<tr><td>Decoy </td><td> 1002</td></tr>
<tr><td>Air\_Contact\_Unknown\_Type </td><td> 1999</td></tr>
<tr><td>Aircraft\_Unspecified </td><td> 2000</td></tr>
<tr><td>Aircraft\_5th\_Generation </td><td> 2001</td></tr>
<tr><td>Aircraft\_4th\_Generation </td><td> 2002</td></tr>
<tr><td>Aircraft\_3rd\_Generation </td><td> 2003</td></tr>
<tr><td>Aircraft\_Less\_Capable </td><td> 2004</td></tr>
<tr><td>Aircraft\_High\_Perf\_Bombers </td><td> 2011</td></tr>
<tr><td>Aircraft\_Medium\_Perf\_Bombers </td><td> 2012</td></tr>
<tr><td>Aircraft\_Low\_Perf\_Bombers </td><td> 2013</td></tr>
<tr><td>Aircraft\_High\_Perf\_Recon\_EW </td><td> 2021</td></tr>
<tr><td>Aircraft\_Medium\_Perf\_Recon\_EW </td><td> 2022</td></tr>
<tr><td>Aircraft\_Low\_Perf\_Recon\_EW </td><td> 2023</td></tr>
<tr><td>Aircraft\_AEW </td><td> 2031</td></tr>
<tr><td>Helicopter\_Unspecified </td><td> 2100</td></tr>
<tr><td>Guided\_Weapon\_Unspecified </td><td> 2200</td></tr>
<tr><td>Guided\_Weapon\_Supersonic\_Sea\_Skimming </td><td> 2201</td></tr>
<tr><td>Guided\_Weapon\_Subsonic\_Sea\_Skimming </td><td> 2202</td></tr>
<tr><td>Guided\_Weapon\_Supersonic </td><td> 2203</td></tr>
<tr><td>Guided\_Weapon\_Subsonic </td><td> 2204</td></tr>
<tr><td>Guided\_Weapon\_Ballistic </td><td> 2211</td></tr>
<tr><td>Satellite\_Unspecified </td><td> 2300</td></tr>
<tr><td>Surface\_Contact\_Unknown\_Type </td><td> 2999</td></tr>
<tr><td>Ship\_Unspecified </td><td> 3000</td></tr>
<tr><td>Ship\_Carrier\_0\_25000\_tons </td><td> 3001</td></tr>
<tr><td>Ship\_Carrier\_25001\_45000\_tons </td><td> 3002</td></tr>
<tr><td>Ship\_Carrier\_45001\_95000\_tons </td><td> 3003</td></tr>
<tr><td>Ship\_Carrier\_95000\_tons </td><td> 3004</td></tr>
<tr><td>Ship\_Surface\_Combatant\_0\_500\_tons </td><td> 3101</td></tr>
<tr><td>Ship\_Surface\_Combatant\_501\_1500\_tons </td><td> 3102</td></tr>
<tr><td>Ship\_Surface\_Combatant\_1501\_5000\_tons </td><td> 3103</td></tr>
<tr><td>Ship\_Surface\_Combatant\_5001\_10000\_tons </td><td> 3104</td></tr>
<tr><td>Ship\_Surface\_Combatant\_10001\_25000\_tons </td><td> 3105</td></tr>
<tr><td>Ship\_Surface\_Combatant\_25001\_45000\_tons </td><td> 3106</td></tr>
<tr><td>Ship\_Surface\_Combatant\_45001\_95000\_tons </td><td> 3107</td></tr>
<tr><td>Ship\_Surface\_Combatant\_95000\_tons </td><td> 3108</td></tr>
<tr><td>Ship\_Amphibious\_0\_500\_tons </td><td> 3201</td></tr>
<tr><td>Ship\_Amphibious\_501\_1500\_tons </td><td> 3202</td></tr>
<tr><td>Ship\_Amphibious\_1501\_5000\_tons </td><td> 3203</td></tr>
<tr><td>Ship\_Amphibious\_5001\_10000\_tons </td><td> 3204</td></tr>
<tr><td>Ship\_Amphibious\_10001\_25000\_tons </td><td> 3205</td></tr>
<tr><td>Ship\_Amphibious\_25001\_45000\_tons </td><td> 3206</td></tr>
<tr><td>Ship\_Amphibious\_45001\_95000\_tons </td><td> 3207</td></tr>
<tr><td>Ship\_Amphibious\_95000\_tons </td><td> 3208</td></tr>
<tr><td>Ship\_Auxiliary\_0\_500\_tons </td><td> 3301</td></tr>
<tr><td>Ship\_Auxiliary\_501\_1500\_tons </td><td> 3302</td></tr>
<tr><td>Ship\_Auxiliary\_1501\_5000\_tons </td><td> 3303</td></tr>
<tr><td>Ship\_Auxiliary\_5001\_10000\_tons </td><td> 3304</td></tr>
<tr><td>Ship\_Auxiliary\_10001\_25000\_tons </td><td> 3305</td></tr>
<tr><td>Ship\_Auxiliary\_25001\_45000\_tons </td><td> 3306</td></tr>
<tr><td>Ship\_Auxiliary\_45001\_95000\_tons </td><td> 3307</td></tr>
<tr><td>Ship\_Auxiliary\_95000\_tons </td><td> 3308</td></tr>
<tr><td>Ship\_Merchant\_Civilian\_0\_500\_tons </td><td> 3401</td></tr>
<tr><td>Ship\_Merchant\_Civilian\_501\_1500\_tons </td><td> 3402</td></tr>
<tr><td>Ship\_Merchant\_Civilian\_1501\_5000\_tons </td><td> 3403</td></tr>
<tr><td>Ship\_Merchant\_Civilian\_5001\_10000\_tons </td><td> 3404</td></tr>
<tr><td>Ship\_Merchant\_Civilian\_10001\_25000\_tons </td><td> 3405</td></tr>
<tr><td>Ship\_Merchant\_Civilian\_25001\_45000\_tons </td><td> 3406</td></tr>
<tr><td>Ship\_Merchant\_Civilian\_45001\_95000\_tons </td><td> 3407</td></tr>
<tr><td>Ship\_Merchant\_Civilian\_95000\_tons </td><td> 3408</td></tr>
<tr><td>Submarine\_Surfaced </td><td> 3501</td></tr>
<tr><td>Subsurface\_Contact\_Unknown\_Type </td><td> 3999</td></tr>
<tr><td>Submarine\_Unspecified </td><td> 4000</td></tr>
<tr><td>Land\_Contact\_Unknown\_Type </td><td> 4999</td></tr>
<tr><td>Land\_Structure\_Soft\_Unspecified </td><td> 5000</td></tr>
<tr><td>Land\_Structure\_Soft\_Building\_Surface </td><td> 5001</td></tr>
<tr><td>Land\_Structure\_Soft\_Building\_Reveted </td><td> 5002</td></tr>
<tr><td>Land\_Structure\_Soft\_Structure\_Open </td><td> 5005</td></tr>
<tr><td>Land\_Structure\_Soft\_Structure\_Reveted </td><td> 5006</td></tr>
<tr><td>Land\_Structure\_Soft\_Aerostat\_Moring </td><td> 5011</td></tr>
<tr><td>Land\_Structure\_Hardened\_Unspecified </td><td> 5100</td></tr>
<tr><td>Land\_Structure\_Hardened\_Building\_Surface </td><td> 5101</td></tr>
<tr><td>Land\_Structure\_Hardened\_Building\_Reveted </td><td> 5102</td></tr>
<tr><td>Land\_Structure\_Hardened\_Building\_Bunker </td><td> 5103</td></tr>
<tr><td>Land\_Structure\_Hardened\_Building\_Underground </td><td> 5104</td></tr>
<tr><td>Land\_Structure\_Hardened\_Structure\_Open </td><td> 5105</td></tr>
<tr><td>Land\_Structure\_Hardened\_Structure\_Reveted </td><td> 5106</td></tr>
<tr><td>Runway\_Facility\_Unspecified </td><td> 5200</td></tr>
<tr><td>Runway </td><td> 5201</td></tr>
<tr><td>Runway\_Grade\_Taxiway </td><td> 5202</td></tr>
<tr><td>Runway\_Access\_Point </td><td> 5203</td></tr>
<tr><td>Radar\_Unspecified </td><td> 5300</td></tr>
<tr><td>Mobile\_Target\_Soft\_Unspecified </td><td> 5400</td></tr>
<tr><td>Mobile\_Target\_Soft\_Mobile\_Vehicle </td><td> 5401</td></tr>
<tr><td>Mobile\_Target\_Soft\_Mobile\_Personnel </td><td> 5402</td></tr>
<tr><td>Mobile\_Target\_Hardened\_Unspecified </td><td> 5500</td></tr>
<tr><td>Mobile\_Target\_Hardened\_Mobile\_Vehicle </td><td> 5501</td></tr>
<tr><td>Underwater\_Structure </td><td> 5601</td></tr>
<tr><td>Air\_Base\_Single\_Unit\_Airfield </td><td> 5801</td></tr>
 </table>

]]
TargetTypeWRA()

--[[-- Select a unit.
 ... based on either the side and name or the unique identifier (GUID).

You can use either
1. `name` and `side`
2. `guid`
If both are given, then the GUID is used preferentially.

@field[type=string] name The name of the unit to select (for option #1)
@field[type=string] side The name of the unit to select (for option #1)
@field[type=string] guid The guid of the unit to select (for option #2)
@Selector UnitSelector
]]


--[[-- Defines the warhead to detonate.


@table Explosion
@param[type=number] warheadid The ID of the warhead to detonate
@param[type=Latitude] lat The latitude of the detonation
@param[type=Longitude] lon The longitude of the detonation
@param[type=Altitude] altitude The altitude of the detonation
@usage {warheadid=253, lat=unit.latitude, lon=unit.longitude, altitude=unit.altitude}
]]


--[[-- Detonates a warhead at a specified location.


@function ScenEdit_AddExplosion
@param[type=Explosion] explosion Describes the explosion.
@usage ScenEdit_AddExplosion ({warheadid=253, lat=unit.latitude, lon=unit.longitude, altitude=unit.altitude})
]]


--[[--
Requests that a unit be hosted/based to another

@param[type=string] HostedUnitNameOrID The name or GUID of the unit to put into the host
@param[type=string] SelectedHostNameOrID The name or GUID of the host to put the unit into
 use SetUnit() with 'base=xxx' to assign the unit to a 'base'
]]
HostUnit = {
	HostedUnitNameOrID,
	SelectedHostNameOrID
}


--[[-- Host/base
 .. to the specified host. 
 SelectedHostNameOrID' option: the unit will be moved from any location, including flying, to the new location. 

@param[type=HostUnit] host_info The information about the hosting request
]]
function ScenEdit_HostUnitToParent(host_info)end


--[[-- Assign a unit to a mission.

The function takes a unit and mission descriptor, and assigns the unit to the mission if it exists. Produces a pop up
error (not catchable) if the unit or mission does not exist.
The 'UnitX' can be used as the unit descriptor
@param[type=string] unitname The name/GUID of the unit to assign
@param[type=string] mission The mission name/GUID to use
@param[type=bool] escort [Default=False] If the mission is a strike one, then assign unit to the 'Escort' for the strike
@return[type=boolean] True/False for Successful/Failure
@usage ScenEdit_AssignUnitToMission("Bar #1", "Strike")
]]
function ScenEdit_AssignUnitToMission(unitname, mission[, escort]) end


--[[--
Information on a loadout to add/alter

@param[type=string] UnitName The name/GUID of the unit to change the loadout on
@param[type=number] LoadoutID The ID of the new loadout; 0 = use the current loadout
@param[type=number,opt] TimeToReady_Minutes How many minutes until the loadout is ready (default = database loadout time)
@param[type=bool,opt] IgnoreMagazines If the new loadout should rely on the magazines having the right weapons ready (default = false)
@param[type=bool,opt] ExcludeOptionalWeapons Exclude optional weapons from loadout  (default = false)
]]
LoadoutInfo = {
	UnitName, 
	LoadoutID, 
	TimeToReady_Minutes, 
	IgnoreMagazines,
 ExcludeOptionalWeapons
}


--[[--
Sets the loadout for a unit

@param[type=LoadoutInfo] loadoutinfo The loadout information to apply
@return[type=bool] True
]]
function ScenEdit_SetLoadout(loadoutinfo)end


--[[-- Set the current weather conditions.

This function takes four numbers that describe the desired weather conditions. These
conditions are applied globally.
@param[type=number] temperature The current baseline temperature (in deg C). Varies by latitude.
@param[type=number] rainfall The rainfall rate, 0-50.
@param[type=number] undercloud The amount of sky that is covered in cloud, 0.0-1.0
@param[type=number] seastate The current sea state 0-9.
@return[type=boolean] True/False for Successful/Failure
@usage ScenEdit_SetWeather(math.random(0,25), math.random(0,50), math.random(0,10)/10.0, math.random(0,9))
]]
function ScenEdit_SetWeather(temperature, rainfall, undercloud, seastate) end


--[[-- weather conditions.

@DataType Weather
@field[type=number] temp Temperature (average for GetWeather(), or time-of-day for unit/contact)
@field[type=number] rainfall Rainfall rate
@field[type=number] undercloud Fraction under cloud
@field[type=number] seastate  Sea state

]]

--[[-- Get the current weather conditions.


@return[type=table] Table of weather parameters [temp (average), rainfall, undercloud, seastate]
@usage ScenEdit_GetWeather()
]]
function ScenEdit_GetWeather() end


--[[-- Set the posture of a side towards another.

 This will set side A's posture towards side B to the specified posture. This is the same as @{Stance}, but only the first character of the name is used as shown in the table
 
 Posture codes:
 <style>
 tr:not(:first-child) { border-top: 1px solid black;}
 td { padding: .5em; }
 </style>
 <table style="border-spacing: 0.5rem;">
 <tr><td>F</td><td>Friendly</td></tr>
 <tr><td>H</td><td>Hostile</td></tr>
 <tr><td>N</td><td>Neutral</td></tr>
 <tr><td>U</td><td>Unfriendly</td></tr>
 </table>

 @param[type=string] sideAName Side A's name or GUID
 @param[type=string] sideBName Side B's name or GUID
 @param[type=string] posture The posture of side A towards side B
@return[type=boolean] True/False for Successful/Failure
 @usage ScenEdit_SetSidePosture("LuaSideA", "LuaSideB", "H")
]]
function ScenEdit_SetSidePosture(sideAName, sideBName, posture) end


--[[-- Set side options.
 ... AWARENESS and PROFICIENCY.

@function ScenEdit_SetSideOptions(options)
@param[type=SideOptions] options The side items to be changed.
@return[type={ SideOption }] The side options
@usage ScenEdit_SetSideOptions('{side='SideA',awareness='OMNI',PROFICIENCY='ace')
]]

--[[-- Fill a unit's magazine(s) with aircraft stores
 ... for a specified loadout ID.

@function ScenEdit_FillMagsForLoadout(options)
@param[type=UnitSelector] unit The unit to select (name or GUID)
@param[type=number] loadoutid ID of the desired loadout
@param[type=number] quantity How many 'packs' of the specified loadout to populate for
@return[ {results} ] List of reports for successful (or not) additions
@usage ScenEdit_FillMagsForLoadout('{unit='RAF Lakenheath', loadoutid=45162, quantity=12}')
]]

--[[-- Unit damage.
 The component table list consists of entries for each component, identified by guid and new level. Special cases: <br>
 - if guid is 'type', then you can set a type of component to be damaged,<br>
 - if damageLevel is 'none', then the component will be repaired.
@usage components={{'16a883a2-8e7f-4313-aae7-0af644c16337','none'},{'rudder','Medium'},{'type',type='sensor',1}}}')

@Selector DamageOptions
@field[type=string] side 
@field[type=string] unitname 
@field[type=string] guid 
@field[type=string] fires 
@field[type=string] flood 
@field[type=number] dp Damage points
@field[type={ table }] components Table of component damage setting { guid, damageLevel }
]]

--[[-- Set unit damage.
 ... for components on unit.

@function ScenEdit_SetUnitDamage(options)
@param[type=DamageOptions] options 
@return[type=Component] The unit's components object
@usage ScenEdit_SetUnitDamage({side='SideA', unitname='Ship', fires=1, components={ {'rudder','Medium'}, {'type',type='sensor',1} } })
]]

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
function ScenEdit_SetEMCON(type, name, emcon)end

--[[--
Show a message box with a passed string.

@param[type=string] string The string to display to the user
@param[type=num] style The style of the message box
@return button number pressed.

 Style numbers
 1 = OK and Cancel buttons.
 2 = Abort, Retry, and Ignore buttons.
 3 = Yes, No, and Cancel buttons
 4 = Yes and No buttons.
 5 = Retry and Cancel buttons.

]]
function ScenEdit_MsgBox(string, style) end

--[[--
Open an input box with the passed prompt.

@param[type=string] string The string to display to the user
@return Data entered into box
]]
function ScenEdit_InputBox(string) end


--[[--
Get a given side's score.

@param[type=string] side The name of the side
@return[type=num] The side's score
@usage ScenEdit_GetScore("PlayerSide")
]]
function ScenEdit_GetScore(side)end


--[[--
Gets the posture of one side towards another. 

@param[type=string] sideA The name of the first side
@param[type=string] sideB The name of the second side
@return The posture of sideA towards sideB, one of 'N', 'F', 'H', or 'A'.
]]
function ScenEdit_GetSidePosture(sideA,sideB) end


--[[--
Information to select a particular side. 

@param[type=string] GUID The GUID of the side to select. Preferred.
@param[type=string] Name The name of the side to select.
]]
SideSelector = {
	GUID,
	Name
}

--[[-- Side options.

@Selector SideOption
@field[type=string}] side Side name
@field[type=string}] guid Side guid
@field[type=string}] awareness Side awareness
@field[type=string}] proficiency Side proficiency
@field[type=bool}] switchto Change game side to above (only applicable with SetSideOptions)
]]


--[[-- Get side options.
 ... for components on unit.

@function ScenEdit_GetSideOptions(options)
@param[type=SideSelector] options 
@return[type={ SideOption }] The side options
@usage ScenEdit_GetSideOptions({side='SideA'})
]]

--[[--
Returns true if side is played by a human player

@param[type=string] sidename The name of the side to check if is human controlled
@return True iff the side specified is human
]]
function ScenEdit_GetSideIsHuman(sidename)end


--[[--
Sets a given side's score.

@param[type=string] side The name/GUID of the side
@param[type=num] score The new score for the side
@param[type=string] reason The reason for the score to change
@return[type=num] The new score for the side
@usage ScenEdit_GetScore("PlayerSide", 20)
]]
function ScenEdit_SetScore(side,score,reason) end


--[[--
	Displays a special message consisting of the HTML text `message` to side `side.

@param[type=string] side The side name/guid to display the message on
@param[type=string] message The HTML text to display to the player
]]
function ScenEdit_SpecialMessage(side, message) end

--[[-- New unit selector.

 ... lists minimum fields required. Other fields from @{Unit} may be included.

@Selector NewUnit
@field[type=string] type The type of unit (Ship, Sub, Aircraft, Facility, Satellite)
@field[type=string] unitname The name of the unit 
@field[type=string] side The side name or GUID to add unit to
@field[type=number] dbid The database id of the unit
@field[type=Latitude] latitude Not required if a `base` is defined
@field[type=Longitude] longitude Not required if a `base` is defined
@field[type=string] base Unit base name or GUID where the unit will be 'hosted' (applicable to AIR, SHIP, SUB)
@field[type=number] loadout Aircraft database loadout id (applicable to AIR)
@field[type=number] altitude Unit altitude (applicable to AIR)
@field[type=string] guid Optional custom GUID to override auto one
@field[type=number] orbit Orbit index (applicable to SATELLITE)
]]

--[[--
Adds a unit based on a descriptor.

@param[type=NewUnit] unit The unit details to add
@return[type=Unit] A complete descriptor for the added unit
@usage ScenEdit_AddUnit({type = 'Aircraft', name = 'F-15C Eagle', loadoutid = 16934, 
 heading = 0, dbid = 3500, side = 'NATO', Latitude="N46.00.00",Longitude="E25.00.00",
 altitude="5000 ft",autodetectable="false",holdfire="true",proficiency=4})
@usage ScenEdit_AddUnit({type = 'Air', unitname = 'F-15C Eagle', loadoutid = 16934, dbid = 3500, side = 'NATO', Lat="5.123",Lon="-12.51",alt=5000})

]]
function ScenEdit_AddUnit(unit)end

--[[-- Update unit sensor/mount/weapon selector.

 ... lists minimum fields required. Other fields from @{Unit} may be included.

@Selector UpdateUnit
@field[type=string] guid The unit identifier
@field[type=string] mode The function to perform (add_ sensor,remove_ sensor,add_ mount,remove_ mount,add_ weapon,remove_ weapon,add_comms,remove_comms)
@field[type=number] dbid The database id of the item to add [required for 'add_' mode]. If used with 'remove_' mode, and no sensorid/mountid, the first matching DBID will be removed.
@field[type=string] sensorid The identifier (guid) of the particular sensor to remove [required for remove_ sensor mode]
@field[type=string] mountid The identifier (guid) of the particular mount to remove [required for remove_ mount mode]
@field[type=string] weaponid The identifier (guid) of the particular weapon to remove [required for remove_ weapon mode]. Must have a preceeding mountid to update
@field[type=string] commsid The identifier (guid) of the particular communication device to remove [required for remove_ mount mode]
@field[type={ Arcs },opt ] arc_detect The effective arcs for the particular sensor to detect in [override defaults]
@field[type={ Arcs },opt ] arc_track The effective arcs for the particular sensor to track/illuminate in [override defaults]
@field[type={ Arcs },opt ] arc_mount The effective arcs for the particular mount  [override defaults]
]]

--[[--
Update items on a unit.

@param[type=UpdateUnit] options The unit sensor/mount/weapon details to update
@return[type=Unit] The updated unit
@usage ScenEdit_UpdateUnit({guid='2cd64757-1b66-4609-ad56-df41bee652e5',mode='add_sensor',dbid=3352})
@usage ScenEdit_UpdateUnit({guid='2cd64757-1b66-4609-ad56-df41bee652e5',mode='remove_sensor',dbid=3352,sensorId='871aea14-d963-4052-a7fc-ed36e97bb732'})

]]
function ScenEdit_UpdateUnit(options)end


--[[--
Fetches a unit based on a selector.

This function is mostly identical to @{ScenEdit_SetUnit} except that if no unit is selected by the selector portion of `unit`, 
then the function returns nil instead of producing an exception.

@param[type=UnitSelector] unit The unit to select.
@return[type=Unit] A complete unit descriptor if the unit exists or nil otherwise.
@usage ScenEdit_GetUnit({side="United States", unitname="USS Test"})
]]
function ScenEdit_GetUnit(unit)end


--[[-- Contact selector.

Note that a unit and it's contact GUIDs are different for the same physical unit; the contact GUIDs are from the other side's perspective
@Selector ContactSelector

@field[type=string] side The side to find the the contact on.  
@field[type=string] guid The GUID of the contact. Interrogate ScenEdit_GetContacts(side) for the side's contacts and use the GUID from there. 

]]


--[[--
Fetches a contact based on a selector.

This function is mostly identical to @{ScenEdit_GetUnit} except that if references contacts on a side, 

@param[type=ContactSelector] contact The contact to select. Must be defined by a side and contact GUID for that side.
@return[type=Contact] A contact descriptor if it or nil otherwise.
@usage ScenEdit_GetContact({side="United States", guid="c4114322-900c-428d-a3e3-0af701e81a7a"})
]]
function ScenEdit_GetContact(contact)end

--[[--
Sets the properties of a unit that already exists.

@param[type=Unit] unit The unit to edit. Must be at least a selector.
@return[type=Unit] A complete descriptor for the added unit
@usage ScenEdit_SetUnit({side="United States", unitname="USS Test", lat = 5})
@usage ScenEdit_SetUnit({side="United States", unitname="USS Test", lat = 5})
@usage ScenEdit_SetUnit({side="United States", unitname="USS Test", lat = 5, lon = "N50.20.10"})
@usage ScenEdit_SetUnit({side="United States", unitname="USS Test", newname="USS Barack Obama"})
@usage ScenEdit_SetUnit({side="United States", unitname="USS Test", heading=0, HoldPosition=1, HoldFire=1,Proficiency="Ace", Autodetectable="yes"})
]]
function ScenEdit_SetUnit(unit)end


--[[-- Deletes unit.
 .. and no event triggers.
@param[UnitSelector] unit 
@usage ScenEdit_DeleteUnit({side="United States", unitname="USS Abcd"})
]]
function ScenEdit_DeleteUnit(unit)end


--[[-- Kill unit.
 ... and triggers event.

@function ScenEdit_KillUnit(unit)
@param[UnitSelector] unit 
@return[type=bool] True if successful
@usage ScenEdit_KillUnit({side='SideA',unitname='ship'})
]]

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
Changes the side of a unit

@param[type=SideDescription] sidedesc The sides to change for the unit. Group will change attached units
]]
function ScenEdit_SetUnitSide(sidedesc) end


--[[-- Select mount and weapon.

 You can specify a particular `mount` by the GUID, or leave it out, 
 and the function will try to fill up any `available` space with the `weapon`.
@Selector Weapon2Mount
@param[type=string] *side The side name/GUID of the unit with mount
@param[type=string] *unitname The name/GUID of unit with mount
@param[type=string] *guid GUID of the unit with mount
@param[type=string] mount_guid The mount GUID
@param[type=string] wpn_dbid The weapon database ID
@param[type=number] number Number to add
@param[type=bool] remove If true, this will debuct the number of weapons
@param[type=bool] fillout If true, will fill out the weapon record to its maximum
]]

--[[-- Adds weapons into a mount.

@function ScenEdit_AddReloadsToUnit
@param[type=Weapon2Mount] descriptor Describes the weapon and mount to update
@return[type=number] Number of items added to the magazine
@usage ScenEdit_AddReloadsToUnit({unitname='Mech Inf #1', w_dbid=773, number=1, w_max=10})
]]


--[[-- Select magazine and weapon.

 A group magazine, for example, tend to have multiple magazines, with the same name. So you can specify a particular `magazine` by the GUID, or leave it out, 
 and the function will try to fill up any `available` space with the `weapon`.
@Selector Weapon2Magazine
@param[type=string] *side The side name/GUID of the unit with magazine
@param[type=string] *unitname The name/GUID of unit with magazine
@param[type=string] *guid GUID of the unit with magazine
@param[type=string] mag_guid The magazine GUID
@param[type=string] wpn_dbid The weapon database ID
@param[type=number] number Number to add
@param[type=number] maxcap Maximum capacity of the weapon to store
@param[type=bool] remove If true, this will debuct the number of weapons
@param[type=bool] new If true, will add the weapon if it does not exist
@param[type=bool] fillout If true, will fill out the weapon record to its maximum
]]


--[[-- Adds weapons into a magazine.

@param[type=Weapon2Magazine] descriptor Describes the weapon and magazine to update
@return[type=number] Number of items added to the magazine
@usage ScenEdit_AddWeaponToUnitMagazine({unitname='Ammo', w_dbid=773, number=1, w_max=10})
]]
function ScenEdit_AddWeaponToUnitMagazine(descriptor)

--[[--
]]

--[[-- Unit refueling options.

@Wrapper RefuelOptions
@field[type=UnitSelector] unitSelector A normal unit selector defining the unit.
@field[type=string] tanker A specific tanker defined by its name (side is assumed to be the same as unit) or GUID.
@field[type={ mission } ] missions A table of mission names or mission GUIDs.
@usage {side="United States", name="USS Test", missions={"Pitstop"}, tanker="Hose #1"}
]]


--[[-- Cause unit to refuel.

 The unit should follow it's AAR configuration. You can force it use a specific tanker or ones from a set of missions.

@function ScenEdit_RefuelUnit
@param[type=RefuelOptions] unitOptions The unit and refueling options.
@return[type=String] If successful, then empty string. Else message showing why it failed to
@usage ScenEdit_RefuelUnit({side="United States", unitname="USS Test"})
@usage ScenEdit_RefuelUnit({side="United States", unitname="USS Test", tanker="Hose #1"})
@usage ScenEdit_RefuelUnit({side="United States", unitname="USS Test", missions={"Pitstop"}})
]]


--[[-- Contacts from a side.

 

@function ScenEdit_GetContacts
@param[type=string] side The name/guid of the side's contacts.
@return[type={ Contacts}] Table of contact details
@usage local con = ScenEdit_GetContacts('south korea')
]]


--[[-- Attack options.

@Wrapper AttackOptions
@field[type=string] mode Targeting mode "AutoTargeted"|"0", "ManualWeaponAlloc"|"1"
@field[type=number] mount The attacker's mount DBID
@field[type=number] weapon The attacker's weapon DBID
@field[type=number] qty How many to allocate
]]


--[[-- Attack a contact 
 ... as an auto-target or manual target with weapon allocation

@param[type=string] attackerID The unit attacking as GUID or Name
@param[type=string] contactId The contact being attacked as GUID or Name (GUID is better as the name can change as its classification changes)
@param[type={ AttackOptions }] options Contains type of attack and weapon allocation if required)
@return[type=bool] True if attack successful assigned
@usage ScenEdit_AttackContact(attackerID, contactId ,{mode='1', mount=438, weapon=1413, qty=10}) -- alloc 10 gunfire
]]
function  ScenEdit_AttackContact(attackerID, contactId, options) end


--[[-- Add side. 
 ... 

@param[type={ table } ] table The side
@return[type=Side] 
]]
function  ScenEdit_AddSide(table) end


--[[-- Remove side 
 from play. This removes ALL units and contacts. 

@param[type={ table } ] table The side
@return[type=Side] 
]]
function  ScenEdit_RemoveSide(table) end


--[[-- Add no-nav or exclusion zone. 
 ... 

@param[type=string ] sideName Side name/GUID 
@param[type=string ] zoneType Type of zone to add: 0 = no-nav, 1 = exclusion 
@param[type={ table } ] table  Description, Isactive, Area { of RPs }, Affects { of UnitTypes }, MarkAs (exc only), Locked (non only)
@return[type={ Zone } ] 
]]
function  ScenEdit_AddZone(sideName, zoneType , table) end


--[[-- Transfer cargo 
 .. list from 'mother' to 'child' 

@param[type=UnitSelector] fromUnit The unit with cargo
@param[type=UnitSelector] toUnit The unit to get cargo
@param[type={ Cargo }] cargoList List of cargo to transfer: table of {guids}, or { {DBID, number}}
@return[type=boolen] Successful or not
]]
function ScenEdit_TransferCargo(fromUnit, toUnit, cargoList) end


--[[-- Unload cargo 
  

@param[type=UnitSelector] fromUnit The unit with cargo
@param[type={ Cargo }] cargoList List of cargo to unload: table of {guids}, or { {DBID, number}}
@return[type=boolen] Successful or not
]]
function ScenEdit_UnloadCargo(fromUnit, cargoList) end


--[[ Gets formation
 .. from a group.


@param[type=UnitSelector] unit The unit to select and must be a group.
@return[type=table] Table of unit with stations.
@usage ScenEdit_GetFormation({side="United States", unitname="TF 611"})
]]
function ScenEdit_GetFormation(unit)end


--[[-- Get unit details 

This will get the information about an active unit or a contact unit
@param[type=UnitSelector] ActiveOrContact The unit selector to interrogate
@return[type=Unit] The information associated with the unit
]]
function VP_GetUnit(ActiveOrContact) end


--[[-- Contact selector.

Note that a unit and it's contact GUIDs are different for the same physical unit; the contact GUIDs are from the other side's perspective
@Selector VPContactSelector

@field[type=string] guid The GUID of the contact. Interrogate VP_GetSide().contacts for the side's contacts and use the GUID from there. 

]]
ContactSelector = {
	guid
}


--[[-- Get contact details 

This will get the information about a contact unit

@param[type=VPContactSelector] ContactGUID The contact selector to interrogate
@return[type=Contact] The information associated with the contact
@usage
 local vp = VP_GetSide({name = "NATO"})
 local cp = vp.contacts --List Of contacts
 local guid = cp[12].objectid -- a specific contact
 local contact = VP_GetContact({guid=guid}) -- details of contact as distinct to unit details
]]
function VP_GetContact(ContactGUID) end


--[[-- Side information from player's perspective.

Gets a side object from the perspective of the player.

@param[type=SideSelector] side The side to get information about.
@return[type=Side] Information about the side selected, from the perspective of the player.
@usage local a = VP_GetSide({Side ='sidea'}) -- a side object
 local z = a.nonavzones --List of no-nav zones for the side if you need to find it
 local n = a : getnonavzone(z[1].guid) -- required zone object for a particular zone
 n.isactive = false -- turn it off
]]
function VP_GetSide(side) end


--[[-- Export unit details 

 ... to a file for later import
 parameters filename, filter by unit type, side
@param[type=table] table of Filters: TARGETSIDE, TARGETTYPE, TARGETSUBTYPE, SPECIFICUNITCLASS, SPECIFICUNIT. The values are like the Event Target triigers, but can take multiple ones. As in TargetType={'aircraft','submarine'}} 
@param[type=string] filename of exported file
@return[type=bool] Success or failure
 {Filter}
]]
function VP_ExportUnits(table, filename) end


--[[--
	Returns the elevation in meters of a given position

@param[type=Point] location The position to find the elevation of
@return The elevation of the point in meters
]]
function World_GetElevation(location) end


--[[--
	Returns a circle around point.

@param[type=Point] table 
@return Table of points
]]
function World_GetCircleFromPoint(table) end


--[[--
	Returns a location based on bearing.

@param[type=Point] table 
@return Table of the new point
]]
function World_GetPointFromBearing(table) end


--[[-- Activating Unit 
 .. that triggered the current Event.
Otherwise, a nil is returned.

 Note that UnitX() can also be used as a shortcut for ScenEdit_UnitX()
@usage ScenEdit_SetUnitDamage({side=UnitX().side, unitname=UnitX().name, fires=1, components={ {'rudder','Medium'}, {'type',type='sensor',1} } })

@return[type=Unit] The triggering unit
@usage local unit = ScenEdit_UnitX()
]]
function ScenEdit_UnitX() end


--[[-- Detecting Unit 
 ... from a Unit Detected event trigger.
Otherwise, a nil is returned.

 Note that UnitY() can also be used as a shortcut for ScenEdit_UnitY()
@usage ScenEdit_SetUnitDamage({side=UnitY().side, unitname=UnitY().name, fires=1, components={ {'rudder','Medium'}, {'type',type='sensor',1} } })

@return[type={ table }] The detecting unit and sensors used as { unit = {unit object}, sensor = {[1] = {name, type}, [2] = {name, type}, etc} }
@usage local by = ScenEdit_UnitY()
  print('Y:'); print( by)
  print('Detected by: ');print( by.unit.name .. ' of type ' .. by.unit.type ..' from ' ..  by.unit.side)
  print('Sensor: ');print( by.sensor[1].name .. ' of type ' ..  by.sensor[1].type);
]]
function ScenEdit_UnitY() end


--[[-- Detected Contact 
 ... from a Unit Detected event trigger.
Otherwise, a nil is returned.

 Note that UnitC() can also be used as a shortcut for ScenEdit_UnitC()
@return[type=Contact] A contact descriptor or nil 
]]
function ScenEdit_UnitC() end


--[[-- Active Event 
 .. that has been triggered.
Otherwise, a nil is returned.

 Note that EventX() can also be used as a shortcut for ScenEdit_EventX()

@return[type=Event] The triggering event
@usage local event = ScenEdit_EventX()
]]
function ScenEdit_EventX() end


--[[-- Get the current scenario time.
@return[type=TimeStamp] The UTC Unix timestamp of the current time in-game.
@usage local now = ScenEdit_CurrentTime()
 local elapsed = now - timeFromLastTiggered
 if elapsed > 60*5 then
 -- been more than 5 minutes, set the lastTriggered time to now
  timeFromLastTiggered = now 
 end
]]
function ScenEdit_CurrentTime() end


--[[-- Name of the scenario.

@return[type=string] The title of the scenario
@function GetScenarioTitle
]]



--[[-- Runs a script from a file.
The file `script` must be inside the [Command base directory]/Lua directory, or else the game will not be able to load it.
You can make the file point to files within a sub-directory of this, as in 'library/cklib.lua'
The file to find will be of the form [Command base directory]/Lua/[`script`]
A file can also be loaded indirectly from an attachment @{ScenEdit_UseAttachment}


@param script The file containing the script to run. 
@usage ScenEdit_RunScript('mylibrary.lua')
]]
function ScenEdit_RunScript(script)end


--[[-- Sets the value for a key in the persistent key store.
 
This function allows you to add values, associated with keys, to a persistent store @{KeyStore} that is retained when the game is saved and resumed. Keys and values are both represented as non-nil strings.
The value is retrieved by @{ScenEdit_GetKeyValue}.

@param[type=string] key The key to associate with
@param[type=string] value The value to associate
@param[type=bool] forCampaign Pass the store to next scenario in campaign. Optional, default = false
@usage ScenEdit_SetKeyValue("A","B")
ScenEdit_GetKeyValue("A") -- returns "B"
]]
function ScenEdit_SetKeyValue(key, value) end


--[[-- Gets the value for a key from the persistent key store.

This function retrieves a value put into the store by @{ScenEdit_SetKeyValue}. The keys must be identical.

@param[type=string] key The key to fetch the associated value of
@param[type=bool] forCampaign Read from the store being passed to next scenario in campaign. Optional, default = false
@return[type=string] The value associated with the key. "" if none exists.
@usage ScenEdit_SetKeyValue("A","2")
ScenEdit_GetKeyValue("A") -- returns "2"
]]
function ScenEdit_GetKeyValue(key) end


--[[-- Clears a key

 .. or all keys from the persistent key store.

@param[type=string] key The key to clear or empty for all
@param[type=bool] forCampaign Use key store for passing ed to next scenario in campaign. Optional, default = false
@return[type=bool] Success or failure.
@usage ScenEdit_ClearKeyValue("A")
]]
function ScenEdit_ClearKeyValue(key) end


--[[-- Has the scenario started?

@return[type=bool] True if the scenario has started
@usage local state = ScenEdit_GetScenHasStarted()
]]
function ScenEdit_GetScenHasStarted() end


--[[-- The player's current side.

@return[type=string] The name of the current side
@usage local side = ScenEdit_PlayerSide()
]]
function ScenEdit_PlayerSide() end

--[[-- Ends the current scenario.

@usage ScenEdit_EndScenario()
]]
function ScenEdit_EndScenario() end


--[[-- Dump scenario events.
   .. useful for checking. Also writes a file to the scenario folder
@return[type=xml] Dump of events with trigger/condition/action
@function Tool_DumpEvents()
]]


--[[-- Emulates no console.
   .. useful running event code in the console and seeing how it behaves as an 'event'
@field[type=boolean] mode If True, then run as if event; if False, then turn back on console
@return[type=boolean] If interactive
@function Tool_EmulateNoConsole(mode)
]]


--[[-- Get range between points.

 The points can be a GUID of a unit/contact or a latitude/longitude point.
@usage Tool_Range('8269b881-20ce-4f2e-baa0-6823e46d55a4','004aa55d-d553-428d-a727-26853737c8f4' )
@usage Tool_Range( {latitude='33.1991547589118', longitude='138.376876749942'}, '8269b881-20ce-4f2e-baa0-6823e46d55a4' )
@field[type=table|string] fromHere
@field[type=table|string] toHere
@return[type=number] The horizontal distance in NM
@function Tool_Range(fromHere, toHere)
]]


--[[-- Get bearing between points.

 The points can be a GUID of a unit/contact or a latitude/longitude point.
@usage Tool_Bearing('8269b881-20ce-4f2e-baa0-6823e46d55a4','004aa55d-d553-428d-a727-26853737c8f4' )
@usage Tool_Bearing( {latitude='33.1991547589118', longitude='138.376876749942'}, '8269b881-20ce-4f2e-baa0-6823e46d55a4' )
@field[type=table|string] fromHere
@field[type=table|string] toHere
@return[type=number] The bearing
@function Tool_Bearing(fromHere, toHere)
]]


--[[-- Magazine.

 Note that when dealing with a magazine in a unit, it may constist of one or more actual magazine 'blocks'. 
 This is what is being referred to here, rather than the ONE magazine group for the unit/group.

@table Magazine
 @field[type=string] mag_capacity  Capacity|Storage
 @field[type=string] mag_dbid Database ID
 @field[type=string] mag_guid GUID
 @field[type=string] mag_name Name
 @field[type={ WeaponLoaded } ] mag_weapons Table of weapon loads in magazine
]]

--[[-- Mount.

 A mount is similar to a magazine, but it refers to the actual `loads` on the `weapon`, rather than a stoarge area.

@table Mount
 @field[type=string] mount_dbid Database ID
 @field[type=string] mount_guid GUID
 @field[type=string] mount_name Name
 @field[type=string] mount_status Status 
 @field[type=string] mount_statusR Reason why inoperative  [if not operational]
 @field[type=string] mount_damage Damage Severity   [if not operational]
 @field[type={ WeaponLoaded } ] mount_weapons Table of weapon loads on mount
]]

--[[-- Weapon loads on mount or in magazine.

@table WeaponLoaded
 @field[type=string]wpn_guid GUID
 @field[type=string]wpn_current Current loads available
 @field[type=string]wpn_maxcap Maximum loads 
 @field[type=string]wpn_default Default loads (to fill out)
 @field[type=string]wpn_dbid Database ID
 @field[type=string]wpn_name Name
]]

--[[-- Component.

 This identifies the component/item(s) that are present in a unit. See @{Unit}:filterOnComponent on how to filter this table
@table Component
 @field[type=string] comp_guid GUID
 @field[type=string] comp_dbid Database ID
 @field[type=string] comp_name Name
 @field[type=string] comp_type Type of component (mount, sensor, rudder, etc)
 @field[type=string] comp_status Status 
 @field[type=string] comp_statusR Reason why inoperative  [if not operational]
 @field[type=string] comp_damage Damage Severity   [if not operational]

]]

--[[-- Represents a active unit.

@Wrapper Unit
@field[type=string] type  The type of object, may be 'Facility', 'Ship', 'Submarine', or 'Aircraft'.[READONLY]
@field[type=string] name The unit's name.
@field[type=string] side  The unit's side. [READONLY]
@field[type=string] guid  The unit's unique ID.  [READONLY]
@field[type=string] subtype  The unit's subtype (if applicable). [READONLY]
@field[type=Unit] base  The unit's assigned base.
@field[type=Latitude] latitude The latitude of the unit.
@field[type=Longitude] longitude The longitude of the unit .
@field[type=number] DBID  The database ID of the unit  [READONLY]
@field[type=number] altitude The altitude of the unit in meters.
@field[type=number] speed The unit's current speed.
@field[type=Throttle] throttle The unit's current throttle setting.
@field[type=bool] autodetectable True if the unit is automatically detected.
@field[type=bool] holdposition True if the unit should hold.
@field[type={ table} ] holdfire Doctrine WCS setting for {air,surface,subsurface,land}. [READONLY]
@field[type=number] heading The unit's heading .
@field[type=string] proficiency The unit proficiency, "Novice"|0, "Cadet"|1,"Regular"|2, "Veteran"|3, "Ace"|4.
@field[type=string] newname If changing existing unit, the unit's new name .
@field[type={ WayPoint } ] course The unit's course, as a table of waypoints
@field[type={ Fuel } ] fuel A table of fuel types used by unit.
@field[type=Mission] mission The unit's assigned mission. Can be changed by setting to the Mission name or guid (calls ScenEdit_AssignUnitToMission)
@field[type=Group] group The unit's group (if applicable). Can be changed assigning an existing or new name. It will try to create a group if new (experimental)
@field[type=number]  airbornetime  how long aircraft has been flying. [READONLY]
@field[type=number]  loadoutdbid  current aircraft loadout DBID. [READONLY]
@field[type=number]  readytime  how long aircraft/ship takes to be ready. [READONLY]
@field[type=string] unitstate Message on unit status. [READONLY]
@field[type=string] fuelstate  Message on unit fuel status. [READONLY]
@field[type=string]  weaponstate  Message on unit weapon status. [READONLY]
@field[type=string]  condition_v  Docking/Air Ops condition value. [READONLY]
@field[type=string]  condition  Message on unit dock/air ops status. [READONLY]
@field[type=number]  manualSpeed  Manual desired speed. 'CURRENT/DESIRED/OFF or number'
@field[type=number]  manualAlitude  Manual desired altiude (meters).  'OFF or number'
@field[type={ table } ]  damage  Table {dp,flood,fires,startDp} of start and current DP, flood and fire level. [READONLY]
@field[type={ Magazine } ]  magazines  A table of magazines (with weapon loads) in the unit or group. Can be updated by @{ScenEdit_AddWeaponToUnitMagazine} [READONLY]
@field[type={ Mount } ]  mounts  A table of mounts (with weapon loads) in the unit or group. Can be updated by @{ScenEdit_AddReloadsToUnit} [READONLY]
@field[type={ Component } ]  components  A table of components on the unit.  [READONLY]
@field[type={ table } ]  ascontact  A table {side,guid,name} of this unit seen from the other sides (as contacts).  [READONLY]
@field[type={ Weather } ] weather Table of weather parameters (temp, rainfall, underrain, seastate)
@field[type={ table } ] areaTriggersFired Table of active 'in area' triggers that have fired for unit
@field[type={ table } ]  OODA  Table contain unit's "observe, orient, decide, act" values {evasion, targeting, detection} 
@field[type={ table } ] hostedUnits Table of boats and aircraft docked/embarked on the unit
@field[type={ table } ] weapon Table of shooter unit, at contact unit and detonated (when destroyed) if a weapon [READONLY]
@field[type={ table } ] targetedBy Table of unit guids that have this unit as a target
@field[type={ table } ] firingAt Table of contact guids that this unit is firing at
@field[type={ table } ] firedOn Table of guids that are firing on this unit
@field[type={ table } ] formation Table of unit's formation info {bearing, type (of bearing), distance, sprint (and drift) }
@field[type=bool ] sprintDrift Sprint and drift  'True/False'
@field[type=method] inArea({area}) Is unit in the 'area' defined by table of RPs (true/false)
@field[type=method] delete() Immediately removes unit object
@field[type=method] filterOnComponent(`type`) Filters unit on `type` of component and returns a @{Component} table.
@field[type=method] rangetotarget('contactid') Calculate flat distance to a contact location

 ScenEdit only
@field[type=bool] refuel Trigger the unit to attempt an UNREP
@field[type=bool] RTB Trigger the unit to return to base
@field[type=bool] moveto  Set a desired alt/depth instead of jumping to actual
@field[type=string|number]  manualSpeed Desired speed or 'OFF' to turn off manual mode
@field[type=bool]  manualAlitude  To turn on/off manual mode
    
]]


--[[-- Waypoint
 .. describing the long/lat points as in a plotted course

@table Waypoint
@field[type=number] longitude 
@field[type=number] latitude
@field[type=string] description
@field[type=string] presetAltitude
@field[type=string] presetDepth
@field[type=string] presetThrottle
@field[type=number] desiredAltitude
@field[type=number] desiredSpeed
@field[type=number] desiredAltitudeTF terrain-following

]]

--[[-- Fuel.

 The various types of fuel(s), and their state, carried by the unit.
 Use ScenEdit_SetUnit() to set the fuel rather thane the unit.fuel...
 ScenEdit_SetUnit({...,fuel={{'GasFuel',1500},{2001,8000}}..})
 It is easier and less prone to error; you can use the fuel name or the fuel number code

Fuel Types:

<style>
tr:not(:first-child) { border-top: 1px solid black;}
td { padding: .5em; }
</style>
<table style="border-spacing: 0.5rem;">
<tr><td>1001</td><td>'NoFuel'</td></tr>
<tr><td>2001</td><td>AviationFuel</td></tr>
<tr><td>3001</td><td>DieselFuel</td></tr>
<tr><td>3002</td><td>OilFuel</td></tr>
<tr><td>3003</td><td>GasFuel</td></tr>
<tr><td>4001</td><td>Battery</td></tr>
<tr><td>4002</td><td>AirIndepedent</td></tr>
<tr><td>5001</td><td>RocketFuel</td></tr>
<tr><td>5002</td><td>TorpedoFuel</td></tr>
<tr><td>5003</td><td>WeaponCoast</td></tr>
</table>
@table Fuel
@field[type={ FuelState }] fueltype The state of the type(s) of fuel in the unit. 
@usage local fuel = u.fuel
       fuel[3001].current = 400
       u.fuel = fuel
]]

--[[-- Status of a fuel `type`.

@table FuelState
@field[type=number] current The current fuel level of the type
@field[type=number] max How much can be stored for the type
@field[type=string] name Name of the fuel
@usage local fuel = u.fuel
       fuel[3001].current = 400
       u.fuel = fuel
]]


--[[-- Contact details. 

 This is from the perspective of the side being looked at. What is a contact for one side, may not be the same contact on another side.
 Note also the GUID of the contact is not the same as the actual unit. So depending on what functions you call, you may need to 
 'convert' the contact 'GUID' into the actual 'GUID' and call GetUnit() to process the actual GUID.
@Wrapper Contact
@field[type=string] name The contact name.
@field[type=string] guid The contact GUID. {READONLY]
@field[type=string] actualunitid The contact actual GUID. [READONLY]
@field[type=Latitude] latitude The latitude of the contact. [READONLY]
@field[type=Longitude] longitude The longitude of the contact. [READONLY]
@field[type=number] speed Speed if known  [READONLY]
@field[type=number] heading Heading if known  [READONLY]
@field[type=number] altitude Altitude if known  [READONLY]
@field[type=number] missile_defence Applicable to Facility and Ships. -1 = unknown contact [READONLY]
@field[type=number] age How long has contact been detected (in seconds)  [READONLY]
@field[type=string] type Type of contact. [READONLY]
@field[type=number] typed Type of contact. [READONLY]
@field[type={ LatLon } ] areaofuncertainty Table of points defining the area of contact. [READONLY]
@field[type=string] type_description Contact type description. [READONLY]
@field[type=number] actualunitdbid Actual contact type. [READONLY]
@field[type=string] classificationlevel Contact classification. [READONLY]
@field[type={ EMmatch } ]  potentialmatches Table {EMmatch} on potential EMCON emission matches. [READONLY] 
@field[type=Side] side Contact's actual side. [READONLY]
@field[type=Side] fromside The side who sees this contact. [READONLY]
@field[type=Side] detectedBySide The side who originally saw this contact. Would be same as fromside unless shared [READONLY]            
@field[type=string] posture Posture towards contact.
@field[type=bool] FilterOut True to filtered out contact
@field[type={ Weather } ] weather Table of weather parameters (temp, rainfall, underrain, seastate)
@field[type={ table } ] BDA Table of battle damage assessment (fires, flood, structural)
@field[type={ Emissions } ] emissions Table of detected emmissions from contact 
@field[type={ table } ] detectionBy Table of how long ago was detected by type (radar, esm, visual, infrared, sonaractive, sonarpassive) 
@field[type={ table } ] targetedBy Table of unit guids that have this contact as a target
@field[type={ table } ] firingAt Table of contact guids that this contact is firing at
@field[type={ table } ] firedOn Table of guids that are firing on this contact
@field[type=method] DropContact() Drops contact from the reporting side
@field[type=method] inArea({area}) Is contact in the 'area' defined by table of RPs (true/false)
]]


--[[-- EM matches 
 .. details
 
@table EMmatch
@field[type=number] dbid Databse id. 
@field[type=string] name Matching id name. 
@field[type=string] category Not applicable to weapons (Missile,Torpedo)
@field[type=string] type Not applicable to Facility
@field[type=number] subtype Type of item within the contact type ( subtype is "Fighter" within scope of Aircraft)
@field[type=number] missile_defence Applicable to Facility and Ships
]]

--[[-- Contact emission 
 .. details
 
@table Emissions
@field[type=string] name
@field[type=number] age  Time detection held
@field[type=string] solid  Precise detected (True/false)
@field[type=number] sensor_dbid Databse id. 
@field[type=string] sensor_name Sensor name. 
@field[type=string] sensor_type Sensor type
@field[type=string] sensor_role Sensor role
@field[type=number] sensor_maxrange Sensor range
]]

--[[-- Event details
. 

@Wrapper Event
@field[type=string] name The event name.
@field[type=string] guid The event GUID. [READONLY]
@field[type=string] description The event GUID.
@field[type={ table} ] details The details of the event with tables for triggers/conditions/actions. [READONLY]
@field[type=bool] isActive The event is active
@field[type=bool] isRepeatable The event repeats
@field[type=bool] isShown The event shows in log
@field[type=string] probability The event chance to occur (0-100)
@field[type={ table} ] actions The details of the actions in event [READONLY]
@field[type={ table} ] conditions The details of the conditions in event [READONLY]
@field[type={ table} ] triggers The details of the triggers in event [READONLY]

 @usage -- first trigger; as a 'Unit Detected'; what was the target filter values
 local Event = ScenEdit_EventX() -- current active event
 print(event.details.triggers[1].UnitDetected.TargetFilter)
]]


--[[-- Group details. 

@Wrapper Group
@field[type=string] type Type of group. [READONLY]
@field[type=string] guid [READONLY]
@field[type=string] name 
@field[type=string] side [READONLY]
@field[type=string] lead Group leader guid
@field[type={ string }] unitlist Table of unit GUIDs in the group. [READONLY]
]]

 
--[[-- Mission.
 

@Wrapper Mission
@field[type=string] guid The GUID of the mission. [READONLY]
@field[type=string] name Name of mission
@field[type=bool] isactive True if mission is currently active
@field[type=string] side Mission belongs to side
@field[type=DateTime] starttime Time mission starts
@field[type=DateTime] endtime Time mission ends
@field[type=MissionClass] type Mission class(patrol,strike,etc). [READONLY]
@field[type=MissionSubClass] subtype Mission class(asw,land,etc). [READONLY]
@field[type=bool] SISH 'Scrub if side human' tick box
@field[type={ GUID }] unitlist A table of units assigned to mission. [READONLY]
@field[type={ GUID }] targetlist A table of targets assigned to mission. [READONLY]
@field[type=AAR] aar A table of the mission air-to-air refueling options. [READONLY]
@field[type=FerryMission] ferrymission A table of the mission specific options. [READONLY]
@field[type=MineClearMission] mineclearmission A table of the mission specific options. [READONLY]
@field[type=MineMission] minemission A table of the mission specific options. [READONLY]
@field[type=SupportMission] supportmission A table of the mission specific options. [READONLY]
@field[type=PatrolMission] patrolmission A table of the mission specific options. [READONLY]
@field[type=StrikeMission] strikemission A table of the mission specific options. [READONLY]
@field[type=CargoMission] cargomission A table of the mission specific options. [READONLY]
]]

--[[-- AAR.
 .. refueling options; these are updated by ScenEdit_SetMission()
 
@table AAR
@field[type=string] use_refuel_unrep This is same as the one from Doctrine setting
@field[type=string|number] tankerUsage Automatic(0), Mission(1)
@field[type=bool] launchMissionWithoutTankersInPlace
@field[type={ mission name|guid }] tankerMissionList Table of missions to use as source of refuellers
@field[type=number] tankerMinNumber_total
@field[type=number] tankerMinNumber_airborne
@field[type=number] tankerMinNumber_station
@field[type=number] maxReceiversInQueuePerTanker_airborne
@field[type=number] fuelQtyToStartLookingForTanker_airborne Percentage of fuel (0-100)
@field[type=string|number] tankerMaxDistance_airborne Use 'internal' or set a range. The code will match the lowest availble setting
]]

--[[-- FerryMission.
  .. options; these are updated by ScenEdit_SetMission()
 
@table FerryMission
@field[type=string] ferryBehavior Values OneWay(0), Cycle(1), Random(2)
@field[type=string] ferryThrottleAircraft
@field[type=string] ferryAltitudeAircraft
@field[type=bool] ferryTerrainFollowingAircraft
@field[type=Size] flightSize
@field[type=string] minAircraftReq
@field[type=bool] useFlightSize
]]

--[[-- MineClearMission.
  .. options; these are updated by ScenEdit_SetMission()
 
@table MineClearMission
@field[type=bool] oneThirdRule
@field[type=string] transitThrottleAircraft
@field[type=string] transitAltitudeAircraft
@field[type=bool] transitTerrainFollowingAircraft
@field[type=string] stationThrottleAircraft
@field[type=string] stationAltitudeAircraft
@field[type=bool] stationTerrainFollowingAircraft
@field[type=string] transitThrottleSubmarine
@field[type=string] transitDepthSubmarine
@field[type=string] stationThrottleSubmarine
@field[type=string] stationDepthSubmarine
@field[type=string] transitThrottleShip
@field[type=string] stationThrottleShip
@field[type=Size] flightSize
@field[type=string] minAircraftReq
@field[type=bool] useFlightSize
@field[type=Size] groupSize
@field[type=bool] useGroupSize
@field[type={ name|guid }] zone Table of reference point names and/or guids
]]

--[[-- MineMission.
  .. options; these are updated by ScenEdit_SetMission()
 
@table MineMission
@field[type=bool] oneThirdRule
@field[type=string] transitThrottleAircraft
@field[type=string] transitAltitudeAircraft
@field[type=bool] transitTerrainFollowingAircraft
@field[type=string] stationThrottleAircraft
@field[type=string] stationAltitudeAircraft
@field[type=bool] stationTerrainFollowingAircraft
@field[type=string] transitThrottleSubmarine
@field[type=string] transitDepthSubmarine
@field[type=string] stationThrottleSubmarine
@field[type=string] stationDepthSubmarine
@field[type=string] transitThrottleShip
@field[type=string] stationThrottleShip
@field[type=Size] flightSize
@field[type=string] minaircraftreq
@field[type=bool] useFlightSize
@field[type=Size] groupSize
@field[type=bool] useGroupSize
@field[type={ name|guid }] zone Table of reference point names and/or guids
@field[type=time] armingdelay In format of 'days:hours:minutes:seconds' e.g. 1 day, 4 hours, 30 minutes would be '1:4:30:0'
]]

--[[-- SupportMission.
  .. options; these are updated by ScenEdit_SetMission()
 
@table SupportMission
@field[type=bool] oneThirdRule
@field[type=string] transitThrottleAircraft
@field[type=string]  transitAltitudeAircraft
@field[type=bool]  transitTerrainFollowingAircraft
@field[type=string] stationThrottleAircraft
@field[type=string]  stationAltitudeAircraft
@field[type=bool]  stationTerrainFollowingAircraft
@field[type=string] transitThrottleSubmarine
@field[type=string]  transitDepthSubmarine
@field[type=string]  stationThrottleSubmarine
@field[type=string] stationDepthSubmarine
@field[type=string] transitThrottleShip
@field[type=string] stationThrottleShip
@field[type=Size] flightSize
@field[type=string] minAircraftReq
@field[type=boo] useFlightSize
@field[type=Size] groupSize
@field[type=bool] useGroupSize
@field[type={ name|guid}] zone Table of reference point names and/or guids
@field[type=string] loopType Values of ContinousLoop(0) or SingleLoop(1)
@field[type=string] onStation
@field[type=bool] oneTimeOnly
@field[type=bool] activeEMCON
@field[type=bool] tankerOneTime
@field[type=string] tankerMaxReceivers
]]

--[[-- PatrolMission.
  .. options; these are updated by ScenEdit_SetMission()
 
@table PatrolMission
@field[type=string] type Subtype of mission (ASW = 'asw', ASuW_Naval = 'naval', AAW = 'aaw', ASuW_Land = 'land', ASuW_Mixed = 'mixed', SEAD = 'sead', SeaControl = 'sea')
@field[type=bool] oneThirdRule True if activated
@field[type=bool] checkOPA True if can investigate outside zones
@field[type=bool] checkWWR True if can investigate within weapon range
@field[type=bool] activeEMCON  True if active EMCON in patrol zone
@field[type=string] transitThrottleAircraft
@field[type=string] transitAltitudeAircraft
@field[type=bool] transitTerrainFollowingAircraft True if terrain following
@field[type=string] stationThrottleAircraft
@field[type=string] stationAltitudeAircraft
@field[type=bool] stationTerrainFollowingAircraft True if terrain following
@field[type=string] attackThrottleAircraft
@field[type=string] attackAltitudeAircraft
@field[type=bool] attackTerrainFollowingAircraft True if terrain following
@field[type=string] attackDistanceAircraft
@field[type=string] transitThrottleSubmarine
@field[type=string] transitDepthSubmarine
@field[type=string] stationThrottleSubmarine
@field[type=string] stationDepthSubmarine
@field[type=string] attackThrottleSubmarine
@field[type=string] attackDepthSubmarine
@field[type=string] attackDistanceSubmarine
@field[type=string] transitThrottleShip
@field[type=string] stationThrottleShip
@field[type=string] attackThrottleShip
@field[type=string] attackDistanceShip
@field[type=Size] flightSize
@field[type=string] minAircraftReq
@field[type=bool] useFlightSize True if min size required
@field[type=Size] groupSize
@field[type=bool] useGroupSize True if min size required
@field[type={ name|guid }] prosecutionZone Table of reference point names and/or GUIDs
@field[type={ name|guid }] patrolZone  Table of reference point names and/or GUIDs
]]

--[[-- StrikeMission.
  .. options; these are updated by ScenEdit_SetMission(). Note that these are split between the escorts and strikers
 
@table StrikeMission
@field[type=string] type  Subtype of mission (Air_Intercept = 'air', Land_Strike = 'land', Maritime_Strike = 'sea', Sub_Strike = 'sub')
@field[type=Size] escortFlightSizeShooter 
@field[type=number] escortMinShooter
@field[type=number] escortMaxShooter
@field[type=number] escortResponseRadius
@field[type=bool] escortUseFlightSize True if minimum size required
@field[type=Size] escortFlightSizeNonshooter
@field[type=number] escortMinNonshooter
@field[type=number] escortMaxNonshooter
@field[type=Size] escortGroupSize
@field[type=bool] escortUseGroupSize  True if minimum size required
@field[type=bool] strikeOneTimeOnly True if activated
@field[type=string] strikeMinimumTrigger
@field[type=number] strikeMax
@field[type=Size] strikeFlightSize
@field[type=number] strikeMinAircraftReq
@field[type=bool] strikeUseFlightSize True if minimum size required
@field[type=Size] strikeGroupSize
@field[type=bool] strikeUseGroupSize True if minimum size required
@field[type=bool] strikeAutoPlanner True if activated
@field[type=bool] strikePreplan True if pre-planned target list only
@field[type=number] strikeRadarUasge Radar usage
@field[type=number] strikeMinDist  Strike minimum distance
@field[type=number] strikeMaxDist  Strike maximum distance
]]

--[[-- CargoMission.
 .. options; these are updated by ScenEdit_SetMission()
 
@table CargoMission
@field[type=bool] oneThirdRule  True if activated
@field[type=string] transitThrottleAircraft
@field[type=string]  transitAltitudeAircraft
@field[type=string] stationThrottleAircraft
@field[type=string]  stationAltitudeAircraft
@field[type=string] transitThrottleSubmarine
@field[type=string]  transitDepthSubmarine
@field[type=string]  stationThrottleSubmarine
@field[type=string]  stationDepthSubmarine
@field[type=string] transitThrottleShip
@field[type=string]  stationThrottleShip
@field[type=bool]  useFlightSize  True if minimum size required
@field[type=bool]  useGroupSize True if minimum size required
@field[type={ name|guid }] zone Table of reference point names and/or GUIDs
]]

--[[-- DateTime.
 ... is displayed and changed as per LOCALE e.g. US would be 'MM/DD/YYYY HH:MM:SS AM/PM' eg '8/13/2002 12:14 PM'
 
@DataType DateTime
]]

--[[-- Reference point information.


@Wrapper ReferencePoint
@field[type=string] guid The unique identifier for the reference point
@field[type=string] side The side the reference point is visible to
@field[type=string] name The name of the reference point
@field[type=Latitude] latitude The latitude of the reference point
@field[type=Longitude] longitude The longitude of the reference point
@field[type=bool] highlighted True if the point should be selected
@field[type=bool] locked True if the point is locked
@field[type=bearing] bearingtype Type of bearing Fixed (0) or Rotating (1)
@field[type=Unit] relativeto The unit that reference point is realtive to
]]


--[[-- Side perspective.

@Wrapper Side
@param[type=string] guid The GUID of the side.
@param[type=string] name The name of the side.
@param[type={ SideUnit } ] units Table of units for the designated side. [READONLY]
@param[type={ SideContact } ] contacts Table of current contacts for the designated side. [READONLY]
@param[type={ Zone } ] exclusionzones Zones for the designated side [READONLY]
@param[type={ Zone } ] nonavzones  Zones for the designated side [READONLY]
@param[type=Awareness] awareness [READONLY]
@param[type=Proficiency] proficiency [READONLY]
@param[type=method] getexclusionzone(`ZoneGUID|ZoneName|ZoneDescription`) Returns matching @{Zone} or nil
@param[type=method] getnonavzone(`ZoneGUID|ZoneName|ZoneDescription`) Returns matching @{Zone} or nil
@param[type=method ] unitsBy(UnitType) Returns table of units filtered by type of unit for the designated side or nil.
@param[type=method ] contactsBy(UnitType) Returns table of current contacts filtered by type of unit for the designated side or nil.

]]

--[[-- Side's unit.

@table SideUnit
@param[type=string] guid The GUID of the unit. This is the actual guid.
@param[type=string] name The name of the unit.
]]

--[[-- Side's contact.

@table SideContact
@param[type=string] guid The GUID of the contact. Note that this is not the GUID of the unit, you must use VP_GetUnit to resolve it.
@param[type=string] name The name of the contact.
]]

 
--[[-- Exclusion/No navigatation zone.
 

@Wrapper Zone
@field[type=string] guid The GUID of the zone. [READONLY]
@field[type=string] description The description of the zone.
@field[type=bool] isactive Zone is currently active.
@field[type={ ZoneMarker }] area A set of reference points marking the zone. [READONLY]
@field[type={ unitTypes } ] affects List of unit types (ship, submarine, aircraft, facility)
@field[type=bool] locked Zone is locked.
@field[type=Posture] markas Posture of violator of exclusion zone.
]]

--[[-- Zone marker.
 
@table ZoneMarker
@field[type=string] guid The GUID of the Reference Point.
@field[type=Longitude] longitude 
@field[type=Latitude] latitude 
]]


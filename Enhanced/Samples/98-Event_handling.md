<html>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<body>

<p><b>Events</b></p>
<p>An event consists of one or more triggers, an optional set of conditions, and one or actions to perform when the trigger(s) and condition(s) are fulfilled.<br>
With Lua, you can create triggers, conditions and actions independently of the editor, and create or modify events with them.</p>

<p><b>Trigger, Condition and Action</b><br>
There are separate functions to handle the creation, update and deletion of the components of an event.</p>
<p>(a) <i>ScenEdit_SetTrigger( { table } )</i><br>
As it sounds, a trigger is something that fires off, and results in a success or fail. Apart from a few common keywords, each trigger has a set of keywords.
<br><p>
The common keywords used in the Lua table are:<br>
1) description - the name given to the trigger. The keyword 'name' can also be used for this.<br>
2) mode - type of operation to perform. Operations are 'list', 'add', 'remove', and 'update'.<br>
3) id - the GUID used to reference the trigger. This is used internally and is only for refernence.<br>
</p>
The trigger related keywords are listed below.<br>
</p>
<p> 
<table>
 <style>
 tr { border: 1px solid black;}
 td { padding: .1em; }
 </style>
<tr><td><b>Trigger type</b></td><td><b>Keyword</b></td><td><b>Comment</b></td></tr>
<tr><td>Points</td><td>SideID</td><td>Side to adjust points for</td></tr>
<tr><td></td><td>PointValue</td><td>Current points</td></tr>
<tr><td></td><td>ReachDirection</td><td>GoOver = 0, MatchExactly = 1, GoUnder = 2</td></tr>
<tr><td>RandomTime</td><td>EarliestTime</td><td>Earliest date/time to start checks</td></tr>
<tr><td></td><td>LatestTime</td><td>Latest date/time to stop checks</td></tr>
<tr><td>RegularTime</td><td>Interval</td><td>Time interval (1 sec, 2sec, 5sec, etc)</td></tr>
<tr><td>ScenEnded</td><td></td><td>No additional keywords</td></tr>
<tr><td>ScenLoaded</td><td></td><td>No additional keywords</td></tr>
<tr><td>Time</td><td>Time</td><td>Actual date/time to fire on</td></tr>
<tr><td>UnitDamaged</td><td>DamagePercent</td><td></td></tr>
<tr><td></td><td>TargetFilter</td><td>See below</td></tr>
<tr><td>UnitDestroyed</td><td>TargetFilter</td><td>See below</td></tr>
<tr><td>UnitDetected</td><td>TargetFilter</td><td>See below</td></tr>
<tr><td></td><td>DetectorSideID</td><td>Side doing the detecting</td></tr>
<tr><td></td><td>MCL</td><td>Minimum classifcation level</td></tr>
<tr><td></td><td>Area</td><td>Table of reference points</td></tr>
<tr><td>UnitEntersArea</td><td>TargetFilter</td><td>See below</td></tr>
<tr><td></td><td>Area</td><td>Table of reference points</td></tr>
<tr><td></td><td>ETOA</td><td>Earliest date/time of arrival</td></tr>
<tr><td></td><td>LTOA</td><td>Latest date/time of arrival</td></tr>
<tr><td></td><td>NOT</td><td>Not in the area</td></tr>
<tr><td></td><td>ExitArea</td><td>Leaving area</td></tr>
<tr><td>UnitRemainsInArea</td><td>TargetFilter</td><td>See below</td></tr>
<tr><td></td><td>Area</td><td>Table of reference points</td></tr>
<tr><td></td><td>TD</td><td>Time to remain in area in seconds (or as days:hours:minutes:seconds)</td></tr>
<tr><td>UnitBaseStatus</td><td>TargetFilter</td><td>See below </td></tr>
<tr><td></td><td>TargetStatus</td><td>Status number to monitor </td></tr>
</table>
</p>
<p><table>TargetFilter:<br> A series of filters to apply to units. Only units matching this filter will fire the trigger.
 <style>
 tr { border: 1px solid black;}
 td { padding: 2px; }
 </style>
<tr><td>TargetFilter</td><td>TargetSide</td><td>Side to fillter on</td></tr>
<tr><td></td><td>TargetType</td><td>Type of unit (ship, submarine, etc)</td></tr>
<tr><td></td><td>TargetSubType</td><td>Subtype of the above unit type</td></tr>
<tr><td></td><td>SpecificUnitClass</td><td>Unit class (DBID)</td></tr>
<tr><td></td><td>SpecificUnit</td><td>Actual unit</td></tr>
</table>
Note that side is mandatory, but you can specify a unit or type/sub/class. However, if using type/sub/class, you can use<br> 1) type, or<br> 2) type and subtype, or <br>3) type, subtype (optional as it is inferred from class) and class. </p>

<p><table>TargetType:<br>
 <style>
 tr { border: 1px solid black;}
 td { padding: 2px; }
 </style>
<tr><td>Aircraft</td><td>1</td></tr>
<tr><td>Ship</td><td>2</td></tr>
<tr><td>Submarine</td><td>3</td></tr>
<tr><td>Facility</td><td>4</td></tr>
<tr><td>Aimpoint</td><td>5</td></tr>
<tr><td>Weapon</td><td>6</td></tr>
<tr><td>Satellite </td><td>7</td></tr>
</table></p>
<p>
<b>Examples</b>
</p>

<u>Create a trigger for a specific unit leaving an area</u>
<p>
<code>local a = ScenEdit_SetTrigger({mode='add',type='UnitEntersArea',name='Sagami exiting hot zone', targetfilter={SPECIFICUNIT='AOE 421 Sagami'},area={'rp-1126','rp-1127','rp-1128','rp-1129'},exitarea=true})</code><br>
The varaiable a will contain the trigger information. It will be 'nil' if the trigger failed in a non-interactive script as in an event.
</p>

<u>Modify the trigger to 'any type of AOE entering hot zone'</u>
<p>
<code>local a = ScenEdit_SetTrigger({mode='update',type='UnitEntersArea',name='Sagami exiting hot zone', rename='Any AOE entering hot zone', targetfilter={TargetSubType = '5023', TargetType = '2' , TargetSide='sidea'}, area={'rp-1126','rp-1127','rp-1128','rp-1129'}, exitarea=false})</code>
</p>

<u>Remove the trigger 'any type of AOE entering hot zone</u>
<p>
<code>local a = ScenEdit_SetTrigger({mode='remove',type='UnitEntersArea',name='Any AOE entering hot zone'})</code><br>
If the trigger is assigned to an event, it can't be removed until removed from the event.
</p>
<ul>--------------------------------------------</ul>
<p>(b) <i>ScenEdit_SetCondition( { table } )</i><br>
As it sounds, a condition is something that can be further applied once the trigger has fired, and results in a success or fail. Apart from a few common keywords, each condition has a set of keywords.
<br><p>
The common keywords used in the Lua table are:<br>
1) description - the name given to the condition. The keyword 'name' can also be used for this.<br>
2) mode - type of operation to perform. Operations are 'list', 'add', 'remove', and 'update'.<br>
3) id - the GUID used to reference the condition. This is used internally and is only for refernence.<br>
</p>
The condition related keywords are listed below.<br>
</p>
<p> 
<table>
 <style>
 tr { border: 1px solid black;}
 td { padding: .1em; }
 </style>
<tr><td><b>Condition type</b></td><td><b>Keyword</b></td><td><b>Comment</b></td></tr>
<tr><td>LuaScript</td><td>ScriptText</td><td>A Lua script</td></tr>
<tr><td>ScenHasStarted</td><td>NOT</td><td>A NOT modifier for scenario NOT started yet</td></tr>
<tr><td>SidePosture</td><td>ObserverSideID</td><td>Side that views TargetSide as ...</td></tr>
<tr><td></td><td>TargetSideID</td><td></td></tr>
<tr><td></td><td>TargetPosture</td><td></td></tr>
<tr><td></td><td>NOT</td><td>A NOT modifier to change condition from true to false</td></tr>
</table>
For scripts, use '\r\n' to represent new lines, otherwise a multi-line script may not run. 
ScriptTest='--comment\r\nif unit ~= nil then\r\n return true\r\n else\r\n return false\r\n end'
</p>

<p>
<b>Examples</b>
</p>

<u>Create a condition for sideA being hostile to sideB</u>
<p>
<code>local a = ScenEdit_SetCondition({mode='add',type='SidePosture',name='sideA hostile to sideB', ObserverSideId='sidea', TargetSideId='sideb', targetposture='hostile'})</code><br>
The varaiable a will contain the condition information. It will be 'nil' if the function fails in a non-interactive script as in an event.
</p>
<ul>--------------------------------------------</ul>

<p>(c) <i>ScenEdit_SetAction( { table } )</i><br>
As it sounds, a action is something that will be done once the trigger (and condition) are successful. Apart from a few common keywords, each action has a set of keywords.
<br><p>
The common keywords used in the Lua table are:<br>
1) description - the name given to the action. The keyword 'name' can also be used for this.<br>
2) mode - type of operation to perform. Operations are 'list', 'add', 'remove', and 'update'.<br>
3) id - the GUID used to reference the action. This is used internally and is only for refernence.<br>
</p>
The action related keywords are listed below.<br>
</p>
<p> 
<table>
 <style>
 tr { border: 1px solid black;}
 td { padding: .1em; }
 </style>
<tr><td><b>Action type</b></td><td><b>Keyword</b></td><td><b>Comment</b></td></tr>
<tr><td>ChangeMissionStatus</td><td>MissionID</td><td>Mission identifier</td></tr>
<tr><td></td><td>NewStatus</td><td>New status - active(0) or inactive (1)</td></tr>
<tr><td>EndScenario</td><td></td><td>No additional keywords</td></tr>
<tr><td>LuaScript</td><td>ScriptText</td><td>A Lua script</td></tr>
<tr><td>Message</td><td>SideID</td><td>Side to see message</td></tr>
<tr><td></td><td>Text</td><td>Message text to show</td></tr>
<tr><td>Points</td><td>PointChange</td><td>Value to change points by (+/-)</td></tr>
<tr><td></td><td>SideID</td><td>Side affected</td></tr>
<tr><td>TeleportInArea</td><td>UnitIDs</td><td>Table of unit GUIDs</td></tr>
<tr><td></td><td>Area</td><td>Table of reference points</td></tr>
</table>
For scripts, use '\r\n' to represent new lines, otherwise a multi-line script may not run. 
ScriptTest='--comment\r\nif unit ~= nil then\r\n return true\r\n else\r\n return false\r\n end'
</p>

<p>
<b>Examples</b>
</p>

<u>Create a action changes points on SideA</u>
<p>
<code>local a = ScenEdit_SetAction({mode='add',type='Points',name='sideA loses some ..', SideId='sidea', PointChange=-10})</code><br>
The varaiable a will contain the action information. It will be 'nil' if the function fails in a non-interactive script as in an event.
</p>

<p><b>Modifying Events</b><br>
Triggers, conditions and actions (TCA) can be linked to events. A common format is followed for each one.
<br><p>
(a) <i>ScenEdit_SetEventTrigger( eventName, { table } )</i><br>
(b) <i>ScenEdit_SetEventCondition( eventName, { table } )</i><br>
(c) <i>ScenEdit_SetEventAction( eventName, { table } )</i><br>
The common keywords used in the Lua table are:<br>
1) description - the name given to the TCA. The keyword 'name' can also be used for this.<br>
2) mode - type of operation to perform. Operations are 'add', 'remove', and 'replace'.<br>
3) id - the GUID used to reference the TCA. This is used internally and is only for refernence.<br>
The functions will return the TCA on a succes as with the commands above.<br>
For the mode='replace', there is an extra keyword 'ReplacedBy' that swaps the old TCA with the new one. The previous one is returned by the funtion
</p>

<p>
<b>Examples</b>
</p>

<u>Add a new action an existing event</u>
<p>
<code>local a = ScenEdit_SetEventAction('test event', {mode='add', name='test action points'})</code><br>
The varaiable a will contain the action information. It will be 'nil' if the function fails in a non-interactive script as in an event.
</p>

<u>Repace an action an existing event</u>
<p>
<code>local a = ScenEdit_SetEventAction('test event', {mode='replace', name='test action message', replaceby='test action points'})</code><br>
</p>
<ul>--------------------------------------------</ul>
<p>
Events can also be created and modified thru Lua.<br>
<i>ScenEdit_SetEvent( eventName, { table } )</i><br>
The common keywords used in the Lua table are:<br>
1) description - the name given to the Event. The keyword 'name' can also be used for this.<br>
2) mode - type of operation to perform. Operations are 'add' and 'update'.<br>
3) id - the GUID used to reference the Event. This is used internally and is only for refernence.<br>
The normal Event keywords are accepted in the 'table'.

<p>
<b>Examples</b>
</p>
<u>Add a new event</u><br>
<p>
<code>local a = ScenEdit_SetEvent('my new event', {mode='add'})</code><br>
The varaiable a will contain the event information. It will be 'nil' if the function fails in a non-interactive script as in an event. <br>
The <code>ScenEdit_SetEvent(Trigger/Condition/Action)</code> functions then can be run on the new Event to add the required TCAs.
</p>

In addtion, <code>ScenEdit_GetEvent(EventDescriptionOrID, level)</code> has been updated to return information on the Event.<br>
Use level as: <br>
0 - all details, 1 - triggers, 2 - conditions, 3 - actions, 4 - event detail

</p>
</body>
</html>
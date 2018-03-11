
function AddSingleUnit()
	local u1 = ScenEdit_AddUnit( {
	type='ship',  -- the type of unit to add
	side='USN',   -- the side to add unit to
	name='Kennedy',  -- the name unit will be shown as
	dbid=2369,     -- the database id of the unit
	long=-76.109,   -- longitude to place unit
	lat=37.2,     -- latitude to place unit
	heading=150   -- heading of unit
	} )
	-- check that the function worked. a 'unit' wrapper should be returned
	if u1 == nil then
		print( "failed to add unit")
	else
		print('added' .. ' ' .. u1.name)
		u1.group='TF2.1.2'  -- add unit to a group. this will also create the group if it doesn't exist.
	end
end

function AddMultipleUnits() 
	-- list of units to add
	-- there are 2 base types of elements in this table - unit and group
	-- unit: contains data for adding the unit, and optional group or mission data. the mission data is not used in this example.
	-- group: contains data for adding some group information. the group is assumed to have been created when it was assigned to a unit
	local newUnits = {
	{unit={type='ship', side='USN', name='Enterprise', dbid=272, long=-76.1, lat=37.2, heading=150 } ,group='TF2.1.2'},
	{unit={type='ship', side='USN', name='Yorktown', dbid=42, long=-75.8890, lat=36.9890, heading=150 } ,group='TF2.1.2'},
	{unit={type='ship', side='USN', name='Truxtun', dbid=521, long=-76.2, lat=37.3, heading=150 } ,group='TF2.1.2'},
	{unit={type='ship', side='USN', name='King', dbid=761, long=-76.15, lat=37, heading=150 } ,group='TF2.1.2'},
	{unit={type='ship', side='USN', name='Underwood', dbid=116, long=-76.3, lat=37.25, heading=150 } ,group='TF2.1.2'},
	{unit={type='ship', side='USN', name='Wichita', dbid=1812, long=-76.09, lat=37.21, heading=150 } ,group='TF2.1.2'},
	{group={side='USN', name='TF2.1.2',course={{latitude='37.0999', longitude='-76.0879'},{latitude='36.8526', longitude='-75.5157'}}}},
	{unit={type='aircraft', side='USN', name='Tomcat #1', dbid=10, base='Enterprise',LoadoutID=754}, mission='CAP' },
	{unit={type='aircraft', side='USN', name='Tomcat #2', dbid=10, base='Enterprise',LoadoutID=754}, mission='CAP' },
	{unit={type='aircraft', side='USN', name='Tomcat #3', dbid=10, base='Enterprise',LoadoutID=754}, mission='CAP' },
	{unit={type='aircraft', side='USN', name='Tomcat #4', dbid=10, base='Enterprise',LoadoutID=754}, mission='CAP' },
	{unit={type='aircraft', side='USN', name='Hornet #1', dbid=47, base='Enterprise',LoadoutID=44} },
	{unit={type='aircraft', side='USN', name='Hornet #2', dbid=47, base='Enterprise',LoadoutID=44} },
	{unit={type='aircraft', side='USN', name='Hornet #3', dbid=47, base='Enterprise',LoadoutID=44} },
	{unit={type='aircraft', side='USN', name='Hornet #4', dbid=47, base='Enterprise',LoadoutID=44} },
	{unit={type='aircraft', side='USN', name='Intruder #1', dbid=221, base='Enterprise',LoadoutID=73} },
	{unit={type='aircraft', side='USN', name='Intruder #2', dbid=221, base='Enterprise',LoadoutID=73} },
	{unit={type='aircraft', side='USN', name='SeaHawk #1', dbid=237, base='Enterprise',LoadoutID=56}, mission='ASW patrol' },
	{unit={type='aircraft', side='USN', name='SeaHawk #2', dbid=237, base='Enterprise',LoadoutID=56}, mission='ASW patrol' },
	{unit={type='aircraft', side='USN', name='SeaHawk #3', dbid=237, base='Enterprise',LoadoutID=56}, mission='ASW patrol' },
	{unit={type='aircraft', side='USN', name='SeaHawk #4', dbid=237, base='Enterprise',LoadoutID=56}, mission='ASW patrol' },
	{unit={type='aircraft', side='USN', name='Sea King #1', dbid=55, base='Enterprise',LoadoutID=7}, mission='ASW strike' },
	{unit={type='aircraft', side='USN', name='Sea King #2', dbid=55, base='Enterprise',LoadoutID=7}, mission='ASW strike' },
	{unit={type='aircraft', side='USN', name='Sea King #3', dbid=55, base='Enterprise',LoadoutID=7}, mission='ASW strike' },
	{unit={type='aircraft', side='USN', name='Sea King #4', dbid=55, base='Enterprise',LoadoutID=7}, mission='ASW strike' },

	}
	-- process the table, adding the units to the scenario
	for i = 1, #newUnits, 1 do
	  -- the table element .unit contains data??
	  if newUnits[i].unit ~= nil then
		print('adding #' .. i .. ' ' .. newUnits[i].unit.name)
		-- the table element .unit contains the data to pass as the parameter to the SE_AddUnit() function
		local u1 = ScenEdit_AddUnit( newUnits[i].unit ) 
		-- check that the function worked. a 'unit' wrapper should be returned
		if u1 == nil then
			print( "failed to add unit")
		else
			-- does the same table entry contain an element .group. this is the group to assign unit to
			if newUnits[i].group ~= nil then
			  u1.group=newUnits[i].group	-- this will also create the group if it doesn't exist.
			end
		end
	  elseif newUnits[i].group ~= nil then
		print('adding #' .. i .. ' ' .. newUnits[i].group.name)
		-- update the group with the data from the table
		local u1 = ScenEdit_SetUnit( newUnits[i].group )
		if u1 == nil then
			print( "failed to add unit")
		end
	  end
	end
end

-- run the functions
AddSingleUnit()

AddMultipleUnits()

--[[
Output:
added Kennedy
adding #1 Enterprise
adding #2 Yorktown
adding #3 Truxtun
adding #4 King
adding #5 Underwood
adding #6 Wichita
adding #7 TF2.1.2
adding #8 Tomcat #1
adding #9 Tomcat #2
adding #10 Tomcat #3
adding #11 Tomcat #4
adding #12 Hornet #1
adding #13 Hornet #2
adding #14 Hornet #3
adding #15 Hornet #4
adding #16 Intruder #1
adding #17 Intruder #2
adding #18 SeaHawk #1
adding #19 SeaHawk #2
adding #20 SeaHawk #3
adding #21 SeaHawk #4
adding #22 Sea King #1
adding #23 Sea King #2
adding #24 Sea King #3
adding #25 Sea King #4
--]]
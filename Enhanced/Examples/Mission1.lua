-- causes commands to return rather than stop on error; using this emulates what should happen for event scripts as you don't want them script to exit on the first error that happens from a SE command.
Tool_EmulateNoConsole(true)

-- determine what aircraft are on a ship
local u = ScenEdit_GetUnit({side='USN', name='Enterprise'})
-- u.hostedUnits['Aircraft'] -> guids of units being hosted on the ship
-- scan the table of units on board and select the ones that are useful for ASW patrol missions
local req = {}
for i=1, #(u.hostedUnits['Aircraft']), 1 do
    --print(i .. " " .. u.hostedUnits['Aircraft'][i])
    -- get the unit and loadout details
    --local un = ScenEdit_GetUnit({ name=u.hostedUnits['Aircraft'][i] })
    --if un ~= nil then
        local lo = ScenEdit_GetLoadout({ name=u.hostedUnits['Aircraft'][i] })
        if lo ~= nil then
            -- role code 6001 ASW Patrol
            if lo.roles.role == 6001 then
                --print(ScenEdit_GetUnit({ name=u.hostedUnits['Aircraft'][i] }).name);
                --print(lo);print(lo.weapons);print(lo.roles)
                local a = {}
                a['dbid'] = lo.dbid
                a['guid'] = u.hostedUnits['Aircraft'][i]
                table.insert(req, a)
            end
        end
    --end
end
table.sort(req,function(a,b) return(a.dbid < b.dbid) end)
--count type of loadout and use the higher count
local count = {}
for i=1, #req, 1 do
    local found = false
    for j=1, #count, 1 do
        if count[j].dbid == req[i].dbid then
            count[j].number = count[j].number + 1
            found = true
            break
        end
    end
    if found == false then
        local a = {}
        a['dbid'] = req[i].dbid
        a['number'] = 1
        table.insert(count, a)
    end
end
-- assign aircraft of loadout type to mission
if #count > 0 then
    table.sort(count,function(a,b) return(a.number > b.number) end)
    -- commonest loadout
    local best_loadout = count[1].dbid; print('best ' .. best_loadout)
    -- get the mission id
    local mission = ScenEdit_GetMission('USN', 'ASW patrol' )
    if mission ~= nil then
        for i=1, #req, 1 do
            -- assign matching aircraft to the mission
            if req[i].dbid == best_loadout then
                local u1 = ScenEdit_AssignUnitToMission( req[i].guid, mission.guid )
            end
        end
    end
end
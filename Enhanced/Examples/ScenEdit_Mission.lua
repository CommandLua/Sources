-- casues commands to return rather than stop on error
Tool_EmulateNoConsole(true)

-- add patrol areas
local rp = ScenEdit_AddReferencePoint({side='USN', area = { { name = 'ASW1', latitude = '37.0603679040225', longitude = '-75.6385367903846' }, { name = 'ASW2', latitude = '37.0348786513868', longitude = '-75.4620702078127' }, { name = 'ASW3', latitude = '36.7335757863909', longitude = '-75.6561443351817' }, { name = 'ASW4', latitude = '36.7954715618781', longitude = '-75.7827960715359' } }})
rp.highlighted=true
rp = ScenEdit_AddReferencePoint({side='USN',  area = { { name = 'CAP1',  latitude = '37.7532467437691', longitude = '-75.4646862637693' }, { name = 'CAP2', latitude = '37.5371903907565', longitude = '-75.0762089773193' }, { name = 'CAP3', latitude = '37.3380580875803', longitude = '-75.2578995208917' }, { name = 'CAP4',  latitude = '37.579644594475', longitude = '-75.6550771945462' } } })
rp.highlighted=true
rp = ScenEdit_AddReferencePoint({side='USN',  area = { {name='SD-1', latitude='36.833046265781', longitude='-75.4321271077115'} , {name='SD-2', latitude='36.8312502782357', longitude='-74.6593127814792'} , {name='SD-3', latitude='36.3500038343364', longitude='-74.662674932343'} , {name='SD-4', latitude='36.3519590455694', longitude='-75.4314076940298'} } } )
rp.highlighted=true

-- delete any existing missions
local dm =  ScenEdit_GetMission('USN', 'ASW strike')
if dm ~= nil then
    ScenEdit_DeleteMission('USN', 'ASW strike')
end
dm =  ScenEdit_GetMission('USN', 'ASW patrol')
if dm ~= nil then
    ScenEdit_DeleteMission('USN', 'ASW patrol')
end
enddm =  ScenEdit_GetMission('USN', 'CAP')
if dm ~= nil then
    ScenEdit_DeleteMission('USN', 'CAP')
end 
enddm =  ScenEdit_GetMission('USN', 'Sea Dragon')
if dm ~= nil then
    ScenEdit_DeleteMission('USN', 'Sea Dragon')
end 

-- create missions
local mission = ScenEdit_AddMission('USN', 'ASW strike', 'strike', {type= 'sub'}); mission.isactive=false
if mission ~= nil then
	mission = ScenEdit_SetMission('USN', 'ASW strike',{strikeMinimumTrigger='hostile'})
else
	print('failed to add mission' .. 'ASW strike')
end
mission = ScenEdit_AddMission('USN', 'ASW patrol', 'patrol', {type= 'sub'}); mission.isactive=false
if mission ~= nil then
	mission = ScenEdit_SetMission('USN', 'ASW patrol', {patrolzone={'ASW1', 'ASW2','ASW3','ASW4'},
        prosecutionZone={'ASW1', 'ASW2','ASW3','ASW4'}, onethirdrule=false, onstation=2 })
else
	print('failed to add mission' .. 'ASW patrol')
end
mission = ScenEdit_AddMission('USN', 'CAP', 'patrol', {type= 'air'}); mission.isactive=false
if mission ~= nil then
	mission = ScenEdit_SetMission('USN', 'CAP', {patrolzone={'CAP1', 'CAP2','CAP3','CAP4'}, onethirdrule=true })
else
	print('failed to add mission' .. 'CAP')
end
mission = ScenEdit_AddMission('USN', 'Sea Dragon', 'patrol', {type= 'naval'}); mission.isactive=false
if mission ~= nil then
	mission = ScenEdit_SetMission('USN', 'Sea Dragon', {patrolzone={'SD-1', 'SD-2','SD-3','SD-4'}, onethirdrule=true })
else
	print('failed to add mission' .. 'Sea Dragon')
end

-- assign units to missions
--[[for i = 1, #newUnits, 1 do
  if newUnits[i].unit ~= nil then
    if newUnits[i].mission ~= nil then
      print(i .. ' ' .. newUnits[i].unit.name .. ' to ' .. newUnits[i].mission)
      mission = ScenEdit_SetMission('USN', newUnits[i].mission, { usegroupsize=false, useflightsize=false })
      local u1 = ScenEdit_AssignUnitToMission( newUnits_guid [i], newUnits[i].mission )
    end
  end
end
]]

-- activate missions
--mission = ScenEdit_GetMission('USN', 'ASW patrol' ); mission.isactive=true
--mission = ScenEdit_GetMission('USN', 'CAP' ); mission.isactive=true

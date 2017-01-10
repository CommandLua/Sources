In this tutorial, we'll discuss how to embed your scripts into a real scenario, as well as how to alter the EMCON of a unit. Yet again, the two sides are fighting, but with ground units which aren't on the map. LuaSideB wants some aerial recon, but can only understand instructions in Lua. This is particularly problematic, because they want a radar sweep but only from within a specific area! Even worse, the generals forgot to tell the pilot about this, so we'll have to inform the pilot to turn the radar on once it arrives.

To implement this challenge, we'll be using Command's events system to control the EMCON of the recon aircraft. The scene file already contains the skeleton of what's needed for Lua use.

[Scene file](https://github.com/BenChung/CommandLuaDocs/raw/master/LuaTutorial3.scen)

LuaSideB has already placed the aircraft (BHawk) and the mission (AAnalysis). We'll be configuring BHawk to fly AAnalysis.

##SetEMCON
To make this scene work, we'll need to use the @{ScenEdit_SetEMCON|SetEMCON} function. This function does what it says on the tin: explains to one of the Luaians what kind of EMCON to use, be it Radar, Sonar, or OECM. 

The function's syntax is quite complex. The signature is

    ScenEdit_SetEMCON(['Side' / 'Mission' / 'Group' / 'Unit'], ['Side Name or ID' / 'Mission Name or ID' / 'Group Name or ID' / 'Unit Name or ID'], ['Radar/Sonar/OECM=Active/Passive;' / 'Inherit'])

For instance, to turn on an BHawk's OECM, you would write

    ScenEdit_SetEMCON('Unit','BHawk','OECM=Active')

Therefore, we need to do

    ScenEdit_SetEMCON('Unit','BHawk','Radar=Active')

##Events
We need to add Lua to the event framework that's already in the game. We'll add a new action of the type "Lua Action", as seen here:

![Event editor Lua Action](http://imgur.com/MGsUvoe.png)

Then, we get

![Lua Action Editor](http://imgur.com/BkzIRdJ.png)

The text entry area is where we'll add our script.

To finish the tutorial, add in our Lua script to set the EMCON, add it to the event, then run the scenario.
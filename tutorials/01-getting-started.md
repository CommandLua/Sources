# Introduction to Lua in Command

Before you begin, make sure that you've read the first 4 tutorials at the [lua-users wiki](http://lua-users.org/wiki/TutorialDirectory), to help with understanding what's going on here. We also recommend FunctionsTutorial, but it is optional.

[Scen file, right click -> save as](https://github.com/BenChung/CommandLuaDocs/raw/master/LuaTutorial1.scen).

Please download the introductory Scene file. This file includes a blank map with two predefined sides, LuaSideA and LuaSideB, who are eternal mortal enemies. These two belligerents want to have a naval incident in the North Atlantic (and each has a mission already set up to do so), but don't have any ships to incident with. We will help them out by giving them some new vessels, using Lua.

Before we get started, we have to introduce our metaphorical office, the place where we'll be working from. In this introduction, we will be using the script console, then in part 2 we will move onto to using Lua from the event editor.

![Figure 1](http://i.imgur.com/waKVgdA.png)
Once you've opened the scene file in the editor, open the script console (Editor->Script Console).
![Script Console](http://i.imgur.com/qO9ql2H.png)

The Script Console provides a place to rapidly create, run, and debug Lua scripts. The interface has 3 components:

 * **Red**: This displays the output of your scripts, as well as a history of your inputs.
 * **Green**: This is where you enter the scripts into the console to run them.
 * **Yellow**: This button is how you execute your script in the game.

For the purposes of this tutorial, we will be using the script editor to set up a simple scene, where two identical ships fire at each other over a short distance. The scene already has the posture information in it, so we just need to select, position, and create the ships.

## Concepts
Before we can get into the meat of Lua in Command, we first have to discuss two basic concepts: IDs and positions.

### IDs
Internally, Command refers to every aircraft, ship, submarine, loadout (and rather a lot else) with a unique ID number. To create a unit, you need to tell Command that unit's unique ID number, which can typically be found in the DB viewer.

For the purposes of this tutorial, both LuaSideA and LuaSideB operate the 1984 variant of the Spruance class destroyer. To add it using Lua, we look up the ID in the DB:
![DB lookup](http://i.imgur.com/9svl63O.png)

In this case, the class has ID# 383.

### Positions
As you probably already know, map positions are referred to with latitude (north/south) and longitude (east/west) coordinates. These can be represented in two forms, degrees minutes seconds, and decimal degrees. The Command Lua API supports both forms, but we will cover only the decimal form.

For this scenario, we will pick an arbitrary location in the North Atlantic for our ships. We pick these two positions:

![Pos 1](http://i.imgur.com/kRGv31E.png)

![Pos 2](http://i.imgur.com/hkza1QX.png)

To copy these positions in-game, point to a position on the map, then press Ctrl-X. This copies a string to the clipboard representing the position pointed to on the map, a string that can then be directly used from Lua.

We will use the following two positions for this tutorial:

* `latitude='61.4900913548312', longitude='-17.2428976983679'`
* `latitude='61.4858175768381', longitude='-17.256394768325'`

Note that the formatting is correct for use in a Lua table - this will become important when we come to add them to the scene.
## Execution

Let's add our ships now. To do so, we'll need to use the function @{ScenEdit_AddUnit}.

@{ScenEdit_AddUnit} adds a unit to the game, using a @{Unit | unit descriptor}. A unit descriptor uses a table to define the properties of a unit, such as position, type, and side.

At a minimum, to create a unit, this table needs to contain:

* Side (e.g. "LuaSideA" and "LuaSideB")
* Type (both "Ship" in this case - use the part of the DB you got the ID from)
* Name (in this case "A" and "B")
* DBID (Both 383, a newish Spruance-Class)
* Lat & lon

See the data type documentation for a complete explanation as to the use of these fields.

For our purposes, we want to add two ships with names A and B, DBID 383, at the above coords, to sides LuaSideA and LuaSideB. 

    ScenEdit_AddUnit({side='LuaSideA', type='Ship', name='A', dbid=383, latitude='61.4900913548312', longitude='-17.2428976983679'})
    ScenEdit_AddUnit({side='LuaSideB', type='Ship', name='B', dbid=383, latitude='61.4858175768381', longitude='-17.256394768325'})

Once you run this script, you should end up with two Spruances near Iceland on opposite sides.

Running the scenario now leads to disappointment - the ships don't attack each other. We need to add them to a mission. To do this, we use the @{ScenEdit_AssignUnitToMission} function, with the following signature

    ScenEdit_AssignUnitToMission('[Unit Name or ID]', '[Mission Name or ID or NONE]')

The scene already contains two missions with appropriate setups for attack. We simply need to assign our ships to these missions, like so

    ScenEdit_AssignUnitToMission('A', 'AStrike')
    ScenEdit_AssignUnitToMission('B', 'BStrike')

Now, if you execute this and run the game, the ships should see and attack each other, as intended.

In @{02-creation.md|tutorial 2}, we'll cover the basics of aircraft creation and weather alteration.
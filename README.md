# Jakes Turn Based Battle System
A turn based battle system demo I made in GameMaker Studio.

I made this project using the wonderful Sara Spalding's [Turn Based Combat Tutorial](<https://www.youtube.com/playlist?list=PLPRT_JORnIurSiSB5r7UQAdzoEv-HF24L>) as a base. That tutorial series remains incomplete as of the time of writing, lacking a number of features vital to the functioning of the system.

I began this project in november of 2024, inspired largely by my desire to better comprehend my complicated feelings towards the game Chained Echoes. I also have a number of game ideas that could use a system like this, so it seemed like a good idea to try my hand at learning the basics and seeing where I could take them. 

After getting the game into a relatively stable and playable state on my own, I took a couple months away from working in game maker to learn the Godot and Unity engines. During this time my programming abilities vastly improved, so I decided to return to the project to take a crack at making the combat feeling much better. I proceeded make some pretty substantial changes to core elements of the system, as well as completely overhauling the look of the system. The base of the project is still fundamentally similar, but there are very few parts of the project that don't have my fingerprints.


## Download Instructions:

- To gain access to the Game Maker Project, simply download the [_"Jake's Turn Based Battle System"_](<Jake's Turn Based Battle System>) Folder and import it into the engine.
- To Download the demo and play it, download [_this_](<Jake's Turn Based Battle System (game demo).zip>) zipped folder and extract the files.



## Additions and Changes made to the base project:

**ADDITIONS:**

- Battle end screens for Victory and Game over.
- A rudimentary level-up system with xp points that one can gain from battle to battle, and scaling stats.
- A system that randomizes the turn order with each round.
- A display system that showcases the turn order for the current and next turn (Inspired by octopath traveller).
- A system for enemy weaknesses to attacks of certain types (Inspired by every JRPG under the sun).
- A new battle state that allows the player to restart the battle from the beginning on a game over.
- Movement states for battle units, allowing for melee actions to actually connect with their enemies.
- A dynamic battle camera that follows units as they move across the battlefield.
- Screen shake on attack impacts that gets more intense if the target is weak to the attack.
- A rudimentary condition system.
- Properly implemented controller support that adapts to controllers connecting and disconnecting (this is not native to GameMaker and had to be programmed manually).
  
**CHANGES:**

- Overhauled visuals (Purchased from the lovely penusbmic on itch.io).
- Overhauled UI (Made with elements from penusbmic, as well as fonts from the users "neatthings" and "Daniel Linssen" on itch.io).
- New Enemies with improved AI.
- New Actions and massive changes to the way actions are performed, allowing for actions that can hit multiple times.
- Better transitions to entering the battle and exiting it.
- Moved all draw functions for UI elements from the normal "Draw" events to the "Draw GUI" (In this repo Draw_64), which required a ton of adjustments. 
 


## To Review the Code:

GameMaker handles the storage of files for its users, in a way that is (in my humble opinion), very hard to navigate.

So in the interest of saving you the hassle, I'll point you to all of the important code, all of which is annotated.

**OBJECT SCRIPTS**
- [**oBattle's**](<Jake's Turn Based Battle System/objects/oBattle>) Events:
  - [Create](<Jake's Turn Based Battle System/objects/oBattle/Create_0.gml>) - Holds all of the code for the battle manager's state machine, which is the fundamental core of the project.
  - [Draw_64](<Jake's Turn Based Battle System/objects/oBattle/Draw_64.gml>) (Draw GUI) - Handles the drawing of the basic battle UI, including turn order portraits, and the UI for ally HP/MP containers.
  - [Step](<Jake's Turn Based Battle System/objects/oBattle/Step_0.gml>) - Handles targetting after selecting an action.
- [**oBattleUnit's**](<Jake's Turn Based Battle System/objects/oBattleUnit>) Events:
  - [Create](<Jake's Turn Based Battle System/objects/oBattleUnit/Create_0.gml>) - Handles a Unit's stats, as well as the unit's movement state machine.
- [**oMenu's**](<Jake's Turn Based Battle System/objects/oMenu>) Events:
  - [Step](<Jake's Turn Based Battle System/objects/oMenu/Step_0.gml>) - Handles the selection of menu items.
  - [Draw_64](<Jake's Turn Based Battle System/objects/oMenu/Draw_64.gml>) - Handles the drawing of the menu UI.
- [**objBattleVictory's**](<Jake's Turn Based Battle System/objects/objBattleVictory>) Events:
  - [Step](<Jake's Turn Based Battle System/objects/objBattleVictory/Step_0.gml>) - Lays out a sequence of code that triggers parts of the object's drawn elements at proper intervals.
  - [Draw_64](<Jake's Turn Based Battle System/objects/objBattleVictory/Draw_64.gml>) - Handles the drawing of the victory screen's UI.
- [**objBattleGameOver's**](<Jake's Turn Based Battle System/objects/objBattleGameOver>) Events:
  - [Step](<Jake's Turn Based Battle System/objects/objBattleGameOver/Step_0.gml>) - Lays out a sequence of code that triggers parts of the object's drawn elements at proper intervals.
  - [Draw_64](<Jake's Turn Based Battle System/objects/objBattleGameOver/Draw_64.gml>) - Handles the drawing of the Game Over sequence.
- [**objBattleCamera's**](<Jake's Turn Based Battle System/objects/objBattleCamera>) Events:
  - [Create](<Jake's Turn Based Battle System/objects/objBattleCamera/Create_0.gml>) - Holds the state machine (camera_mode) used to determine the camera's activity.
  - [Step](<Jake's Turn Based Battle System/objects/objBattleCamera/Step_0.gml>) - Handles the camera movement and screen shake.
- [**objControls'**](<Jake's Turn Based Battle System/objects/objControls>) Events:
  - [Step](<Jake's Turn Based Battle System/objects/objControls/Step_0.gml>) - Holds all of the input parsing code I wrote to universalize the demo's controls and add controller support.

**GENRAL SCRIPTS**
- [**ActionLibrary**](<Jake's Turn Based Battle System/scripts/ActionLibrary/ActionLibrary.gml>) - Holds all of the actions usable in the game, with a glossary at the beginning
- [**Units**](<Jake's Turn Based Battle System/scripts/Units/Units.gml>) - Holds all units (both allies and enemies), as well as the global.party array (which has to be established after the allies.)
- [**GameData**](<Jake's Turn Based Battle System/scripts/GameData/GameData.gml>) - Holds several miscellaneous macros, enums and the level manager.
- [**Menu Functions**](<Jake's Turn Based Battle System/scripts/MenuFunctions/MenuFunctions.gml>) - Holds all relevant menu functions (A list of those functions can be found at the beginning of the script.)
- [**Battle Functions**](<Jake's Turn Based Battle System/scripts/BattleFunctions/BattleFunctions.gml>) - Holds a number of functions that are used during battles.


## Credits:

- [**Sara Spalding**](<https://www.youtube.com/@SaraSpalding>) - Creator of the Base Project and a couple of the art assets in the final build.
- [**penusbmic**](<https://penusbmic.itch.io/>) - Creator of nearly all of the art assets used in the final build.
- [**neatthings**](<https://neatthings.itch.io/>) - Creator of the main font: "Spencer's Spooky Font"
- [**Daniel Linssen**](<https://managore.itch.io/>) - Creator of the font "M3x6", which is used in some UI elements

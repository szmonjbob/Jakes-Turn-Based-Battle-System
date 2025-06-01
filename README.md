# Jakes Turn Based Battle System
A turn based battle system demo I made in GameMaker Studio.

I made this project using the wonderful Sara Spaulding's [Turn Based Combat Tutorial](<>) as a base. That tutorial series remains incomplete as of the time of writing, lacking a number of features vital to the functioning of the system.

I began this project in november of 2024, inspired largely by my desire to better comprehend my complicated feelings towards the game Chained Echoes. I also have a number of game ideas that could use a system like this, so it seemed like a good idea to try my hand at learning the basics and seeing where I could take them. 

After getting the game into a relatively stable and playable state on my own, I took a couple months away from working in game maker to learn the Godot and Unity engines. During this time my programming abilities vastly improved, so I decided to return to the project to take a crack at making the combat feeling much better. I proceeded make some pretty substantial changes to core elements of the system, as well as completely overhauling the look of the system. The base of the project is still fundamentally similar, but there are very few parts of the project that don't have my fingerprints.


## Download Instructions:

- To gain access to the Game Maker Project, simply download the [_"Jake's Turn Based Battle System"_](<>) Folder and import it into the engine.
- To Download the demo and play it, download [_this_](<>) zipped folder and extract the files.



## Additions and Changes made to the base project:

**ADDITIONS:**

- Battle end screens for Victory and Game over.
- A rudimentary level-up system with xp points that one can gain from battle to battle, and scaling stats.
- A system that randomizes the turn order with each round.
- A display system that showcases the turn order for the current and next turn (Inspired by octopath traveller).
- A system for enemy weaknesses to attacks of certain types (Inspired by every JRPG under the sun).
- A new battle state that allows the player to restart the battle from the beginning on a game over.
- Movement states for battle units, allowing for melee actions to actually connect with their enemies.
- A dynamic battle camera that follows units as they move across the screen.
- Screen shake on attack impacts that gets more intense if the target is weak to the attack.
- A rudimentary condition system.
- Properly implemented controller support that adapts to controllers connecting and disconnecting (this is not native to GameMaker and had to be programmed manually).
  
**CHANGES:**

- Overhauled visuals (Purchased from the lovely penusbmic on itch.io)
- Overhauled UI (Made with elements from penusbmic, as well as fonts from the users "neatthings" and "Daniel Linssen" on itch.io)
- New Enemies with improved AI.
- New Actions and massive changes to the way actions are performed, allowing for actions that can hit multiple times.
- Better transitions to entering the battle and exiting it.



## To Review the Code:

GameMaker handles the storage of files for its users, in a way that is (in my humble opinion), very hard to navigate.

So in the interest of saving you the hassle, I'll point you to all of the important code.

**OBJECT SCRIPTS**
- [**oBattle's**](<>) Events:
  - [Create](<>) -
  - [Draw_64](<>) (Draw GUI):
  - [Step](<>) -
- [**oBattleUnit's**](<>) Events:
  - [Create](<>) -
- [**oMenu's**](<>) Events:
  - [Step](<>) -
  - [Draw_64](<>) -
- [**objBattleVictory's**](<>) Events:
  - [Step](<>) -
  - [Draw_64](<>) - 
- [**objBattleGameOver's**](<>) Events:
  - [Step](<>) - 
  - [Draw_64](<>) - 
- [**objCamera's**](<>) Events:
  - [Create](<>) -
- [**objControls'**](<>) Events:
  - [Step](<>) -

**GENRAL SCRIPTS**
- [**ActionLibrary**](<>) -
- [**Units**](<>) -
- [**GameData**](<>) - 
- [**Menu Functions**](<>) -
- [**Battle Functions**](<>) - 


## Credits:

- [**Sara Spaulding**](<>) - Creator of the Base Project and a couple of the art assets in the final build.
- [**penusbmic**](<>) - Creator of nearly all of the art assets used in the final build.
- [**neatthings**](<>) - Creator of the main font: "Spencer's Spooky Font"
- [**Daniel Linssen**](<>) - Creator of the font "M3x6", which is used in some UI elements

// When we start the battle sequence, stop all objects (Except the battle object) in the overworld.
// We do this first because oBattle creates a bunch of objects (like the camera or units), and we don't want those to be deactivated while the battle is running.
// with this function "true" means that the object running the code is not included in the function
instance_deactivate_all(true);
// Reactivate the controls because the battle wouldn't function without them.
instance_activate_object(objControls); 
// Create a an instance of objBattleCamera to allow for dynamic camera movement while in battle.
instance_create_depth(x, y, 0, objBattleCamera)



units = []; // This will hold a list of all our units.
unitRenderOrder = []; // This will determine the draw order of our units


 
turn = 0; // The amount of turns taken in the current round
turnCount = 0; // The total number of turns taken so far
roundCount = 0; // This keeps track of the current round number
last_round = 0; // This will be used to detect changes in roundCount so that we can reshuffle the turn order each round octopath style


unitTurnOrder = []; // This will hold the turn order for the current round
next_round_order = []; // This will be used to determine the next round's turn order


initiative_order = []; // This will be used to hold the current turn order to display, will be a duplicate of unitTurnOrder, but with all of the downed units filtered out.
next_round_display = []; // This will be used to hold the next turn's order for display, will be a duplicate of next_round_order, but with all of the downed units filtered out.



battle_buffer_left = 0; // This is a buffer timer that ensures no overlap between various phases. It is used in multiple places.
// These are the various numbers of frames that we want the buffer timer to last for.
battle_buffer_long = 60;
battle_buffer_mid = 30;
battle_buffer_small = 10;


// This will be updated later to show a description of the action at the top of the screen
battleText = "";

// Variables used for targeting
currentUser = noone;
currentAction = -1;
currentTargets = noone;

// All of the values needed for the targetting cursor.
cursor =
{
	activeUser : noone,
	activeTarget : noone,
	actionAction : -1,
	targetSide : -1,
	targetIndex : 0,
	targetAll : false,
	confirmDelay : 0, // Creates a small delay between inputs where a new input won't be processed.
	active : false
};


turnIsReal = true; // This ensures that the turn taken was an actual turn. This will keep turnCount accurate, as it will not register false turns (turns taken by downed units).


battle_mode = false; // Will be checked true once the battle has been initialized. Mostly used to stop certain code from running before the object is ready


action_stage = 0; // This is used in BattleStatePerformAction to let the function know which stage to of the action to perform.

// These are used to slide the battle's UI elements on and off screen.
ui_animate_lerp = 1; // A lerp value for the position of various parts of the draw event.
ui_lerp_speed = 1/20;

// Win Values
XP_yield = 0; // The amount of XP gained from the encounter
victory_move_complete = false; // Tracks whether the movement performed in the victory stage has been started.



//STATE MACHINE GO!
//The battle's turn system works through a cycle of states that determine the phase of each turn

// --- BATTLE START STATES ---
// -- BattleStateInit : Initializes the battle. Can be used to reset the current battle as well
// -- -- BattleStateBuffer: Acts as a buffer timer between BattleStateInit and BattleStateSelectAction. Also slides UI elements onto the screen.

// --- THE MAIN CYCLE ---
// -- BattleStateSelectAction : Handles the selection of the current user's action
// -- -- BeginAction : initializes the desired action with the desired inputs
// -- BattleStatePerformAction : Handles Unit movement, creates the needed instances of oBattleEffect at the correct spots, runs the desired combat effects
// -- BattleStateVictoryCheck : Checks to see if either side has no active units, ending the battle if so.
// -- BattleStateTurnProgression : Handles end of turn functions as well as end of round functions.

// --- BATTLE END STATES ---
// -- BattleStateVictory : Handles victory, including an xp rewards system, ending the battle once finished.
// -- BattleStateLoss : Game over screen, gives option to reset game or retry the same fight.


// --- START OF BATTLE STATES ---

	// --- INITIALIZATION --- (Sets initial values for the battle - Only runs once)
	function BattleStateInit()
	{
		// --- MAKE ENEMIES ---
	
		// Column will be used to offset enemies into seperate columns.
		var _column = 0;
		// These are the position anchors that all enemy unit positions will be offset from.
		var _enemy_anchor_X = x+200;
		var _enemy_anchor_Y = y+78;
	
		// A simple for loop that spawns in the enemy units called for in the NewEncounter function,
		// then uses them to populate an array that will be used to keep track of the enemy units ("enemyUnits")
		for (var i = 0; i < array_length(enemies); i++)
		{
			// When the number of enemies drawn hits a multiple of 3, we add a new column for them to draw along
			var _enemyCol = i mod 3;
			if (i != 0) {if (_enemyCol = 0) _column++;}
			// Each unit created here uses the variables from its matching struct!
			enemyUnits[i] = instance_create_depth(_enemy_anchor_X+(i*10)+(_column*20), _enemy_anchor_Y+(i*25)-(_column*65), depth-10, oBattleUnitEnemy, enemies[i]);
			// Once the unit is created, add it to the list of all units.
			array_push(units, enemyUnits[i]);
		
			// This part makes the units jump in from...
			if (i == 0)
			{
				// if the unit is the one who initiated the battle, it jumps from its original position.
				with (enemyUnits[i])
				{
					target_X = anchor_X;
					target_Y = anchor_Y;
					position_X = oBattle.creator.x;
					position_Y = oBattle.creator.y;
					move_state = move_state_jump;
				}
			}
			else
			{
				// Otherwise it comes from offscreen.
				with (enemyUnits[i])
				{
					target_X = anchor_X;
					target_Y = anchor_Y;
					position_X = oBattle.x + viewport_width;
					position_Y = anchor_Y;
					move_state = move_state_jump;
				}
			}
		}

		// --- MAKE THE PARTY ---
	
		// Same general idea as above, but with the party units instead.
		var _party_anchor_X = x+70;
		var _party_anchor_Y = y+78;
		for (var i = 0; i < array_length(global.party); i++)
		{
			partyUnits[i] = instance_create_depth(_party_anchor_X-(i*10), _party_anchor_Y+(i*25), depth-10, oBattleUnitPC, global.party[i]);
			array_push(units, partyUnits[i]);
		
			if (i == 0)
			{
				with (partyUnits[i])
				{
					target_X = anchor_X;
					target_Y = anchor_Y;
					position_X = oBattle.player.x;
					position_Y = oBattle.player.y;
					move_state = move_state_jump;
				}
			}
			else
			{
				with (partyUnits[i])
				{
					target_X = anchor_X;
					target_Y = anchor_Y;
					position_X = oBattle.x;
					position_Y = anchor_Y;
					move_state = move_state_jump;
				}
			}
		}

		// Generate the first round's turn order.
		// This will be emptied and refilled by the next round's turn order at the end of the current round.
		unitTurnOrder = array_shuffle(units);
		// Generate next round's turn order.
		// This will be emptied and reshuffled at the end of the current round.
		next_round_order = array_shuffle(units);

		// Then we use the turn orders to get their display duplicates. In the step event we'll filter out the downed units from both of them.
		array_copy(initiative_order, 0, unitTurnOrder, 0, array_length(unitTurnOrder));
		array_copy(next_round_display, 0, next_round_order, 0, array_length(next_round_order));

		// Get Render Order
		// This function will take the units array, then copy it into a new array that has been freshly emptied
		// It will then sort that array into a new order according to their y values.
		// This is to make sure that units that are higher than other units are not drawn over them.
		RefreshRenderOrder = function()
		{
			unitRenderOrder = [];
			array_copy(unitRenderOrder, 0, units, 0, array_length(units));
	
			array_sort(unitRenderOrder, (function(_1, _2){ return _1.y - _2.y; }) );
		}
		RefreshRenderOrder();
	
		// Set action Stage to 0 on the off chance it isn't already.
		action_stage = 0;
	
		// Now that everything is ready, set battle_mode to true and prep the next state before exiting the current state.
		battle_mode = true;
		battle_buffer_left = battle_buffer_long;
		battleState = BattleStateBuffer;
	}

	// --- WAIT FOR UNITS TO GET IN POSITION ---
	// Before we start the first turn, we want to give a little bit of time for all the units to get in place
	function BattleStateBuffer()
	{
		// As the units jump in, slide the UI elements in as well.
		ui_animate_lerp -= ui_lerp_speed;
		if (ui_animate_lerp <= 0) ui_animate_lerp = 0;
	
		battle_buffer_left--;
	
		// once the buffer finishes, enter the select action state
		if (battle_buffer_left == 0)
		{
			battle_buffer_left = 0;
			battleState = BattleStateSelectAction;
		}
	}


// --- THE MAIN CYCLE ---

	// --- SELECT ACTION ---
	function BattleStateSelectAction()
	{
		// First we check to see if there is already a menu active. If there is, we skip everything here because it only needs to run once.
		if (!instance_exists(oMenu))
		{
			// Get Current Unit
			var _unit = unitTurnOrder[turn];
			// Check if that unit dead or unable to act.
			if (!instance_exists(_unit)) || (_unit.hp <= 0)
			{
				// If so, we set the turn as a false turn, then we exit the current state and check to see if the battle needs to end.
				turnIsReal = false;
				battleState = BattleStateVictoryCheck;
				exit;
			}
			// Otherwise, set the turn as a real turn and proceed as normal.
			turnIsReal = true;
	
	
			// Check if the unit is player controlled, if so:
			if (_unit.object_index == oBattleUnitPC)
			{
				// Set up variables to compile the action menu
				// An array of options
				var _menuOptions = [];
				// A struct containing the current submenus
				var _subMenus = {};
				// Grab the current unit's action list and keep it here as a reference (NOT AS A COPY)
				var _actionList = _unit.actions;
			
			
			
			
			
				// This loop will run for each entry in the current unit's action list
				// It does so with the goal of converting the action list into arrays of usable variables and sorting them into the proper submenu arrays
				for (var i = 0; i < array_length(_actionList); i++)
				{
					// Set up a local variable to reference the current loop's entry in the action list.
					var _action = _actionList[i];
				
					// Here we set up a variable that will store whether the current action can be performed
					var _available = true;
					// We check to see if the action's struct contains an mpCost variable.
					if (variable_struct_exists(_action, "mpCost"))
					{
						// If that mpCost is higher than the current unit's current mp, the action is set to be unavailable
						if (_unit.mp < _action.mpCost) {_available = false;}
						// Otherwise, it's set to be available.
						else{_available = true;};
					}
				
					// Here we create a variable that will store the name of the current action as found in its struct.
					var _name = _action.name;
				
					// Now that we have the values we need, we put them all into this struct which can be fed into a function later.
					var _this_option_struct = 
					{
						name: _name,            // -- The action's name
						func: MenuSelectAction, // -- The necessary function to activate it, which in this case is the function that activates the current action
						args: [_unit, _action], // -- An array of arguments for the above function containing: The current unit, and this loop's action
						available: _available   // -- Whether the current action is available.
					}
				
					// If the action has it's submenu listed as -1 (i.e. it is an option on the opening menu)...
					if (_action.subMenu == -1)
					{
						// We add it to the end of the _menuOptions array using the above struct.
						array_push(_menuOptions, _this_option_struct);
					}
					// Otherwise... (i.e. the current loop's action has a listed submenu)
					else
					{
						// First we check if the _subMenus struct currently has a submenu with the same name as the one called for by the current action.
						if (is_undefined(_subMenus[$ _action.subMenu]))
						{
							// If it DOES NOT, add a new submenu it to the _subMenus struct, with the action's called for submenu as it's name
							// We set this submenu as an array, using the current option's struct from above as its first value.
							variable_struct_set(_subMenus, _action.subMenu, [_this_option_struct]);
						}
						//Otherwise... (i.e. the _subMenus struct does indeed have a matching submenu)
						else
						{
							//then we can just add the current action's info strcut to the end of the correct submenu array
							array_push(_subMenus[$ _action.subMenu], _this_option_struct);
						}
					}
				}
			
			
				//Now we take the info stored in the _subMenus Struct we just populated and convert them into usable arrays themselves
				var _subMenusArray = variable_struct_get_names(_subMenus);
				for (var i = 0; i < array_length(_subMenusArray); i++)
				{	
					//This adds a "back" option to each submenu that will return the user to the above menu level. (the cancel button also does this)
					array_push(_subMenus[$ _subMenusArray[i]], {name: "Back", func: MenuGoBack, args: -1, available: true});
				
					//Using the same process as above for the main menu actions, we add the submenus to the main menu.
					array_push(_menuOptions, {
												name: _subMenusArray[i],				// -- The name of the submenu
												func: SubMenu,							// -- The function we call for the options is the function for submenu navigation
												args: [_subMenus[$ _subMenusArray[i]]], // -- A reference to the args needed for the SubMenu function, which is an array of options that the submenu contains.
												available: true							// -- Whether the submenu is available (always true)
											});
				}
			
				// Index will be used to get the menus to draw above a given party member's UI elements. 
				var _index = array_get_index(partyUnits, _unit)
				//calls the menu function at a set location, with a set width, using _menuOptions to populate it.
				Menu(6+(_index * 89), 100, _menuOptions, 80, 44);
			}
		
		
		
			//Otherwise, if the current unit is NOT player controlled:
			else
			{
				//We call the unit's AI script
				var _enemyAction = _unit.AIscript();
				//We check to see if that AI script hasn't returned -1, which we will use as a fail state
				if (_enemyAction != -1)
				{
					//if it hasn't failed, then initialize the action.
					BeginAction(_unit.id, _enemyAction[0], _enemyAction[1]);
				}
			}
		}
	}

	// --- START A UNIT'S ACTION ---
	function BeginAction(_user, _action, _targets)
	{
		//Set up our variables using the info called for
		currentUser = _user;
		currentAction = _action;
		currentTargets = _targets;
	
		//Check if current targets isn't an array.
		//if it isn't already an array, we'll turn it into a single entry array with the same info contained within
		if (!is_array(currentTargets)) currentTargets = [currentTargets];
	
		//Create a new string that replaces the description's placeholders with the current unit's and targets' names if needed
		name_array = [currentUser.name]; 
		for (var i = 0; i < array_length(currentTargets); i++;)
		{
			array_push(name_array, currentTargets[i].name);
		}
		battleText = string_ext(_action.description, name_array);

		//Then we set up our buffer frames 
		battle_buffer_left = battle_buffer_small;

		//once the action is initialized, we'll update the battleState to run it.
		battleState = BattleStatePerformAction;
	
	}

	// --- RUN THE ACTION ---
	// By far the most complicated, so strap in.
	function BattleStatePerformAction()
	{
		// --- STAGE 0 --- (Moving to the target)
		if (action_stage == 0)
		{
			// First we check to see if the action is a Long-Range Action. If so, move to the next stage because no movement is required.
			if (currentAction.range == RANGE.LONG) { action_stage = 1; }
			// Otherwise...
			else
			{
				// Check to see if the User has completed its movement already. If so, move to the next stage.
				if currentUser.move_complete { action_stage = 1; }
				else
				{
					// Otherwise (if the unit is still moving), set the camera to follow the currentUser...
					with (objBattleCamera)
					{
						focus_unit = oBattle.currentUser;
						camera_mode = zoom_in;
					}
				
					// Then set the target position for the currentUser's movement.
					if (currentAction.range == RANGE.MELEE)
					{
						// If the action is a melee action, jump directly to the target unit.
						with (currentUser)
						{
							target_X = oBattle.currentTargets[0].anchor_X;
							target_Y = oBattle.currentTargets[0].anchor_Y;
						}
					}
					else
					{
						// Otherwise, if the action is mid-ranged, jump to a set point in front of all targets.
						with (currentUser)
						{
							target_X = oBattle.currentTargets[0].anchor_X;
							target_Y = oBattle.y+88;
						}
					}
					// Once the target position is set, get currentUser moving!
					with (currentUser)
					{
						// Offset the target position a little bit so the user jumps in front of the target, not on them.
						if (object_index == oBattleUnitEnemy) target_X += 20;
						else target_X -= 20;
						position_X = anchor_X;
						position_Y = anchor_Y;
						move_state = move_state_jump;
					}
				}
			}
		
		}
	
		// --- STAGE 1 --- (Just a small buffer between arrival and starting the attack action)
		else if (action_stage == 1)
		{
			battle_buffer_left--;
			if (battle_buffer_left == 0)
			{
				battle_buffer_left = 0;
				action_stage = 2;
			}
		}
	
		// --- STAGE 2 --- (Set up the user's animation, runs for a single frame)
		else if (action_stage == 2)
		{
			// We reach into the current user's object to change a couple things
			with (currentUser)
			{
				// Play user animation if it is defined for that action, and the animation is defined for the user in their sprites struct.
				if (!is_undefined(oBattle.currentAction[$ "userAnimation"])) && (!is_undefined(oBattle.currentUser.sprites[$ oBattle.currentAction.userAnimation]))
				{
					// Update the user's sprite index to the action's user animation, and set the animation to the first frame.
					sprite_index = sprites[$ oBattle.currentAction.userAnimation];
					image_index = 0;
				}
				else
				{
					// Otherwise, set the user's sprite to its attack animation.
					sprite_index = sprites.attack;
					image_index = 0;
				}
			}
			// Once all of that is done, move on to the next stage.
			action_stage = 3;
		}
	
		// --- STAGE 3 --- (Play all animations, Run action functions, Play action effects)
		else if (action_stage == 3)
		{
			// All action sprites have designated frames that update their user's "broadcast_message" value for a single frame.
			// If the current frame is one of those frames...
			if (currentUser.broadcast_message != "")
			{
				// Then check to see if the current action has an effect sprite
				if (variable_struct_exists(currentAction, "effectSprite"))
				{
					// If it does, run the action's function
					currentAction.func(currentUser, currentTargets);
				
					// Set the direction the effect moves in according to whether the current user is an enemy or party member
					var _attack_dir = -1;
					if (currentUser.object_index == oBattleUnitEnemy) { _attack_dir = 1; }
				
					// Then check to see if the action's effect is meant to play on top of the target.
					if (currentAction.effectOnTarget == true)
					{
						// If it does, create an instance of oBattleEffect over top of each target
						for (var i = 0; i < array_length(currentTargets); i++)
						{
							instance_create_depth(currentTargets[i].x, currentTargets[i].y, currentTargets[i].depth-1, oBattleEffect, {sprite_index : currentAction.effectSprite, image_xscale: _attack_dir});
						}
					}
					else //otherwise, if the effect is meant to play over the whole screen, play it at 0, 0
					{
						//set up the sprite to use
						var _effectSprite = currentAction.effectSprite
						//check to see if there is an alternate full screen sprite and use that instead.
						if (variable_struct_exists(currentAction, "effectSpriteNoTarget")) _effectSprite = currentAction.effectSpriteNoTarget;
						instance_create_depth(x, y, depth-100, oBattleEffect, {sprite_index : _effectSprite});
					}
				}
			}
		
		
			// Then check and see if the currentUser's action animation has reach it's end.
			if (currentUser.image_index >= currentUser.image_number - 1)
			{
				// If so, we reach into the user's object again and reset the things we changed above back to their defaults
				with (currentUser)
				{
					sprite_index = sprites.idle;
					image_index = 0;
				}
			
				// Set the length of a buffer timer for use later.
				// If the action was long range, set it short. Otherwise, set it long.
				if (currentAction.range == RANGE.LONG) { battle_buffer_left = battle_buffer_small; }
				else { battle_buffer_left = battle_buffer_long; }
			
				// And finally, move on to the the next stage.
				action_stage = 4;
			}
		}
	
		// --- STAGE 4 --- (Get the Unit to move back to its anchor position - Effectively runs for a single frame.)
		else if (action_stage == 4)
		{
			//check to see if any oBattleEffect instances remain (We want the user to stay until they're finished.)
			if (!instance_exists(oBattleEffect))
			{
				// Then check if the attack was a ranged attack, if so, skip the movement the same way we did above.
				if (currentAction.range == RANGE.LONG) { action_stage = 5; }
				else 
				{
					// Otherwise, set the camera to move back to fullscreen mode.
					with (objBattleCamera)
					{
						camera_mode = fullscreen;
					}
					// Then check if the unit isn't already jumping, if it isn't, then tell it to jump!
					if (currentUser.move_state != currentUser.move_state_jump)
					{
						with (currentUser)
						{
							target_X = anchor_X;
							target_Y = anchor_Y;
							move_state = move_state_jump;
						}
					}
					// Clear battleText to make the description box disappear.
					battleText = "";
					// Then move on to the next stage.
					action_stage = 5;
				}
			
			}
		}
		// --- STAGE 5 --- (Buffer and move on)
		else if (action_stage == 5)
		{
			// Run the buffer timer we set above and once it's finished, move on to BattleStateVictoryCheck
			battle_buffer_left--;
			if (battle_buffer_left == 0)
			{
				battle_buffer_left = 0;
				battleState = BattleStateVictoryCheck;
			}
		}

	}

	// --- CHECK IF EITHER SIDE WON ---
	function BattleStateVictoryCheck()
	{
		//This function creates two arrays, one for active enemies and one for active allies
		//If the turn reaches this stage and either one has zero active units, the battle will end. if not, it will progress to the next turn.
		var _activeEnemies = array_filter(enemyUnits, (function(_element, _index) { return _element.hp > 0; }) );
		var _activeAllies = array_filter(partyUnits, (function(_element, _index) { return _element.hp > 0; }) );
	
	
	
		// If there are no active enemies, move to the victory state
		if(array_length(_activeEnemies) == 0) { battleState = BattleStateVictory; }
		// If there are no active allies, move to the loss state
		else if (array_length(_activeAllies) == 0) { battleState = BattleStateLoss; }
		// And if both sides still have active units, progress to the next turn.
		else { battleState = BattleStateTurnProgression; }
	}

	// --- END OF ROUND ---  (Perform end of turn/round updates and move on to the next turn)
	function BattleStateTurnProgression()
	{
		// Reset action stage so it can be used for the perform state on the next turn.
		action_stage = 0;
		// Set last round to equal the current round count as of the curren turn.
		last_round = roundCount;
		// Increment the current turn
		turn++;
	
		// the turn was a real turn...
		if (turnIsReal)
		{
			// Increment the total turn count
			turnCount++;
			// Remove the current entry from the beginning of the initiative_order array (This removes the first entry of the display, keeping it up to date)
			array_delete(initiative_order, 0, 1);
		}
	
	
		// If the newly incremented current turn is higher than the amount of entries in the array... (i.e. this was the last turn of the round)
		if (turn > array_length(unitTurnOrder) - 1)
		{
			// Reset it to 0, restarting from the beginning of the turn order and increment the roundCount
			turn = 0;
			roundCount++;
		}
	
		// Check and see if the roundCount has been updated
		if (roundCount != last_round)
		{
			// If it has, set the order of the incoming round to be the order of the next round that was on display.
			array_copy(unitTurnOrder, 0, next_round_order, 0, array_length(next_round_order));
			// Then empty the next round order array, and then refill it with a new shuffle of the same data
			array_delete(next_round_order, 0, array_length(next_round_order));
			next_round_order = array_shuffle(units);
		
			// Update arrays used for the displays
			array_copy(initiative_order, 0, unitTurnOrder, 0, array_length(unitTurnOrder));
			array_copy(next_round_display, 0, next_round_order, 0, array_length(next_round_order));
		
			// Once complete, increment last_round, making it equal to roundCount
			last_round++;
		}
	
		// And finally, we reset battleState back to BattleStateSelectAction.
		battleState = BattleStateSelectAction;
	}



// --- END OF BATTLE STATES ---

	// --- VICTORY --- (Make a victory screen, add XP rewards, update HP and MP, level up if needed.)
	function BattleStateVictory()
	{
		// Calculate XP Yield by looping through the enemies and adding their XP reward data
		for (i = 0; i < array_length(enemyUnits); i++) { XP_yield += enemyUnits[i].xpValue; }
		// Update party HP and MP values to reflect the in-battle values
		for (i = 0; i < array_length(partyUnits); i++)
		{
			global.party[i].hp = partyUnits[i].hp;
			global.party[i].mp = partyUnits[i].mp;
		}
	
		// Make the UI elements slide offscreen.
		ui_animate_lerp += ui_lerp_speed;
		if (ui_animate_lerp >= 1) ui_animate_lerp = 1;
	
	
		// Make party units jump offscreen, or back to their original spot if the unit is the party leader.
		if victory_move_complete == false
		{
			for (var i = 0; i < array_length(global.party); i++)
			{	
				if (i == 0)
				{
					with (partyUnits[i])
					{
						target_X = oBattle.player.x;
						target_Y = oBattle.player.y;
						position_X = anchor_X;
						position_Y = anchor_Y;
						move_state = move_state_jump;
					}
				}
				else
				{
					with (partyUnits[i])
					{
						target_X = oBattle.x - 10;
						target_Y = anchor_Y;
						position_X = anchor_X;
						position_Y = anchor_Y;
						move_state = move_state_jump;
					}
				}
			}
			victory_move_complete = true;
		}
	
		// Set the XP_total into a struct for the victory screen
		var victory_screen = { XP_total: XP_yield }
		// If there isn't a victory screen already, then make one, passing the XP_total into it.
		if !instance_exists(objBattleVictory) instance_create_depth(x, y, -11000, objBattleVictory, victory_screen);
	
	}

	// --- GAME OVER --- (Make a Game Over screen, give option to reset battle, or restart the game.)
	function BattleStateLoss()
	{
		// Make the UI elements slide offscreen.
		ui_animate_lerp += ui_lerp_speed;
		if (ui_animate_lerp >= 1) ui_animate_lerp = 1;
	
		// Data needed for the game over screen
		var game_over_screen = 
		{
			battle_parent: self,
			deadStartX: partyUnits[0].x - oBattle.x,
			deadStartY: partyUnits[0].y - oBattle.y,
		}
		// If there isn't a Game Over screen already, then make one, passing the above struct into it.
		if !instance_exists(objBattleGameOver) instance_create_depth(x, y, -11000, objBattleGameOver, game_over_screen)
	}


battleState = BattleStateInit;
// --- STUFF IN THIS SCRIPT ---
// FUNCTIONS
// -- NewEncounter
// -- BattleChangeHP
// -- BattleChangeMP
// -- LevelUp
// -- VictoryXPReward
// -- draw_enemy_healthbar
// -- reset_battle
// CONDITIONS
// -- _no_condition
// -- _standard_debuff
// -- _standard_buff



// --- FUNCTIONS ---

	// --- CREATE A NEW ENCOUNTER ---
	function NewEncounter(_enemies, _player)
	{
		instance_create_depth
		(
			camera_get_view_x(view_camera[0]),
			camera_get_view_y(view_camera[0]),
			-9999,
			oBattle,
			{enemies : _enemies, creator: id, player: _player }
		);
	}

	// --- CHANGE THE TARGET'S HP ---
	function BattleChangeHP(_target, _amount, _moveInUse, _AliveDeadOrEither = 0)
	{
		//_AliveDeadOrEither: 0 = alive only, 1 = dead only, 2 = any
	
		// If the action can't be performed on the target, set _failed to true.
		var _failed = false;
		if (_AliveDeadOrEither == 0) && (_target.hp <= 0) _failed = true;
		if (_AliveDeadOrEither == 1) && (_target.hp > 0) _failed = true;
	
	
	
		// Variable Defaults
		var _typeMultiplier = 1; // The multiplier applied, changes if the target is weak to the attack type.
		var _col = UI_gold;		 // The colour of the text of the damage indicator
		var _scale = 1;			 // The Scale of the damage indicator
		var _dir = -1;			 // The direction the damage indicator will be sent flying from the target (up by default)
	
		// Check whether the target is an enemy or ally to determine _dir
		if (_target.object_index == oBattleUnitEnemy) { _dir = 0; }
		if (_target.object_index == oBattleUnitPC) { _dir = 1; }
	
		// Determine whether the action deals damage or heals
		if (_amount > 0) _col = c_lime; // If it heals, turn the text green.
		if (_amount < 0)
		{
			// If it deals damage, check if the target is weak to the attack.
			if (array_contains(_target.weakness, _moveInUse.actionType))
			{
				// If it is, turn the text red, make it 50% bigger, and boost the damage multiplier to 2X
				_col = c_red;
				_scale = 1.5;
				_typeMultiplier = 2;
			}
		}
		// Apply the multiplier to the damage amount.
		var _finalAmount = _amount * _typeMultiplier;
	
		// If the attack failed make the damage indicator say "missed" instead.
		if (_failed)
		{
			_col = c_white;
			_scale = 0.5;
			_finalAmount = "missed";
		}
	
		// Create the damage indicator (oBattleFloatingText), and pass everything needed for it.
		instance_create_depth
		(
			_target.x,
			_target.y,
			_target.depth-1,
			oBattleFloatingText,
			{font: fontGame, col: _col, text: string(_finalAmount), scale: _scale, dir: _dir}
		);
	
		// Apply the final change amount, clamping it between 0 and its max value
		if (!_failed) _target.hp = clamp(_target.hp + _finalAmount, 0, _target.hpMax);
	
		// If the action is an attack and it hits...
		if (is_real(_finalAmount)) && (_finalAmount < 0)
		{
			// Apply screen shake!
			if  (_typeMultiplier == 1)
			{
				with (objBattleCamera)
				{
					shake_time = 30;
					shake_magnitude = 10;
					current_shake_magnitude = 10;
				}
			}
			// If the target is weak to the attack, double the amount of screen shake
			if (_typeMultiplier > 1)
			{
				with (objBattleCamera)
				{
					shake_time = 50;
					shake_magnitude = 20;
					current_shake_magnitude = 20;
				}
			}
		}
	}

	// --- CHANGE MP AMOUNT ---
	function BattleChangeMP(_user, _amount)
	{
		_user.mp = clamp(_user.mp + _amount, 0, _user.mpMax);
	}

	// --- LEVEL UP ---
	function LevelUp()
	{
		// This is a very stripped down version of a level up system
		// Whenever this function is run, the hpMax, mpMax, strength and magic of all party members increase by set amounts.
		global.levelManager.level++;
		for (i = 0; i < array_length(global.party); i++)
		{
			global.party[i].hpMax += 10;
			global.party[i].hp += 10;
			oBattle.partyUnits[i].hp += 10;
			global.party[i].mpMax += 5;
			global.party[i].mp += 5;
			oBattle.partyUnits[i].mp += 5;
		
			global.party[i].strength += 2;
			global.party[i].magic += 2;
		}
	}

	// --- APPLY XP TO PARTY ---
	function VictoryXPReward(_amount)
	{
		global.levelManager.totalXP += _amount;
	}

	// --- DRAW HEALTHBARS IN THE TARGETTING PHASE ---
	function draw_enemy_healthbar(_target)
	{
		_enemyHpMax = _target.hpMax;
		_enemyHp = _target.hp;
		_enemyHpLerp = _enemyHp / _enemyHpMax;
		_enemyHpBarWidthMax = 5 * (floor(_enemyHpMax / 5));
	
		// If the target has more than 6 hpMax, draw a properly nine_sliced healthbar, increasing in length for every 5 hp.	
		if (_enemyHpBarWidthMax > 6)
		{
			_enemyHpBarWidthMax -= 1;
			_enemyHpBarWidth = lerp(0, (_enemyHpBarWidthMax), _enemyHpLerp);
			draw_sprite_stretched_ext(sprBarFrame, 0, ((_target.x - oBattle.x) - (_enemyHpBarWidthMax/2)), ((_target.y - oBattle.y) + 2), (_enemyHpBarWidthMax + 2), 6, c_white, 1);
			draw_sprite_stretched_ext(sRectangle, 0, ((_target.x - oBattle.x) - (_enemyHpBarWidthMax/2) + 1), ((_target.y - oBattle.y) + 4), _enemyHpBarWidth, 2, c_red, 1);
			draw_sprite(sprBarArrow, 0, (_target.x - oBattle.x + 0.5), ((_target.y - oBattle.y) + 3))
		}
		//If the target has less than 6 hpMax, draw a smaller version of the healthbar that does not scale.
		else
		{
			_enemyHpBarWidthMax += 1;
			_enemyHpBarWidth = lerp(0, (_enemyHpBarWidthMax), _enemyHpLerp);
			draw_sprite(sprBarFrameSingle, 0, ((_target.x - oBattle.x) - (_enemyHpBarWidthMax/2)), ((_target.y - oBattle.y) + 3));
			draw_sprite_stretched_ext(sRectangle, 0, ((_target.x - oBattle.x) - (_enemyHpBarWidthMax/2) + 1), ((_target.y - oBattle.y) + 4), _enemyHpBarWidth, 2, c_red, 1);
			draw_sprite(sprBarArrow, 0, (_target.x - oBattle.x + 0.5), ((_target.y - oBattle.y) + 3))
		}
	}

	// --- RESET BATTLE ---
	function reset_battle()
	{
		// Reach into the menu and deactivate it.
		with (oMenu) active = false;
		// Reaches into the oBattle object and resets the variables, then puts it back into the initialization stage
		with (oBattle)
		{
			// --- RESET VARIABLE DEFAULTS --- 
			units = [];
			unitRenderOrder = [];
			turn = 0;
			turnCount = 0;
			roundCount = 0;
			last_round = 0;
			unitTurnOrder = [];
			next_round_order = [];
			initiative_order = [];
			next_round_display = [];
			battle_buffer_left = 0;
			battle_buffer_long = 60;
			battle_buffer_mid = 30;
			battle_buffer_small = 10;
			battleText = "";
			currentUser = noone;
			currentAction = -1;
			currentTargets = noone;
			cursor =
			{
				activeUser : noone,
				activeTarget : noone,
				actionAction : -1,
				targetSide : -1,
				targetIndex : 0,
				targetAll : false,
				confirmDelay : 0,
				active : false
			};
			turnIsReal = true;
			battle_mode = false;
			action_stage = 0;
			ui_animate_lerp = 1;
			ui_lerp_speed = 1/20;
			XP_yield = 0;
			victory_move_complete = false;

			battleState = BattleStateInit;
		}
		// Destroy the Game Over Screen and its Menu
		instance_destroy(oMenu);
		instance_destroy(objBattleGameOver);
	}


// --- CONDITIONS ---
	// note: condition effects are applied to a unit by looping through an array of conditions the unit has.
	//		 as a result, all units always have the _no_condition condition applied, 
	//       because the unit needs it in order to make sure its stats don't decrease or increase exponentially


	// _no_condition sets all of the unit's effective stats to equal their base stats.
	function _no_condition(_stats, _effective_stats)
	{	
		_effective_stats.effective_strength = _stats.strength;
		_effective_stats.effective_magic = _stats.magic;
		_effective_stats.effective_defence = _stats.defence;
		_effective_stats.effective_agility = _stats.agility;
		_effective_stats.effective_luck = _stats.luck;
	}

	// _standard_debuff halves the Unit's effective strength, magic and defence
	function _standard_debuff(_stats, _effective_stats)
	{
		_effective_stats.effective_strength *= 0.5;
		_effective_stats.effective_magic *= 0.5;
		_effective_stats.effective_defence *= 0.5;
	}

	// _standard_debuff doubles the Unit's effective strength, magic and defence
	function _standard_buff(_stats, _effective_stats)
	{
		_effective_stats.effective_strength *= 1.5;
		_effective_stats.effective_magic *= 1.5;
		_effective_stats.effective_defence *= 1.5;
	}
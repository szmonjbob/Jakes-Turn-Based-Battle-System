// --- ACTION LIBRARY ---
// LIST OF ACTIONS
// -- template ---------- template for creating new actions
// -- attack ------------ standard attack action
// -- slash ------------- alternate attack action
// -- combo_attack ------ The Player's signature move, attacks 3 times.
// -- ice --------------- standard ice spell
// -- fire -------------- standard fire spell
// -- Ultimate ---------- Extremely strong AOE damage ability, used for testing victory screens
// -- debuff ------------ standard debuff ability
// -- buff -------------- standard buff ability
// -- flame_lord_attack - the boss's basic attack action, hits twice
// -- dark_flame -------- the boss's standard single target spell
// -- blazing_lunge ----- the boss's signature blazing lunge, hits all enemies



global.actionLibrary = 
{
	//I'll walk you through how our skills are structured!
	template : 
	{
		//name is the string that shows in the action menu to represent this action
		name : "Template Action",
		//description is the string that pops up when the attack action is performed
		description : "{0} performs an action!",
		//submenu is typically a string that is used to see what submenu the action is sorted into.
		//-1 in this case means that it will not be sorted into a menu and will instead be put on the main menu.
		subMenu : -1,
		
		//This one determines the action's type for the sake of weaknesses and resistances
		actionType : TYPE.SHARP,
		//This determines the action's range
		range: RANGE.MELEE,
		
		//How much MP (or SP) the action takes to perform
		mpCost : 0,
		//The base power of the action if it deals damage or heals.
		potency : 0,
		

		//Whether the action requires a target
		targetRequired : true,
		//This variable stores whether or not the opposite side is targetted by default.
		targetEnemyByDefault : true, // false: target party // true: target enemy
		//This variable stores whether the action targets all units on side or not
		targetAll : false, //-- TRUE: the skill targets all -- FALSE: the skill targets one

		//This calls the user's relevant animation using a string name (these animations are stored in their "sprites" struct.)
		userAnimation : "attack",
		//This stores the action's relevant effect sprite
		effectSprite : sAttackBonk,
		//This whether the above sprite effect is supposed to play at the target location.
		effectOnTarget : true,
		
		
		//func is a function that holds the entirety of what the action is supposed to do!
		//I'll take notes on the func section of each action afterwards, unless there are repeats.
		func : function(_user, _targets){}
	},
	//The basic attack action!
	attack : 
	{
		name : "Attack",
		description : "{0} attacks!",
		actionType : TYPE.BLUNT,
		range: RANGE.MELEE,
		mpCost : 0,
		potency : 5,
		subMenu : -1,
		targetRequired : true,
		targetEnemyByDefault : true,
		targetAll : false,
		userAnimation : "attack",
		effectSprite : sprHit_4,
		effectOnTarget : true,
		func : function(_user, _targets)
		{
			// We loop through all targets (in this case only one because it's a single target move)
			for (var i = 0; i < array_length(_targets); i++)
			{
				// Here is the damage formula I'm using --- (Attack Potency * (user strength / target defence) * a random variance of 10% in either direction)
				var _damage = ceil(self.potency * (_user.effective_stats.effective_strength / _targets[i].effective_stats.effective_defence) * random_range(0.9, 1.1));
				// Now that we have the base damage, we run that through a function that runs it through any potential multipliers/nullifiers and then applies it to the target's HP.
				BattleChangeHP(_targets[0], -_damage, self, 0);
			}
		}
	},
	// Identical to the above skill, but with a different damage type.
	slash : 
	{
		name : "Attack",
		description : "{0} attacks!",
		actionType : TYPE.SHARP,
		range: RANGE.MELEE,
		mpCost : 0,
		potency : 5,
		subMenu : -1,
		targetRequired : true,
		targetEnemyByDefault : true,
		targetAll : false,
		userAnimation : "attack",
		effectSprite : sprHit_3,
		effectOnTarget : true,
		func : function(_user, _targets)
		{
			for (var i = 0; i < array_length(_targets); i++)
			{
				var _damage = ceil(self.potency * (_user.effective_stats.effective_strength / _targets[i].effective_stats.effective_defence) * random_range(0.9, 1.1));
				BattleChangeHP(_targets[0], -_damage, self, 0);
			}
		}
	},
	// At a glance it's identical to slash, but this one is hooked up to an animation that will run it three times.
	combo_attack : 
	{
		name : "Combo",
		description : "{0} does a sick combo!",
		actionType : TYPE.SHARP,
		range: RANGE.MELEE,
		mpCost : 1,
		potency : 5,
		subMenu : "Skills",
		targetRequired : true,
		targetEnemyByDefault : true,
		targetAll : false,
		userAnimation : "combo",
		effectSprite : sprHit_3,
		effectOnTarget : true,
		func : function(_user, _targets)
		{
			for (var i = 0; i < array_length(_targets); i++)
			{
				var _damage = ceil(self.potency * (_user.effective_stats.effective_strength / _targets[i].effective_stats.effective_defence) * random_range(0.9, 1.1));
				BattleChangeHP(_targets[0], -_damage, self, 0);
			}
			BattleChangeMP(_user, -mpCost);
		}
	},
	//A standard ice spell!
	ice : 
	{
		name : "Ice",
		description : "{0} casts Ice!",
		actionType : TYPE.ICE,
		range: RANGE.LONG,
		subMenu : "Skills",
		mpCost : 4,
		potency : 5,
		targetRequired : true,
		targetEnemyByDefault : true,
		targetAll : false,
		userAnimation : "cast",
		effectSprite : sprHitIce,
		effectOnTarget : true,
		func : function(_user, _targets)
		{
			for (var i = 0; i < array_length(_targets); i++)
			{
				var _damage = ceil(self.potency * (_user.effective_stats.effective_magic / _targets[i].effective_stats.effective_defence) * random_range(0.9, 1.1));
				BattleChangeHP(_targets[i], -_damage, self);
			}
			BattleChangeMP(_user, -mpCost);
		}
	},
	//A standard fire spell!
	fire : 
	{
		name : "Fire",
		description : "{0} casts Fire!",
		actionType : TYPE.FIRE,
		range: RANGE.LONG,
		subMenu : "Skills",
		mpCost : 4,
		potency : 5,
		targetRequired : true,
		targetEnemyByDefault : true,
		targetAll : false,
		userAnimation : "cast",
		effectSprite : sprFlameBurst,
		effectOnTarget : true,
		func : function(_user, _targets)
		{
			for (var i = 0; i < array_length(_targets); i++)
			{
				var _damage = ceil(self.potency * (_user.effective_stats.effective_magic / _targets[i].effective_stats.effective_defence) * random_range(0.9, 1.1));
				BattleChangeHP(_targets[i], -_damage, self);
			}
			BattleChangeMP(_user, -mpCost);
		}
	},
	// An ultimate attack that deals a ton of damage (mostly used for testing purposes)
	Ultimate : 
	{
		name : "Ultimate",
		description : "{0} wins!",
		actionType : TYPE.BIG,
		range: RANGE.MID,
		subMenu : "Skills",
		mpCost : 10,
		potency : 10,
		targetRequired : true,
		targetEnemyByDefault : true, //0: party/self, 1: enemy
		targetAll : true,
		userAnimation : "attack",
		effectSprite : sprHit_4,
		effectOnTarget : true,
		func : function(_user, _targets)
		{
			for (var i = 0; i < array_length(_targets); i++)
			{
				var _damage = ceil(self.potency * (_user.effective_stats.effective_magic / _targets[i].effective_stats.effective_defence) * random_range(0.9, 1.1));
				BattleChangeHP(_targets[i], -_damage, self);
			}
			BattleChangeMP(_user, -mpCost);
			
		}
	},
	// A standard debuffing ability
	debuff : 
	{
		name : "Debuff",
		description : "{0} debuffs {1}!",
		actionType : TYPE.NONE,
		range: RANGE.LONG,
		subMenu : "Skills",
		mpCost : 5,
		potency : 0,
		targetRequired : true,
		targetEnemyByDefault : true,
		targetAll : false,
		userAnimation : "cast",
		effectSprite : sprPoison_3,
		effectOnTarget : true,
		func : function(_user, _targets)
		{
			for (var i = 0; i < array_length(_targets); i++)
			{
				if (!array_contains(_targets[i].conditions, _standard_debuff))
				{
					array_push(_targets[i].conditions, _standard_debuff);
					with _targets[i] {event_user(0)}
				}
			}
		}
	},
	// A standard buffing ability
	buff : 
	{
		name : "Buff",
		description : "{0} Buffs {1}!",
		actionType : TYPE.NONE,
		range: RANGE.LONG,
		subMenu : "Skills",
		mpCost : 5,
		potency : 0,
		targetRequired : true,
		targetEnemyByDefault : false,
		targetAll : false,
		userAnimation : "cast",
		effectSprite : sAttackHeal,
		effectOnTarget : true,
		func : function(_user, _targets)
		{
			for (var i = 0; i < array_length(_targets); i++)
			{
				if (!array_contains(_targets[i].conditions, _standard_buff))
				{
					array_push(_targets[i].conditions, _standard_buff);
					with _targets[i] {event_user(0)}
				}
			}
		}
	},
	// The boss's basic attack, might seem a little weak, but the boss uses it twice in a row.
	flame_lord_attack : 
	{
		name : "Attack",
		description : "{0} strikes!",
		actionType : TYPE.FIRE,
		range: RANGE.MELEE,
		subMenu : -1,
		mpCost : 0,
		potency : 5,
		targetRequired : true,
		targetEnemyByDefault : true,
		targetAll : false,
		userAnimation : "attack",
		effectSprite : sprHitBlood_2,
		effectOnTarget : true,
		func : function(_user, _targets)
		{
			for (var i = 0; i < array_length(_targets); i++)
			{
				var _damage = ceil(self.potency * (_user.effective_stats.effective_strength / _targets[i].effective_stats.effective_defence) * random_range(0.9, 1.1));
				BattleChangeHP(_targets[0], -_damage, self, 0);
			}
			BattleChangeMP(_user, -mpCost);
		},
	},
	// The Boss's signature ranged spell.
	dark_flame : 
	{
		name : "Dark Flame",
		description : "{0} casts Dark Flame!",
		actionType : TYPE.FIRE,
		range: RANGE.LONG,
		subMenu : "Skills",
		mpCost : 7,
		potency : 7,
		targetRequired : true,
		targetEnemyByDefault : true,
		targetAll : false,
		userAnimation : "cast",
		effectSprite : sprDarkFlame_2,
		effectOnTarget : true,
		func : function(_user, _targets)
		{
			for (var i = 0; i < array_length(_targets); i++)
			{
				var _damage = ceil(self.potency * (_user.effective_stats.effective_magic / _targets[i].effective_stats.effective_defence) * random_range(0.9, 1.1));
				BattleChangeHP(_targets[i], -_damage, self);
			}
			BattleChangeMP(_user, -mpCost);
		},
	},
	// The Boss's Signature attack
	blazing_lunge : 
	{
		name : "Blazing Lunge",
		description : "{0} uses Blazing Lunge!",
		actionType : TYPE.FIRE,
		range: RANGE.MID,
		subMenu : "Skills",
		mpCost : 7,
		potency : 10,
		targetRequired : true,
		targetEnemyByDefault : true,
		targetAll : true,
		userAnimation : "stab",
		effectSprite : sprFlameBurst,
		effectOnTarget : true,
		func : function(_user, _targets)
		{
			for (var i = 0; i < array_length(_targets); i++)
			{
				var _damage = ceil(self.potency * (_user.effective_stats.effective_magic / _targets[i].effective_stats.effective_defence) * random_range(0.9, 1.1));
				BattleChangeHP(_targets[i], -_damage, self);
			}
			BattleChangeMP(_user, -mpCost);
		},
	},
}
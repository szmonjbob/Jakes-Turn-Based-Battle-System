// --- ALLY DATA ---
//Any time we wish to add a new party member, Build it in the global.allies struct and then add a reference to it in the global.party array (directly below the global.allies struct in this script)
global.allies =
{
	player :
	{
		//The name of the party member
		name: "The Fighter",
		//HP/MP Meter numbers
		hp: 89,
		hpMax: 89,
		mp: 15,
		mpMax: 15,
		//STATS
		strength: 6,
		magic: 4,
		defence: 6,
		agility: 5,
		luck: 5,
		//the party member's weaknesses
		weakness : [],
		//a struct that establishes the unit's various animations and sprites
		sprites : { idle: sprPlayerIdle, attack: sprPlayerAttack, down: sprPlayerDown, portrait: sprPlayerPortrait, jump: sprPlayerJump, combo: sprPlayerComboAttack},
		//the list of actions it will be able to perform
		actions : [global.actionLibrary.slash, global.actionLibrary.combo_attack]
	}, 
	sage :
	{
		name: "The Sage",
		
		hp: 54,
		hpMax: 54,
		mp: 30,
		mpMax: 30,
		
		strength: 4,
		magic: 6,
		defence: 5,
		agility: 5,
		luck: 5,
		
		weakness : [],
		sprites : { idle: sprSageIdle, attack: sprSageAttack, cast: sprSageCast, down: sprSageDown, portrait: sprSagePortrait, jump: sprSageJump},
		actions : [global.actionLibrary.attack, global.actionLibrary.ice, global.actionLibrary.fire, global.actionLibrary.buff, global.actionLibrary.debuff]
	}
}
// --- THE PARTY ---
global.party = 
[
	global.allies.player,
	global.allies.sage
]




// --- ENEMY DATA --- (much of the data is structurally similar to the allies, so I'll only point out the relevant bits)
global.enemies =
{
	slicer: 
	{
		name: "Slicer",
		hp: 30,
		hpMax: 30,
		mp: 0,
		mpMax: 0,
		
		strength: 5,
		magic: 2,
		defence: 3,
		agility: 3,
		luck: 5,
		
		weakness : [TYPE.FIRE],
		sprites: { idle: sprSlicerIdle, attack: sprSlicerAttack, portrait: sprSlicerPortrait, down: sprSlicerDown, jump: sprSlicerJump},
		actions: [global.actionLibrary.slash, global.actionLibrary.debuff],
		
		// The amount of XP this enemy gives when defeated
		xpValue : 50 ,
		// The script that determines what the enemy does on it's turn.
		AIscript : function()
		{
			// This enemy picks a random action from it's abilities...
			var _action = actions[irandom(array_length(actions)-1)];
			// Filters downed enemies from it's potential targets
			var _possibleTargets = array_filter(oBattle.partyUnits, (function(_unit, _index) { return (_unit.hp > 0); }) );
			// Then picks a random target that remains.
			var _target = _possibleTargets[irandom(array_length(_possibleTargets)-1)];
			return [_action, _target];
		}
	},
	tiny_bug: 
	{
		name: "Tiny Bug",
		hp: 5,
		hpMax: 5,
		mp: 0,
		mpMax: 0,
		
		strength: 4,
		magic: 3,
		defence: 2,
		agility: 7,
		luck: 5,

		weakness : [],
		sprites: { idle: sprSmallBugIdle, attack: sprSmallBugAttack, portrait: sprSmallBugPortrait, down: sprSmallBugDeath},
		actions: [global.actionLibrary.slash, global.actionLibrary.buff],
		xpValue : 18,
		AIscript : function()
		{
			// This enemy picks a random action from it's abilities...
			var _action_index = irandom(array_length(actions)-1)
			var _action = actions[_action_index];
			
			// If that action is it's attack ability, it does the same thing as the one above did.
			if (_action.targetEnemyByDefault)
			{
				var _possibleTargets = array_filter(oBattle.partyUnits, (function(_unit, _index) { return (_unit.hp > 0); }) );
				var _target = _possibleTargets[irandom(array_length(_possibleTargets)-1)];
				return [_action, _target];
			}
			// But if it's using it's buff ability, it targets its allies instead, picking a random one to buff
			else if (!_action.targetEnemyByDefault)
			{
				var _possibleTargets = array_filter(oBattle.enemyUnits, (function(_unit, _index) { return (_unit.hp > 0); }) );
				var _target = _possibleTargets[irandom(array_length(_possibleTargets)-1)];
				return [_action, _target];
			}
		}
	},
	flame_lord: 
	{
		name: "The Lord of Flames",
		hp: 100,
		hpMax: 100,
		mp: 0,
		mpMax: 0,
		
		strength: 10,
		magic: 7,
		defence: 10,
		agility: 5,
		luck: 7,

		weakness : [],
		sprites: { idle: sprFlameLordIdle, attack: sprFlameLordAttack, portrait: sprFlameLordPortrait, down: sprFlameLordDeath, jump: sprFlameLordJump, cast: sprFlameLordCast, buff: sprFlameLordBuff, stab: sprFlameLordChainStab},
		actions: [global.actionLibrary.flame_lord_attack, global.actionLibrary.dark_flame, global.actionLibrary.blazing_lunge],
		xpValue : 100,
		AIscript : function()
		{
			// Select random action
			var _action = actions[irandom(array_length(actions)-1)];
			
			// Target random party member
			var _target = 0;
			var _possibleTargets = array_filter(oBattle.partyUnits, (function(_unit, _index) { return (_unit.hp > 0); }) );
			
			if (_action.targetAll) // If action is multi-target
			{
				// Target all potential targets
				_target = _possibleTargets;
			}
			else // If action is single target
			{
				// Target a random enemy
				_target = _possibleTargets[irandom(array_length(_possibleTargets)-1)];
			}
			
			return [_action, _target];
		}
	}
}

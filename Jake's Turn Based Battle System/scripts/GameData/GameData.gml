// --- STUFF IN THIS SCRIPT ---
// -- Macros
// -- levelManager
// -- party
// -- Enums


// --- MACROS ---
#macro viewport_width 320
#macro viewport_height 180
#macro UI_brown #231D15
#macro UI_gold #FFF07A


// --- LEVEL MANAGER --- (keeps track the party's level, the amount of xp they have and the xp needed to level up)
global.levelManager =
{
	totalXP : 0,
	level : 0,
	levelUpXP : [0, 100, 200, 300, 400, 500, 600],
}




// --- ENUMS ---

// MODE is essentially a boolean with 3 states instead of 2.
enum MODE
{
	NEVER = 0,
	ALWAYS = 1,
	VARIES = 2
}
// RANGE Determines where the user is attacking from
enum RANGE
{
	MELEE = 0, // Up close and personal - Usually for single target attacks
	MID = 1, // Close, but not focused - Usually for multi-target attacks
	LONG = 2 // Long Range
}
// TYPE determines The kind of damage an attack does - some enemies are weak to certain types.
enum TYPE
{
	NONE = 0,
	SHARP = 1,
	BLUNT = 2,
	ICE = 3,
	FIRE = 4,
	LIGHTNING = 5,
	BIG = 6
}




sprite_index = sprites.idle;

// --- VARIABLES ---

hp = clamp(hp, 0, hpMax)
mp = clamp(hp, 0, mpMax)

// This will be the position the unit will return to when it is not acting.
anchor_X = x;
anchor_Y = y;
// This will store the position the unit is currently at (if still) or leaving (if moving)
position_X = 0;
position_Y = 0;
// This will store the position the unit is moving to.
target_X = 0;
target_Y = 0;

// tracking variables necessary for scripted movement.
move_stage = 0; // 0 - Just starting to move; 1 - moving; 2 - finished moving
move_progress = 0; // the current lerp value for movement
move_complete = false;

// this will be updated when the unit's sprite sends out a broadcast, will be used to signal the battle manager when an action function needs to be performed.
broadcast_message = "";

// the local animation index for animations with multple directions.
animation_index = 0;
animation_end = false;

// the unit's base stats.
stats = 
{
	strength,
	magic,
	defence,
	agility,
	luck
}
// the user's effective stats, will be modified by conditions.
effective_stats = 
{
	effective_strength: 0,
	effective_magic: 0,
	effective_defence: 0,
	effective_agility: 0,
	effective_luck: 0
}

// Everything needed for conditions
conditions = [_no_condition]; // an array containing all active conditions, has the "_no_conditions" condition by default because it sets effective stats to equal base stats.
event_user(0); // Call User Event 0, which runs through all conditions and applies their effects


// --- MOVEMENT STATES ---

// Idle - the unit doesn't move and plays through its set animation.
function move_state_idle()
{
	move_stage = 0;
	move_progress = 0;
	move_complete = false;
	
	x = position_X;
	y = position_Y;
}

// Jump - the standard state for moving from one place to another. 
function move_state_jump()
{
	// Check if the unit has a jump sprite, if so set it to the jump sprite.
	if (variable_struct_exists(sprites, "jump")) sprite_index = sprites.jump;
	
	// Constants
	var _move_speed = 1/50; // the speed at which the lerp value will increase
	var _jump = -2; // the initial speed for a jump.
	var _gravity = 2/25; // the deceleration rate of gravity.
	
	// On the first frame of a jump, set all changing values to their initial values.
	if (move_stage == 0)
	{
		move_progress = 0;
		animIndex = 0;
		jump_Y = 0;
		jump_speed = _jump;
		move_stage++;
	}
	
	// Update main lerp value
	move_progress += _move_speed;
	// Decelerate jump speed before applying it.
	jump_speed += _gravity; 
	jump_Y += jump_speed;
	
	// if the unit has a jump sprite, check and see if the unit is moving up or down, and update the animation accordingly.
	if (variable_struct_exists(sprites, "jump"))
	{
		if (sign(jump_speed) == -1) UpDownJumpAnimate(0)
		else if (sign(jump_speed) == 1) UpDownJumpAnimate(1)
	}

	// If the main lerp value surpasses it's maximum, cap it and move to the end stage.
	if (move_progress > 1) 
	{
		move_progress = 1;
		move_stage++;
	}
	
	// Use the main lerp value to determine the unit's postion on the floor.
	var _user_floor_X = lerp(position_X, target_X, move_progress);
	var _user_floor_Y = lerp(position_Y, target_Y, move_progress);
	
	// Set the unit's position, adding the jump height to unit's vertical postion over the floor.
	x = _user_floor_X;
	y = clamp(_user_floor_Y + jump_Y, _user_floor_Y - 30, _user_floor_Y);
	
	// If at the end stage, update values accordingly and then switch back to the idle state.
	if (move_stage == 2)
	{
		sprite_index = sprites.idle
		position_X = target_X;
		position_Y = target_Y;
		move_complete = true;
		move_state = move_state_idle;
	}
}



// this function just takes the verticle direction checked above, then updates the sprite's animation accordingly.
function UpDownJumpAnimate(_up_or_down) {
	// _up_or_down: 0 = up // 1 = down.
	
	// All jump sprites have an equal number of up and down frames.
	
	// So we can use the _up_or_down value to grab which half of the animation to use.
	var _animLength = sprite_get_number(sprite_index) / 2;
	image_index = animation_index + (_up_or_down * _animLength);
	animation_index += sprite_get_speed(sprite_index) / 60;

	//If animation would loop on next game step, reset it
	if (animation_index >= _animLength) { animation_index -= _animLength; }
}


move_state = move_state_idle;
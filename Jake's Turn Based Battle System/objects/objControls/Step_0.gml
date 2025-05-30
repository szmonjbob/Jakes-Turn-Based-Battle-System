/// @description Detect inputs

// --- UP ---
// (all of the code for this section repeats for each direction.)
// We check to see if the gamepad in use is having it's joystick moved upwards beyond the margin of error.
if (gamepad_axis_value(gamepad_slot, gp_axislv) < -0.5)
{
	//If so, grab update the respective variable
	up_gamepad_axis = abs(gamepad_axis_value(gamepad_slot, gp_axislv));
	
	//Check to see if it has been held that way for more than one frame.
	//then use the answer to update the respective flick value (single frame input) accordingly.
	if (up_frame_count == 0) { up_gamepad_axis_flick = 1; }
	else { up_gamepad_axis_flick = 0; }
	//Increment the frame counter for the input. (this will tell us that the input has been held on subsequent frames)
	up_frame_count++;
}
else
{
	// If it hasn't, then set everything to 0.
	up_gamepad_axis = 0;
	up_gamepad_axis_flick = 0;
	up_frame_count = 0;
}
// Set all inputs and clamp them between 0 and 1!
up_input = keyboard_check(vk_up) + keyboard_check(ord("W")) + gamepad_button_check(gamepad_slot, gp_padu) + up_gamepad_axis;
up_input = clamp(up_input, 0, 1);
up_input_pressed = keyboard_check_pressed(vk_up) + keyboard_check_pressed(ord("W")) + gamepad_button_check_pressed(gamepad_slot, gp_padu) + up_gamepad_axis_flick;
up_input_pressed = clamp(up_input_pressed, 0, 1);



// --- DOWN ---

if (gamepad_axis_value(gamepad_slot, gp_axislv) > 0.5)
{
	down_gamepad_axis = abs(gamepad_axis_value(gamepad_slot, gp_axislv));
	if (down_frame_count == 0) { down_gamepad_axis_flick = 1; }
	else { down_gamepad_axis_flick = 0; }
	down_frame_count++;
}
else
{
	down_gamepad_axis = 0;
	down_gamepad_axis_flick = 0;
	down_frame_count = 0;
}
down_input = keyboard_check(vk_down) + keyboard_check(ord("S")) + gamepad_button_check(gamepad_slot, gp_padd) + down_gamepad_axis;
down_input = clamp(down_input, 0, 1);
down_input_pressed = keyboard_check_pressed(vk_down) + keyboard_check_pressed(ord("S")) + gamepad_button_check_pressed(gamepad_slot, gp_padd) + down_gamepad_axis_flick;
down_input_pressed = clamp(down_input_pressed, 0, 1);

// --- LEFT ---
if (gamepad_axis_value(gamepad_slot, gp_axislh) < -0.5)
{
	left_gamepad_axis = abs(gamepad_axis_value(gamepad_slot, gp_axislh));
	if (left_frame_count == 0) { left_gamepad_axis_flick = 1; }
	else { left_gamepad_axis_flick = 0; }
	left_frame_count++;
}
else
{
	left_gamepad_axis = 0;
	left_gamepad_axis_flick = 0;
	left_frame_count = 0;
}
left_input = keyboard_check(vk_left) + keyboard_check(ord("A")) + gamepad_button_check(gamepad_slot, gp_padl) + left_gamepad_axis;
left_input = clamp(left_input, 0, 1);
left_input_pressed = keyboard_check_pressed(vk_left) + keyboard_check_pressed(ord("A")) + gamepad_button_check_pressed(gamepad_slot, gp_padl) + left_gamepad_axis_flick;
left_input_pressed = clamp(left_input_pressed, 0, 1);

// --- RIGHT ---

if (gamepad_axis_value(gamepad_slot, gp_axislh) > 0.5)
{
	right_gamepad_axis = abs(gamepad_axis_value(gamepad_slot, gp_axislh));
	if (right_frame_count == 0) { right_gamepad_axis_flick = 1; }
	else { right_gamepad_axis_flick = 0; }
	right_frame_count++;
}
else
{
	right_gamepad_axis = 0;
	right_gamepad_axis_flick = 0;
	right_frame_count = 0;
}
right_input = keyboard_check(vk_right) + keyboard_check(ord("D")) + gamepad_button_check(gamepad_slot, gp_padr) + right_gamepad_axis;
right_input = clamp(right_input, 0, 1);
right_input_pressed = keyboard_check_pressed(vk_right) + keyboard_check_pressed(ord("D")) + gamepad_button_check_pressed(gamepad_slot, gp_padr) + right_gamepad_axis_flick;
right_input_pressed = clamp(right_input_pressed, 0, 1);



// --- CONFIRM + CANCEL ---
confirm_input = keyboard_check_pressed(vk_space) + gamepad_button_check_pressed(4, gp_face1);
confirm_input = clamp(confirm_input, 0, 1);
cancel_input = keyboard_check_pressed(vk_escape) + gamepad_button_check_pressed(4, gp_face2);
cancel_input = clamp(cancel_input, 0, 1);
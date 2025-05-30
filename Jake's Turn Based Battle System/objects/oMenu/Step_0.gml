

// Initialize the menu by sliding it into place
if (!initialized)
{
	if (slide_lerp != 1)
	{
		slide_lerp += lerp_speed;
		slide_height = lerp(0, heightFull, slide_lerp);
	}
	else
	{
		slide_lerp = 1;
		active = true;
		initialized = true;
	}
}


// If the menu is active:
if (active)
{
	// Set Menu Controls
	hover += objControls.down_input_pressed - objControls.up_input_pressed;
	// Wrap menu
	if (hover > array_length(options) -1) hover = 0;
	if (hover < 0) hover = array_length(options) -1;
	
	// If the user hits the confirm input, execute the selected option if it exists and is available.
	if (objControls.confirm_input)
	{
		if (struct_names_count(options[hover]) > 1) && (options[hover].available == true)
		{
			if (options[hover].func != -1) 
			{
				var _func = options[hover].func;
				if (options[hover].args != -1) script_execute_ext(_func, options[hover].args);
				else script_execute_ext(_func)
			}
		}
	}
	// Move back up through menu levels if the user hits the cancel input.
	if (objControls.cancel_input)
	{
		if (subMenuLevel > 0) MenuGoBack();
	}
}
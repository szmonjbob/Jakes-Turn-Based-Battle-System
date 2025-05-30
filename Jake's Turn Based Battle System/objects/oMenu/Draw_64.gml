
// If the menu is still sliding in draw the frame sliding.
if (!initialized)
{
	draw_sprite_stretched(sprBoxesFilled, 2, position_X, (position_Y + heightFull - slide_height), widthFull, slide_height);
}




// if the menu is active, draw the frame and then loop through the options, drawing them if they're supposed to be visible.
if (active)
{
	draw_sprite_stretched(sprBoxesFilled, 2, position_X, position_Y, widthFull, heightFull);

	draw_set_color(#FFF07A);
	draw_set_font(fontGame);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);

	var _text_width = 0;
	var _desc = (description != -1);

	var _visibleOptionsCorrected = visibleOptionsMax + 1
	var _scrollPush = max(0, hover - (_visibleOptionsCorrected));

	for (var i = 0; i < (_visibleOptionsCorrected + 1 + _desc); i++)
	{
		if (i >= array_length(options)) break;
		draw_set_color(#FFF07A);
		if (i == 0) && (_desc) draw_text((position_X + xmargin), (position_Y + ymargin), description);
		else
		{
			var _optionToShow = i - _desc + _scrollPush;
			var _str = options[_optionToShow].name;
		
			if (hover == _optionToShow - _desc) 
			{
				draw_set_color(#FFBD63);
				_text_width = string_width(_str) * 0.75;
			}
			if (options[_optionToShow].available == false) draw_set_color(c_gray);
		
			draw_text_transformed((position_X + xmargin), (position_Y + ymargin + (i * heightLine)), _str, 0.75, 0.75, 0);
		}
	}

	
	// These draw the indicators that show which option is being hovered on currently.
	draw_sprite(sprLeftRightArrow, 0, (position_X + xmargin + (((sin(get_timer()/100000)+1))/2) - 3),(position_Y + ymargin + ((hover - _scrollPush) * heightLine - 1) + 7));
	draw_sprite(sprLeftRightArrow, 1, (position_X + xmargin + _text_width + 2 - (((sin(get_timer()/100000)+1))/2)), (position_Y + ymargin + ((hover - _scrollPush) * heightLine - 1) + 7));
	
	
	// This section draws the "scroll bar" that shows how far through the active options you are.
	var _bar_zone = heightFull - 10
	var _bar_fraction = _bar_zone / array_length(options);
	var _bar_height = _bar_fraction * _visibleOptionsCorrected;

	if (_visibleOptionsCorrected < array_length(options))
	{
		draw_sprite(sprUpDownArrow, 0, (position_X + widthFull - 3), (position_Y + heightFull - 6 + ((sin(get_timer()/100000)+1))/2));
		draw_sprite(sprUpDownArrow, 1, (position_X + widthFull - 3), (position_Y + 6 - ((sin(get_timer()/100000)+1))/2));
		draw_sprite_stretched(sprListBar, 0, (position_X + widthFull - 5), (position_Y + 9 + (_scrollPush * _bar_fraction)), 1, (_visibleOptionsCorrected * _bar_fraction));
	}
}


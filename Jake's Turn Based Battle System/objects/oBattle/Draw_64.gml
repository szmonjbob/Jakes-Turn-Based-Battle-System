



if battle_mode
{
	for (var i = 0; i < array_length(partyUnits); i++)
	{
		var _margin = 3;
		var _portrait_frame = 26;
		var _HUD_portrait = (_portrait_frame - 4) / sprite_get_width(partyUnits[i].sprites.portrait);
		var _bar_width = 51;
		var _bar_height = 6;
		var _total_width = (_margin * 3) + _portrait_frame + _bar_width;
		var _total_height = (_margin * 2) + _portrait_frame; 
		var _position_X = 5 + (i*(_total_width + _margin));
		var _position_Y = viewport_height - lerp((_total_height + 5), 0, ui_animate_lerp);
		
		var _healthbar_width = lerp(0, _bar_width, (partyUnits[i].hp / partyUnits[i].hpMax));
		var _skillbar_width = lerp(0, _bar_width, (partyUnits[i].mp / partyUnits[i].mpMax));
		
		draw_set_font(fnM3x6);
		draw_set_color(c_white);
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
		
		var _text_height = 3;
		var _bar_margins = 3;
		
		var _bar_start_X = _position_X + _portrait_frame + (_margin * 2) - 2;
		var _bar_start_Y = _position_Y + 1;
		
		var _hp_string = "HP "+string(partyUnits[i].hp)+"/"+string(partyUnits[i].hpMax);
		var _sp_string = "SP "+string(partyUnits[i].mp)+"/"+string(partyUnits[i].mpMax);
		
		// --- BOXES ---
		draw_sprite_stretched(sprBoxesFilled, 0, _position_X, _position_Y, _total_width, _total_height);
		
		// --- PORTRAIT ---
		draw_sprite_ext(partyUnits[i].sprites.portrait, 0, (_position_X + _margin + 2), (_position_Y + _margin + 2), _HUD_portrait, _HUD_portrait, 0, c_white, 1);
		draw_sprite_stretched(sprBoxes, 9, (_position_X + _margin), (_position_Y + _margin), _portrait_frame, _portrait_frame);
		
		// --- HP ---
		draw_text_transformed((_bar_start_X + 1), (_bar_start_Y), _hp_string, 0.75, 0.75, 0);
		draw_sprite_stretched_ext(sRectangle, 0, _bar_start_X, (_bar_start_Y + _margin + _bar_margins + _text_height), _bar_width, _bar_height, c_black, 1);
		draw_sprite_stretched_ext(sRectangle, 0, (_bar_start_X + 1), (_bar_start_Y + _margin + _bar_margins + _text_height), (_healthbar_width - 2), _bar_height, c_red, 1);
		draw_sprite(sprResourceBarShort, 0, _bar_start_X, (_bar_start_Y + _margin + _bar_margins + _text_height));
		
		// --- SP ---
		draw_text_transformed((_bar_start_X + 1), (_bar_start_Y + _bar_height + _text_height + _bar_margins), _sp_string, 0.75, 0.75, 0);
		draw_sprite_stretched_ext(sRectangle, 0, _bar_start_X, (_bar_start_Y + _bar_height + _bar_margins + ((_margin + _text_height)*2)), _bar_width, _bar_height, c_black, 1);
		draw_sprite_stretched_ext(sRectangle, 0, (_bar_start_X + 1), (_bar_start_Y + _bar_height + _bar_margins + ((_margin + _text_height)*2)), (_skillbar_width - 2), _bar_height, c_aqua, 1);
		draw_sprite(sprResourceBarShort, 0, _bar_start_X, (_bar_start_Y + _bar_height + _bar_margins + ((_margin + _text_height)*2)));
	}
}
	



//DRAW UPCOMING INITIATIVE ORDER
draw_set_font(fnOpenSansPX);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
var _drawLimit = 3;
var _drawn = 0;
//Variables for portrait drawing
var _big_portrait_scale = 25;
var _portraitScale = 15;
var _highlight = c_red;
var _standard = c_white;
var _boxCol = _standard;
var _frame_margins = 2;
	// Position anchors for components
var _frame_anchor_Y = 10 - lerp(0, (10 + _big_portrait_scale), ui_animate_lerp);
var _portrait_anchor_Y = _frame_anchor_Y + _frame_margins;
var _big_frame_anchor_Y = _frame_anchor_Y - 5;
var _big_portrait_anchor_Y = _big_frame_anchor_Y + _frame_margins;

	
// This loop uses two arrays to determine its length, so more internal if conditions are needed.
// I made this decision because if I didn't it would take twice as much code to do the same thing.
for (var i = 0; i < (array_length(initiative_order) + array_length(next_round_display)); i++)
{
	//This variable will be used for the parts of the loop that draw the next round's display, essentially dividing the loop into two internal parts.
	//The first part handles this round (initiative_order) , the second part handles next round (next_round_display)
	var _locali = i - array_length(initiative_order);
		
		
	//First we check if the target select cursor is active, so we can then draw and manipulate various ui elements
	if (cursor.activeTarget != noone) && (cursor.active)
	{
		//If the current target is an array of targets, we set up an internal loop to run for each target.
		if (is_array(cursor.activeTarget))
		{
			for (var ii = 0; ii < array_length(cursor.activeTarget); ii++)
			{
				//This line checks the initiative order array and changes the box color for the display if that unit is being targeted.
				if (i <= array_length(initiative_order)-1) && (initiative_order[i] == cursor.activeTarget[ii]) { _boxCol = _highlight; }
				
				//This line does the same thing but for next_round_display
				else if (_locali >= 0) && (next_round_display[_locali] == cursor.activeTarget[ii]) { _boxCol = _highlight; }
			}
		}
		// Otherwise if there is only a single target
		else if (!is_array(cursor.activeTarget))
		{
			//This one handles display boxes in part 1, highlighting boxes if the unit is being targeted.
			if (i <= array_length(initiative_order) - 1) && (initiative_order[i] == cursor.activeTarget) { _boxCol = _highlight; }
			//This one handles display boxes in part 2, highlighting boxes if the unit is being targeted.
			else if (i > array_length(initiative_order) - 1) && (next_round_display[_locali] == cursor.activeTarget) { _boxCol = _highlight; }
			//And this one turns turns off highlights if neither of the above is true, i.e. the unit is not being targeted.
			else { _boxCol = _standard; }
		}
	}

//This one here turns all the boxes back to white once the targeting phase of battle is complete.
	if (cursor.active == false) { _boxCol = _standard; }
		
		
	// And finally, we can actually draw the initiative order display.
	// Each portrait is drawn based on the unit's called for portrait sprite, which in turn links the status of a unit to its display portrait.
	
	// The first portrait is drawn extra large to indicate the current turn
	if (i == 0) && (array_length(initiative_order)> i)
	{
		draw_sprite_stretched_ext(sprBoxesFilled, 4, 5, _big_frame_anchor_Y, (_big_portrait_scale + 4), (_big_portrait_scale + 4), _boxCol, 1);
		draw_sprite_stretched(initiative_order[i].sprites.portrait, 0, 7, _big_portrait_anchor_Y,_big_portrait_scale, _big_portrait_scale);
	}
	//Subsequent portraits in the current round are drawn smaller to the right of each previous portrait
	else if (i <= array_length(initiative_order)-1)
	{
		var _local_X = 15 + (i*18);
		draw_sprite_stretched_ext(sprBoxesFilled, 4, _local_X, _frame_anchor_Y, (_portraitScale + 4) , (_portraitScale + 4), _boxCol, 1);
		draw_sprite_stretched(initiative_order[i].sprites.portrait, 0, (_local_X + _frame_margins), _portrait_anchor_Y, _portraitScale, _portraitScale);
	}
	//And next round's turn order draws it's portraits separate from the others, halfway down the screen.
	else
	{
		var _local_X = (viewport_width / 2) + (_locali * 18);
		draw_sprite_stretched_ext(sprBoxesFilled, 4, _local_X, _frame_anchor_Y, (_portraitScale + 4), (_portraitScale + 4), _boxCol, 1);
		draw_sprite_stretched(next_round_display[_locali].sprites.portrait, 0, (_local_X + _frame_margins), _portrait_anchor_Y, _portraitScale, _portraitScale);
	}
// And finally, we switch the box colour to white, ensuring that the next loop uses white as the default again.
	_boxCol = _standard;
}

//Big text above the next round's display
draw_set_font(fontGame);
// TextOultine is a function I made for pixel fonts that draws the text 4 times, slightly offset before drawing a fifth time. This creates a coloured outline of the text.
TextOutline("NEXT ROUND", ((viewport_width / 2) + 2), -3 - lerp(0, (10 + _big_portrait_scale), ui_animate_lerp), , , UI_brown, UI_gold);





// Variables used for hp bar display
var _enemyHpMax = 0;
var _enemyHp = 0;
var _enemyHpLerp = 0;
var _enemyHpBarWidth = 0;
var _enemyHpBarWidthMax = 5;

//Draw target Health Bar when being targetted
if (cursor.active)
{
	with (cursor)
	{
		if (activeTarget != noone)
		{
			if (!is_array(activeTarget)) && (activeTarget.hp > 0)
			{
				// draw_enemy_healthbar is a function that does a bunch of math to determine the needed widths of all the UI elements and then draws them.
				draw_enemy_healthbar(activeTarget)
			}
			else
			{
				for (var i = 0; i < array_length(activeTarget); i++) 
				{ draw_enemy_healthbar(activeTarget[i]); }
			}
		}
	}
}



//Draw Battle text if it isn't empty.
if (battleText != "")
{
	var _w = (string_width(battleText) + 14) * 0.75;
	draw_sprite_stretched(sprBoxesFilled, 2, 160-(_w*0.5), 29, _w, 17);
	draw_set_halign(fa_center);
	draw_text_transformed(160, 31, battleText, 0.75, 0.75, 0);
}

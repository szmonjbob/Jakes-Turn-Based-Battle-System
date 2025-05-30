//Victory Screen 

//White Background
draw_sprite_stretched_ext(sRectangle, 0, 0, 0, screen_X, screen_Y, UI_brown, (fade_in/2))
//Portraits and XP

image_alpha = fade_in
draw_set_font(fontGame)
draw_set_color(UI_gold);
draw_set_halign(fa_center);
TextOutline((string("{0} XP earned", XP_total)), (screen_X/2), (screen_Y/4), 2, 2, #231D15, #FFF07A, fa_center)

		
draw_set_halign(fa_right);
draw_text_transformed(screen_X-25, (3*screen_Y/4)-15, string("XP until next Level - {0}", remaining_XP), 1, 1, 0);
draw_set_halign(fa_left);
draw_text_transformed(25, (3*screen_Y/4)-15, string("Level {0}",current_level), 1, 1, 0);
		
draw_sprite_stretched(sprBoxesFilled, 4, 20, (3*screen_Y/4), screen_X-40, 20);
draw_sprite_stretched_ext(sRectangle, 0, 23, (3*screen_Y/4)+3, bar_width_XP, 14, c_orange, fade_in);

draw_set_halign(fa_center);
image_alpha = (sin(get_timer() / 100000) + 1 ) / 2
if (victory_stage == 3) draw_text((screen_X/2), 5, "Press confirm to continue")

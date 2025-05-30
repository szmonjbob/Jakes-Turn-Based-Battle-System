   //GAME OVER DRAWN STUFF


//Black Background
draw_sprite_stretched_ext(sRectangle, 0, 0, 0, camera_get_view_width(view_camera[0]), camera_get_view_height(view_camera[0]), c_black, fade_in)
if (game_over_stage >= 1)
{
	//A little spotlight on the main character
	draw_ellipse_color((deadX - 50), (deadY - 20), (deadX + 50), (deadY + 20), c_white, c_black, false);
}
//The main character's limp body
draw_sprite(sprPlayerDown, 5, deadX, deadY);
if (game_over_stage == 2)
{
	//Game over text
	draw_set_color(c_red);
	draw_set_halign(fa_center);
	draw_set_font(fontGame);
	draw_text_transformed((camera_get_view_width(view_camera[0]) / 2), (camera_get_view_height(view_camera[0]) / 4) - 10, "GAME OVER", 2, 2, 0);
}

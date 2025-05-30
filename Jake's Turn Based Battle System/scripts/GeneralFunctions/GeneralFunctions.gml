// --- DRAW PIXEL TEXT WITH AN OUTLINE ---
function TextOutline(_string, _x, _y, _xScale = 1, _yScale = 1, _bgCol = c_black, _fgCol = c_white, _hAlign = fa_left, _vAlign = fa_top)
{
	draw_set_color(_bgCol);
	draw_set_halign(_hAlign);
	draw_set_valign(_vAlign);
	draw_text_transformed(_x-_xScale, _y, _string, _xScale, _yScale, 0);
	draw_text_transformed(_x+_xScale, _y, _string, _xScale, _yScale, 0);
	draw_text_transformed(_x, _y-_yScale, _string, _xScale, _yScale, 0);
	draw_text_transformed(_x, _y+_yScale, _string, _xScale, _yScale, 0);
	draw_set_color(_fgCol);
	draw_text_transformed(_x, _y, _string, _xScale, _yScale, 0);
}
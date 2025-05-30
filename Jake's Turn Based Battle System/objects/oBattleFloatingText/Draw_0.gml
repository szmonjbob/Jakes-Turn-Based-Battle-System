draw_set_font(fontGame);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_alpha(image_alpha);
TextOutline(text, x, y, scale, scale, UI_brown, col, fa_center, fa_middle);
draw_set_alpha(1.0);
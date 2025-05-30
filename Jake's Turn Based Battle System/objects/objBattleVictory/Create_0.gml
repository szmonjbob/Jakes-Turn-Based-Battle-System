screen_X = camera_get_view_width(view_camera[0]);
screen_Y = camera_get_view_height(view_camera[0]);

fade_in = 0;
fade_speed = 1/40;


victory_stage = 0;

lerp_progress_XP = 0;
lerp_speed_XP = 1/60;
lerp_max_XP = 0;
remaining_XP = 0;
bar_width_XP = 0;

current_level = global.levelManager.level;

box_X = x+20;
box_Y = y+(3*screen_Y/4);
box_width = screen_X-40;
box_height = 20;




//The minimum and maximum XP for the current party level, as well as the range between them.
current_level_min_XP = global.levelManager.levelUpXP[current_level];
current_level_max_XP = global.levelManager.levelUpXP[current_level + 1];
current_level_range_XP = current_level_max_XP - current_level_min_XP;

//The total amount of XP you had before the battle
current_XP = global.levelManager.totalXP;
//The total amount of XP you'll have after the battle
updated_XP = current_XP + XP_total;

//same as above, but relative to the current level (i.e. bounded within currentLevelRange)
current_level_progress_XP = current_XP - current_level_min_XP;
updated_level_progress_XP = updated_XP - current_level_min_XP;

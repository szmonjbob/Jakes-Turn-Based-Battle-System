//-- Transition to victory screen
if (victory_stage == 0)
{
	fade_in += fade_speed;
	
	if (fade_in > 1)
	{
		fade_in = 1;
		victory_stage = 1;
	}
}


//We're using victory stage to mark which stage of victory screen we should be on.
if (victory_stage == 1) 
{
	//At stage 1, we establish the lerp values for our display variables. 
	//This has to be done here to make use of our local variables and ensure it doesn't reset them to these values each frame. we want them to start here, not stay here.
	//Both will give decimal values on a scale of 0 to 1.
	//lerpMaxMp will surpass 1 when the amount of XP gained is more than is needed to level up. Will explain how this is handled later.
			
	//this one represents the value that will be used for displays, starts at the current amount of xp
	lerp_progress_XP = current_level_progress_XP / current_level_range_XP;
	//this one represents the value that will be used as a cap for the previous variable. Essentially the current amount of xp + the amoutn gained from this battle
	lerp_max_XP = updated_level_progress_XP / current_level_range_XP;
			
	//When spacebar is pressed, we progress to the next stage.
	victory_stage++;
}
		
if (victory_stage == 2)
{
	//at stage 1 we let the xp bar creep forward so long as it doesn't equal 1 (the level up cap) or lerp_max_XP (the amount of xp gained)
	if (lerp_progress_XP != 1) && (lerp_progress_XP != lerp_max_XP)
	{
		lerp_progress_XP += lerp_speed_XP;
		lerp_progress_XP = clamp(lerp_progress_XP, 0, min(lerp_max_XP, 1));
	}
	//when the value of lerp_progress_XP hits 1, that means we've leveled up before completing the process.
	//In order to reset the xp bar and allow it to continue...
	if (lerp_progress_XP == 1)
	{
		//we increase the current level by 1 to update all of the variables that use it.
		//This updates the bounds of the XP bar to match the new level, setting the previous levelup xp as the new base.
		current_level++;
		//then we reduce our lerp progress and maximum by 1
		//this is because 0 to 1 represents the space from the beginning (0) to the end (1) of the XP bar.
		//By reducing both numbers by 1, we can adjust the progress bar to match the new level.
		lerp_progress_XP -= 1;
		lerp_max_XP -= 1;
				
		//we then run a function that levels up the party members.
		//CURRENTLY A PLACEHOLDER THAT INCREASES A COUPLE STATS THE SAME WAY EACH TIME!!!!
		LevelUp();
	}
			
	//when the value of lerp_progress_XP hits lerp_max_XP, that means we've finished the process and can enable further progress through the victory screen.
	if (lerp_progress_XP == lerp_max_XP)
	{
		victory_stage++;
	}
}
		
//and now, with all of that finagling done pretty much exclusively to adjust lerp_progress_XP, we can finally actually use it.
//This will be used to draw the remaining amount of xp before level up
remaining_XP = floor(lerp(current_level_range_XP, 0, lerp_progress_XP))
//This will be used to draw the xp progress bar
bar_width_XP = lerp(0, box_width-6, lerp_progress_XP);


if (victory_stage == 3) && (objControls.confirm_input) { victory_stage++; }

if (victory_stage == 4)
{
	fade_in -= fade_speed;
	
	if (fade_in <= 0)
	{
		fade_in = 0;
		victory_stage = 5;
	}
}


	
//-- End Battle (Set to Trigger on a spacebar press that becomes available once the sequence completes.
//battle end code.
if (victory_stage == 5)
{
	VictoryXPReward(XP_total);
	instance_activate_all();
	with(oBattle)
	{
		instance_destroy(objBattleCamera);
		instance_destroy(creator);
		instance_destroy();
	}
	instance_destroy()
}
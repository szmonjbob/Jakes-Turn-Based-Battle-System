if (fade_in != 1) 
{
	fade_in += fade_in_speed;
}
else
{
	
	//when a game over occurs, we set a buffer timer. When the buffer has finished, move the dead player sprite to the center and then make the game over text appear.
	if (bufferTimer == -1) {bufferTimer = 60;}
		
	if (bufferTimer != 0) && (bufferTimer != -1) 
	{
		game_over_stage = 1;
		bufferTimer--;
	}
	else if (lerpProgress != 1)
	{
		//lerpProgress is clamped at 1 to ensure that it hits 1, exiting the current if statement and running the next one.
		lerpProgress += lerpSpeed;
		lerpProgress = clamp(lerpProgress, 0, 1);
		
	}

	deadX = lerp(deadStartX, deadEndX, lerpProgress);
	deadY = lerp(deadStartY, deadEndY, lerpProgress);
		
	if (lerpProgress == 1) 
	{
		game_over_stage = 2;
		// In order to not create a new menu every frame, check to see if one already exists before making one.
		if (!instance_exists(oMenu))
		{
			
			Menu(
				(camera_get_view_width(view_camera[0])/2) - 50, 
				120, 
				[
					{
						//Retry Battle: Restart battle from beginning and try again. (Reset battle defaults and set oBattle to BattleStateInit)
						name: "Restart Battle", 
						func: function() { reset_battle(); },
						args: -1,
						available: true
					},
					{
						//Restart game: Ideally it would start from the last save, but for now we'll just reset the game.
						//It works totally fine!
						name: "Restart Game",
						func: function() { game_restart(); },
						args: [],
						available: true
					}
				],
				100,
				27);
		}
	}
}

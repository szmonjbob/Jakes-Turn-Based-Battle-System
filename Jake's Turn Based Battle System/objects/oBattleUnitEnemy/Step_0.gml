event_inherited();
// if the enemy has no hp, change its sprite to the downed sprite.
if (hp <= 0)
{
	hp = 0;
	
	//if the enemy doesn't have a down sprite, then blend it red and make it fade.
	if (!variable_struct_exists(sprites, "down"))
	{
		image_blend = c_red;
		image_alpha -= 0.01;
	}	
	else
	{	
		if  (sprite_index != sprites.down)
		{
			sprite_index = sprites.down;
			image_index = 0;
		}
	}
}

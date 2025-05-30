event_inherited();

//if the enemy is downed, update it's sprite to match.
if (hp <= 0)
{
	if  (sprite_index != sprites.down)
	{
		sprite_index = sprites.down;
		image_index = 0;
	}
}
else
{
	//otherwise if it has been revived, bring back the idle sprite.
	if (sprite_index == sprites.down) sprite_index = sprites.idle;
}
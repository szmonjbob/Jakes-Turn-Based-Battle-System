if (battle_mode)
{
	//Once the battle is initialized, draw units in depth order
	var _unitWithCurrentTurn = unitTurnOrder[turn].id;
	for (var i = 0; i < array_length(unitRenderOrder); i++)
	{
		with (unitRenderOrder[i])
		{
			draw_self();
		}
	}
}
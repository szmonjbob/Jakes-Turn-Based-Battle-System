//Run State Machine
battleState();

// If the Battle is initialized, run the following code.
if (battle_mode)
{
	// Filter Downed Units from turn order display arrays
	initiative_order = array_filter(initiative_order, (function(_element, _index) { return _element.hp > 0; }) );
	next_round_display = array_filter(next_round_display, (function(_element, _index) { return _element.hp > 0; }) );

	// Targetting phase
	if (cursor.active)
	{
		with (cursor)
		{
			//Targetting Cursor Controls
			var _keyUp = objControls.up_input_pressed;
			var _keyDown = objControls.down_input_pressed;
			var _keyLeft = objControls.left_input_pressed;
			var _keyRight = objControls.right_input_pressed;
			var _keyConfirm = false;
			var _keyCancel = false;
			
			// Increment confirmDelay each frame for the buffer window.
			confirmDelay++;
			// Choosing an action creates a small window where cancel or confitm inputs won't be processed (If they did, it would skip the targetting phase)
			if (confirmDelay > 10)
			{
				_keyConfirm = objControls.confirm_input;
				_keyCancel = objControls.cancel_input;
			}
			var _moveH = _keyRight - _keyLeft;
			var _moveV = _keyDown - _keyUp;
		
		
			// If horizontal buttons are pressed, attempt to move the cursor sideways
			if (_moveH != 0) 
			{
				// Check to see if moving sideways is possible. if so move sideways.
				if !((targetIndex + (_moveH*3)) > (array_length(targetSide) - 1)) || !((targetIndex + (_moveH*3)) < 0)
				{ targetIndex += (_moveH*3); }
			}
			
			//Verify Target List / Remove dead enemies from enemy list
			if (targetSide == oBattle.enemyUnits)
			{
				targetSide = array_filter(targetSide, (function(_element, _index) { return _element.hp > 0; }) );
			}
		
			//Move between targets
			if (targetAll == false) //single target mode
			{
				if (_moveV == 1) targetIndex++;
				if (_moveV == -1) targetIndex--;
			
				//wrap
				var _targets = array_length(targetSide);
				if (targetIndex < 0) targetIndex = _targets - 1;
				if (targetIndex > (_targets - 1)) targetIndex = 0;
			
				//identify target
				activeTarget = targetSide[targetIndex];
			}
			else { activeTarget = targetSide; }
		
			//confirm action
			if (_keyConfirm)
			{
				with (oBattle) BeginAction(cursor.activeUser, cursor.activeAction, cursor.activeTarget);
				with (oMenu) instance_destroy();
				active = false;
				confirmDelay = 0;
			}
		
			//Cancel and return to menu
			if (_keyCancel)
			{
				with (oMenu) active = true;
				active = false;
				confirmDelay = 0;
			}
		}
	}
}
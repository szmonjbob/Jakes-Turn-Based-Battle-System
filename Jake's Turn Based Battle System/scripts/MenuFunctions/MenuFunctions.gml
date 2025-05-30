//FUNCTIONS
// -- Menu
// -- SubMenu
// -- MenuGoBack
// -- MenuSelectAction



// --- MAKE A MENU WITH SET BOUNDS)
function Menu(_x, _y, _options, _width, _height, _description = -1)
{
	// Here we set up an instance of oMenu, modifying it in the following ways:
	with (instance_create_depth(_x, _y, -12000, oMenu))
	{
		// Position anchors
		position_X = _x;
		position_Y = _y;
		// Set up a reference to the array we stuck in _options upon calling this function
		options = _options;
		// The description that we stuck in _description, set to -1 by default (not super useful for our purposes, but there's no use in deleting it)
		description = _description;
		// Local variable that keeps track of the amount of options
		var _optionsCount = array_length(_options);
		// This will be used to see if the amount of options that could potentially be visible is lower than the number of available options.
		visibleOptionsMax = _optionsCount;
		
		
		//Set up sizes of various elements
		xmargin = 7;		   //left/right margins
		ymargin = 2;		   //top/bottom margins
		heightLine = 9;		   //height of a line
		widthFull = _width;	   // Width of the box containing the options
		heightFull = _height;  // Height of the box containing the options
		//scrolling
		//we check to see if total height of all options is more than the viewable height
		if (heightLine * (_optionsCount + (description != -1)) > _height - (ymargin*2))
		{
			//if so, we set scrolling to true, to allow for the ability to scroll in the oMenu object
			scrolling = true;
			//and we set the visible option maximum to be the viewable height divided by the line height.
			visibleOptionsMax = (_height - (ymargin * 2) div heightLine);
		}
	}
}

// --- OPEN A SUBMENU ---
function SubMenu(_options)
{
	// Store old options in array and increase the submenu level
	optionsAbove[subMenuLevel] = options;
	subMenuLevel++;
	// The _options in this case are the submenu options
	options = _options;
	hover = 0;
}

// --- CLOSE A SUBMENU, MOVING BACK TO THE MAIN MENU ---
function MenuGoBack()
{
	subMenuLevel--;
	// Reset the options to the ones we stored in the SubMenu function
	options = optionsAbove[subMenuLevel];
	hover = 0;
}

// --- SELECT AN ACTION IN COMBAT ---
function MenuSelectAction(_user, _action)
{
	// Deactivate the Menu
	with (oMenu) { active = false; } 
	// Activate the targetting cursor if needed, or simply begin the action
	with (oBattle)
	{
		if (_action.targetRequired)
		{
			with (cursor)
			{
				active = true;
				activeAction = _action;
				targetAll = _action.targetAll;
				activeUser = _user;
				
				// See which side to target by default
				if (_action.targetEnemyByDefault) // Target enemy by default
				{
					targetIndex = 0;
					targetSide = oBattle.enemyUnits;
					activeTarget = oBattle.enemyUnits[targetIndex];
				}
				else // Target self by default
				{
					targetSide = oBattle.partyUnits;
					activeTarget = activeUser;
					var _findSelf = function(_element) { return (_element == activeTarget) }
					targetIndex = array_find_index(oBattle.partyUnits, _findSelf);
				}
			}
		}
		else
		{
			//If no target is needed, begin the action and end the menu
			BeginAction(_user, _action, -1);
			with (oMenu) { instance_destroy(); }
		}
	}
}

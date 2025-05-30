// objBattleCamera is a child of the oCamera object, which was made entirely by Sara Spaulding.
// I twist much of its function to make it into a dynamic battle camera.

// Inherit the parent event
event_inherited();

// battle_anchor is what we will use as an anchor point of this camera's bounding box.
battle_anchor = oBattle;

// focus_unit is the unit the camera is following while zoomed in.
focus_unit = oBattleUnitPC;

// values for screen shake
shake_magnitude = 0; // The initial magnitude of the screen shake
current_shake_magnitude = 0; // The current magnitude of screen shake
shake_time = 30; // the amount of frames the screen will shake for

// Zoom values
zoom_progress = 0; // Lerp value for zooming in/out
zoom_speed = 1/50; // Lerp speed for zooming in/out

// --- ZOOM IN A DIRECTION OF YOUR CHOICE ---
function zoom(zoom_dir)
{
	// Here we use our zoom_dir variable to determine which direction to zoom.
	if zoom_dir == "in" {zoom_progress -= zoom_speed;}
	else if zoom_dir == "out" {zoom_progress += zoom_speed;}
	
	// Keep the zoom amount clamped between 0 and 1, don't want to see any microbes now.
	zoom_progress = clamp(zoom_progress, 0, 1);
	
	// Use the zoom amount to calculate the size of the viewport.
	var view_X = lerp(viewport_width*0.75, viewport_width, zoom_progress);
	var view_Y = lerp(viewport_height*0.75, viewport_height, zoom_progress);
	camera_set_view_size(cam, view_X, view_Y);
	
	// Adjust our viewport correction values (these are inherited from the parent object)
	viewWHalf = camera_get_view_width(cam) * 0.5;
	viewHHalf = camera_get_view_height(cam) * 0.5;
}


// --- CAMERA STATE MACHINE ---

// ---  initial state ---
function initial()
{
	// Sets zoom progress to 1, indicating that it has fully zoomed out.
	zoom_progress = 1;
	// Set follow values to follow no one, because the bounding box gives no room to move when fully zoomed out anyway.
	xTo = x;
	yTo = y;
}

// --- Fullscreen ---
function fullscreen()
{
	// Identical to the initial state, except it runs the zoom function to zoom out.
	zoom("out");
	xTo = x;
	yTo = y;
}

// --- Zoomed In ---
function zoom_in()
{
	// Zooms in, then sets the follow values to follow the current focus unit.
	zoom("in");
	xTo = focus_unit.x;
	yTo = focus_unit.y;
}

camera_mode = initial;
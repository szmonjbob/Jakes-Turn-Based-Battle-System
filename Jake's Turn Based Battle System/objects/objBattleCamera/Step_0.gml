
// Run state machine
camera_mode();

// Update object position
x += (xTo - x) / 15;
y += (yTo - y) / 15;

//Keep camera centered inside of the battle's bounding box.
x = clamp(x, (battle_anchor.x + viewWHalf), battle_anchor.x + viewport_width - viewWHalf);
y = clamp(y, (battle_anchor.y + viewHHalf), battle_anchor.y + viewport_height - viewHHalf)

// Each frame decrease the current_shake_magnitude a fraction that will reduce it to zero after [shake_time] frames.
current_shake_magnitude = clamp((current_shake_magnitude - ((1/shake_time) * shake_magnitude)), 0, shake_magnitude);

// Calculate shake offset using a random range determined by the current_shake_magnitude
var _shake_X = random_range(-current_shake_magnitude, current_shake_magnitude);
var _shake_Y = random_range(-current_shake_magnitude, current_shake_magnitude)

// And finally, set the actual viewport position using the values we've established.
camera_set_view_pos(cam, (x - viewWHalf + _shake_X), (y - viewHHalf + _shake_Y) );
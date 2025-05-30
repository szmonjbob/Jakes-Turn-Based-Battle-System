var _inputH = objControls.right_input - objControls.left_input;
var _inputV = objControls.down_input - objControls.up_input;
var _inputD = point_direction(0,0,_inputH,_inputV);
var _inputM = clamp(point_distance(0,0,_inputH,_inputV), -1, 1);

if (_inputM != 0)
{
	sprite_index = run;
}
else
{
	sprite_index = idle;
}

if (_inputH < 0) { image_xscale = -1; }
else if (_inputH > 0) { image_xscale = 1; }


x += lengthdir_x(spdWalk*_inputM,_inputD);
y += lengthdir_y(spdWalk*_inputM,_inputD);



/// @desc decrease alpha and then die when invisible

image_alpha -= 0.03;
if (vspeed < 0) image_alpha = 1.0;
if (y > ystart) vspeed = 0;
if (image_alpha <= 0) instance_destroy();
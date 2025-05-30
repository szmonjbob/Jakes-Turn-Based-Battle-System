/// @description Detect new controller

if(async_load[? "event_type"] == "gamepad discovered")
{
	gamepad_slot = async_load[? "pad_index"];
}
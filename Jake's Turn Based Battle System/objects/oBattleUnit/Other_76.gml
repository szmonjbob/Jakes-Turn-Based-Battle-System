// If the unit's sprite sends out a broadcast event, update the broadcast message to reflect that.
if (event_data[? "event_type"] == "sprite event")
{
	broadcast_message = event_data[? "message"];
}




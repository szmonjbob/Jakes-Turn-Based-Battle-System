// Apply the current move state
move_state();

// Udpate the broadcast message to make sure it stays empty, because it only ever needs to be full for 1 frame.
broadcast_message = ""
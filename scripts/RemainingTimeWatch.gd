extends MeshInstance

func update_remaining_time(remaining_time_text):
	$Viewport/RemainingTime.set_text(remaining_time_text)

func reset_label(game_play_duration):
	$Viewport/RemainingTime.set_text(str(game_play_duration))

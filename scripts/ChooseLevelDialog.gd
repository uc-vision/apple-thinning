extends MeshInstance


signal play_training_game_pressed
signal play_time_attack_game_pressed
signal play_tutorial_game_pressed

func _on_TrainingGameButtonArea_area_entered(area):
	if "HandArea" in area.get_groups():
		emit_signal("play_training_game_pressed")


func _on_TimeAttackGameButtonArea_area_entered(area):
	if "HandArea" in area.get_groups():
		emit_signal("play_time_attack_game_pressed")


func _on_TutorialGameButtonArea_area_entered(area):
	if "HandArea" in area.get_groups():
		emit_signal("play_tutorial_game_pressed")


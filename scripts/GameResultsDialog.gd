extends MeshInstance

signal play_again_button_pressed
signal back_to_manu_button_pressed


func play_button_pressed_sound():
	$ButtonPressSoundPlayer.play()


func _on_PlayAgainButtonArea_area_entered(area):
	if "HandArea" in area.get_groups():
		play_button_pressed_sound()
		emit_signal("play_again_button_pressed")
		

func _on_BackToMenuButtonArea_area_entered(area):
	if "HandArea" in area.get_groups():
		play_button_pressed_sound()
		emit_signal("back_to_manu_button_pressed")

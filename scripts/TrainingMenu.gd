extends MeshInstance


signal exit_to_menu


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func play_button_press_sound():
	$ButtonPressSoundPlayer.play()


func _on_ExitToMenuGameButtonArea_area_entered(area):
	if "HandArea" in area.get_groups():
		#get_tree().root.get_node("Game/AudioStreamPlayer").play()
		#play_button_press_sound()
		emit_signal("exit_to_menu")



func _on_PreviousButtonArea_area_entered(area):
	$ButtonPressSoundPlayer.play()
	get_node("../../SceneController").next_scene(-1)
	pass # Replace with function body.


func _on_NextButtonButtonArea_area_entered(area):
	$ButtonPressSoundPlayer.play()
	get_node("../../SceneController").next_scene(1)
	pass # Replace with function body.


func _on_NextButtonButtonArea_area_exited(area):
	pass # Replace with function body.


func _on_PreviousButtonArea_area_exited(area):
	pass # Replace with function body.





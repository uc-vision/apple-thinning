extends MeshInstance


signal exit_to_menu
const VALUE = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	$TimerButtonLock.set_wait_time(VALUE)
	start_timer()
	pass # Replace with function body.

func is_Button_Lock():
	return $TimerButtonLock.is_stopped()

func start_timer():
	 $TimerButtonLock.start()

func play_button_press_sound():
	$ButtonPressSoundPlayer.play()


func _on_ExitToMenuGameButtonArea_area_entered(area):
	if "HandArea" in area.get_groups() and is_Button_Lock():
		#get_tree().root.get_node("Game/AudioStreamPlayer").play()
		#play_button_press_sound()
		emit_signal("exit_to_menu")



func _on_PreviousButtonArea_area_entered(area):
	if is_Button_Lock():
		start_timer()
		$ButtonPressSoundPlayer.play()
		get_node("../../SceneController").next_scene(-1)



func _on_NextButtonButtonArea_area_entered(area):
	if is_Button_Lock():
		start_timer()
		$ButtonPressSoundPlayer.play()
		get_node("../../SceneController").next_scene(1)



func _on_NextButtonButtonArea_area_exited(area):
	pass # Replace with function body.


func _on_PreviousButtonArea_area_exited(area):
	pass # Replace with function body.





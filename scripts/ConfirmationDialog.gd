extends MeshInstance

onready var wait_timer = $WaitTimer

signal confirm_exit_pressed
signal cancel_button_pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	wait_timer.set_one_shot(true)
	disable()
	
func enable(wait):
	if wait:
		wait_timer.start()
	else:
		$DialogPupUpSoundPlayer.play()
		set_visible(true)
		$ExitButton/ExitButtonArea.set_monitoring(true)
		$CancelButton/CancelButtonArea.set_monitoring(true)
		$ExitButton/ExitButtonArea/CollisionShape.set_disabled(false)
		$CancelButton/CancelButtonArea/CollisionShape.set_disabled(false)
	
func disable():
	set_visible(false)
	$ExitButton/ExitButtonArea.set_monitoring(false)
	$CancelButton/CancelButtonArea.set_monitoring(false)
	$ExitButton/ExitButtonArea/CollisionShape.set_disabled(true)
	$CancelButton/CancelButtonArea/CollisionShape.set_disabled(true)
	
func play_button_press_sound():
	$ButtonPressSoundPlayer.play()

func _on_ExitButtonArea_area_entered(area):
	if "HandArea" in area.get_groups():
		play_button_press_sound()
		emit_signal("confirm_exit_pressed")

func _on_CancelButtonArea_area_entered(area):
	if "HandArea" in area.get_groups():
		play_button_press_sound()
		emit_signal("cancel_button_pressed")

func _on_WaitTimer_timeout():
	enable(false)

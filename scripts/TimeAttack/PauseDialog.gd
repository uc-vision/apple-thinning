extends MeshInstance

onready var wait_timer = $WaitTimer

signal resume_button_pressed
signal exit_button_pressed


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
		$ResumeButton/ResumeButtonArea.set_monitoring(true)
		$ExitButton/ExitButtonArea.set_monitoring(true)
		$ResumeButton/ResumeButtonArea/CollisionShape.set_disabled(false)
		$ExitButton/ExitButtonArea/CollisionShape.set_disabled(false)
	
func disable():
	set_visible(false)
	$ResumeButton/ResumeButtonArea.set_monitoring(false)
	$ExitButton/ExitButtonArea.set_monitoring(false)
	$ResumeButton/ResumeButtonArea/CollisionShape.set_disabled(true)
	$ExitButton/ExitButtonArea/CollisionShape.set_disabled(true)
	
func play_button_pressed_sound():
	$ButtonPressSoundPlayer.play()

func _on_ResumeButtonArea_area_entered(area):
	if "HandArea" in area.get_groups():
		play_button_pressed_sound()
		emit_signal("resume_button_pressed")

func _on_ExitButtonArea_area_entered(area):
	if "HandArea" in area.get_groups():
		play_button_pressed_sound()
		emit_signal("exit_button_pressed")

func _on_WaitTimer_timeout():
	enable(false)

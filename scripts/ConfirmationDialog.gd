extends MeshInstance

onready var wait_timer = $WaitTimer
var signal_sent = false

signal confirm_exit_pressed
signal cancel_button_pressed

const GameMode = preload("res://scripts/Enums/GameMode.gd")
const TRAINING_MODE_TEXT = "Are you sure you want to exit to the menu?"
const TIME_ATTACK_MODE_TEXT = "The items and scores will be lost.\nAre you sure you wanna exit the game?"

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
		signal_sent = false
	
func disable():
	set_visible(false)
	$ExitButton/ExitButtonArea.set_monitoring(false)
	$CancelButton/CancelButtonArea.set_monitoring(false)
	$ExitButton/ExitButtonArea/CollisionShape.set_disabled(true)
	$CancelButton/CancelButtonArea/CollisionShape.set_disabled(true)
	
func set_info_text(game_mode):
	if game_mode == GameMode.TRAINING:
		$Viewport/Label.set_text(TRAINING_MODE_TEXT)
	elif game_mode == GameMode.TIME_ATTACK:
		$Viewport/Label.set_text(TIME_ATTACK_MODE_TEXT)
	else:
		pass

	
func play_button_press_sound():
	$ButtonPressSoundPlayer.play()

func _on_ExitButtonArea_area_entered(area):
	if "HandArea" in area.get_groups() and not signal_sent:
		play_button_press_sound()
		signal_sent = true
		emit_signal("confirm_exit_pressed")

func _on_CancelButtonArea_area_entered(area):
	if "HandArea" in area.get_groups() and not signal_sent:
		play_button_press_sound()
		signal_sent = true
		emit_signal("cancel_button_pressed")

func _on_WaitTimer_timeout():
	enable(false)

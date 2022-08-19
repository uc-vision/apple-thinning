extends Spatial

onready var confirm_finish_dialog = $FinishTrainingGameDialog

signal start_evaluation

	
func _ready():
	confirm_finish_dialog.connect("confirm_finish_pressed", self, "_on_ConfirmationDialog_confirm_fisish_pressed")
	confirm_finish_dialog.connect("cancel_button_pressed", self, "_on_ConfirmationDialog_cancel_button_pressed")


func enable_finish_training_game_button():
	$FinishTrainingGameButton/FinishTrainingGameButtonArea.set_monitoring(true)
	$FinishTrainingGameButton/FinishTrainingGameButtonArea/CollisionShape.set_disabled(false)
	

func disable_finish_training_game_button():
	$FinishTrainingGameButton/FinishTrainingGameButtonArea.set_monitoring(false)
	$FinishTrainingGameButton/FinishTrainingGameButtonArea/CollisionShape.set_disabled(true)
	
	
func _on_ConfirmationDialog_confirm_fisish_pressed():
	emit_signal("start_evaluation")
	

func _on_ConfirmationDialog_cancel_button_pressed():
	enable_finish_training_game_button()
	confirm_finish_dialog.disable()


func _on_FinishTrainingGameButtonArea_area_entered(area):
	if "HandArea" in area.get_groups():
		# Enable confirm finish dialog with wait=false
		confirm_finish_dialog.enable(false)
		disable_finish_training_game_button()

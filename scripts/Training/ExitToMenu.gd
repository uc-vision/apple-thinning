extends Spatial

onready var confirmation_dialog = $ConfirmationDialog_TrainingGame
onready var exit_to_menu_button = $ExitToMenuButton

signal exit_to_menu

func _ready():
	exit_to_menu_button.connect("exit_button_pressed", self, "_on_ExitToMenuButton_button_pressed")
	confirmation_dialog.connect("confirm_exit_pressed", self, "_on_ConfirmationDialog_confirm_exit_pressed")
	confirmation_dialog.connect("cancel_button_pressed", self, "_on_ConfirmationDialog_cancel_button_pressed")


func _on_ExitToMenuButton_button_pressed():
	confirmation_dialog.enable(false)
	exit_to_menu_button.disable()
	
	
func _on_ConfirmationDialog_confirm_exit_pressed():
	emit_signal("exit_to_menu")
	
	
func _on_ConfirmationDialog_cancel_button_pressed():
	exit_to_menu_button.enable()
	confirmation_dialog.disable()

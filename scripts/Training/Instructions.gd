extends Spatial

var help_icon = preload("res://Assets/Images/help.png")
var close_icon = preload("res://Assets/Images/close.png")

onready var instructions_board = $Board
onready var wait_button_interactive_timer = $WaitButtonInteractiveTimer
onready var button_press_sound_player = $ButtonPressedSoundPlayer
onready var button_icon_sprite = $HideAndShowBoardButton/Sprite3D
var is_board_visible = false



func _ready():
	hide_instructions_board()
	# Set up the timer. The wait time is one second as a default.
	wait_button_interactive_timer.set_one_shot(true)
	
	
	
func show_instructions_board():
	instructions_board.set_visible(true)
	button_icon_sprite.set_texture(close_icon)
	is_board_visible = true
	
	
	
func hide_instructions_board():
	instructions_board.set_visible(false)
	button_icon_sprite.set_texture(help_icon)
	is_board_visible = false



func _on_HideAndShowBoardButtonArea_area_entered(area):
	# Make the button interactable only after a second from the last interaction.
	if wait_button_interactive_timer.is_stopped():
		button_press_sound_player.play()
		if is_board_visible:
			hide_instructions_board()
		else:
			show_instructions_board()
		
		# Disable the toggle instructions board button for a second. 
		wait_button_interactive_timer.start()

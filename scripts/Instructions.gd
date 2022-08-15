extends Spatial

onready var instructions_board = $Board
onready var button_label = $HideAndShowBoardButton/Viewport/HideAndShowBoardButtonLabel
onready var wait_button_interactive_timer = $WaitButtonInteractiveTimer
onready var button_press_sound_player = $ButtonPressedSoundPlayer
var is_board_visible = false

const SHOW_BOARD_TEXT = "Show Rules"
const HIDE_BOARD_TEXT = "Hide Rules"

func _ready():
	hide_instructions_board()
	# Set up the timer. The wait time is one second as a default.
	wait_button_interactive_timer.set_one_shot(true)
	
func show_instructions_board():
	instructions_board.set_visible(true)
	button_label.set_text(HIDE_BOARD_TEXT)
	is_board_visible = true
	
func hide_instructions_board():
	instructions_board.set_visible(false)
	button_label.set_text(SHOW_BOARD_TEXT)
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

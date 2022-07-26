extends Spatial

onready var game_results_dialog = $GameResultsDialog
onready var go_to_other_level_timer = $GoToOtherLevelTimer
onready var game_results_board = $GameResultsBoard

var next_level

enum Level {
	GAME_PLAY,
	MENU,
	GAME_PREPARATION,
}

signal play_again

const WAIT_TIME = 2
# Called when the node enters the scene tree for the first time.
func _ready():
	game_results_dialog.connect("play_again_button_pressed", self, "_on_GameResultsDialog_play_again_button_pressed")
	game_results_dialog.connect("back_to_menu_button_pressed", self, "_on_GameResultsDialog_back_to_menu_button_pressed")
	
	go_to_other_level_timer.set_one_shot(true)
	go_to_other_level_timer.set_wait_time(WAIT_TIME)
	
# Add the player to the GamePlayScene level
func set_player(player):
	add_child(player)


func _on_GameResultsDialog_play_again_button_pressed():
	go_to_other_level_timer.start()
	next_level = Level.GAME_PLAY

func _on_GoToOtherLevelTimer_timeout():
	if next_level == Level.GAME_PLAY:
		emit_signal("play_again")

func set_game_results_data(data):
	if data:
		game_results_board.set_score_text(str(data.get_score()))
		game_results_board.set_picked_number_value_text(str(data.get_num_picked()))
		game_results_board.set_max_combo_text(str(data.get_max_combo()))
		game_results_board.set_grade_text(str(data.get_grade()))

extends Spatial

onready var game_start_timer = $GameStartTimer
onready var remaining_time_timer = $RemainingTimeTimer
#onready var score_label = $GUI/Viewport/MarginContainer/VBoxContainer/TopRow/ScoreContainer/Score
onready var remaining_time_label = $GUI/Viewport/MarginContainer/VBoxContainer/BottomRow/RemainingTimeContainer/RemainingTime

const WAIT_TIME = 5
const GAME_PLAY_DURATION = 60

onready var game_start_countdown = WAIT_TIME
onready var remaining_time = GAME_PLAY_DURATION

# Called when the node enters the scene tree for the first time.
func _ready():
	# Start the countdown for the game start
	game_start_timer.set_one_shot(true)
	game_start_timer.set_wait_time(WAIT_TIME)
	
	remaining_time_timer.set_one_shot(true)
	remaining_time_timer.set_wait_time(GAME_PLAY_DURATION)
	
	game_start_timer.start()
	

func _process(delta):
	if not game_start_timer.is_stopped():
		if game_start_countdown != game_start_timer.get_time_left():
			game_start_countdown = game_start_timer.get_time_left()
			remaining_time_label.set_text(str(ceil(game_start_countdown)))
	
	if not remaining_time_timer.is_stopped():
		if remaining_time != remaining_time_timer.get_time_left():
			remaining_time = remaining_time_timer.get_time_left()
			remaining_time_label.set_text(str(ceil(remaining_time)))
			


func _on_GameStartTimer_timeout():
	remaining_time_timer.start()

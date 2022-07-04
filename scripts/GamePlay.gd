extends Spatial

onready var game_start_timer = $GameStartTimer
onready var remaining_time_timer = $RemainingTimeTimer
onready var gui_board = $GUI

const WAIT_TIME = 5
const GAME_PLAY_DURATION = 60

onready var game_start_countdown = WAIT_TIME
onready var remaining_time = GAME_PLAY_DURATION

onready var total_score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set up the getset-ready timer
	game_start_timer.set_one_shot(true)
	game_start_timer.set_wait_time(WAIT_TIME)
	
	# Set up the game play timer
	remaining_time_timer.set_one_shot(true)
	remaining_time_timer.set_wait_time(GAME_PLAY_DURATION)
	
	for child in $AppleTree.get_children():
		if "Branch" in child.get_groups():
			for branch_child in child.get_children():
				if "AppleCluster" in branch_child.get_groups():
					branch_child.connect("score_updated", self, "_on_AppleCluster_score_updated")
	
	# Start the getset-ready timer counting down
	game_start_timer.start()
	

func _process(delta):
	if not game_start_timer.is_stopped():
		if game_start_countdown != ceil(game_start_timer.get_time_left()):
			game_start_countdown = ceil(game_start_timer.get_time_left())
			gui_board.update_remaining_time(str(game_start_countdown))
	
	if not remaining_time_timer.is_stopped():
		if remaining_time != ceil(remaining_time_timer.get_time_left()):
			remaining_time = ceil(remaining_time_timer.get_time_left())
			gui_board.update_remaining_time(str(remaining_time))
			

func _on_AppleCluster_score_updated(old_score, current_score):
	get_tree().root.get_node("Game/AudioStreamPlayer").play()
	total_score += current_score - old_score
	gui_board.update_score_label(str(total_score))
	
func _on_GameStartTimer_timeout():
	remaining_time_timer.start()

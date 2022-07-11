extends Spatial

onready var game_start_timer = $GameStartTimer
onready var remaining_time_timer = $RemainingTimeTimer
onready var combo_timer = $ComboTimer
onready var gui_board = $GUI
onready var before_game_obstacle = $BeforeGameObstacle

const WAIT_TIME = 5
const GAME_PLAY_DURATION = 60
const COMBO_INTERVAL = 3

onready var game_start_countdown = WAIT_TIME
onready var remaining_time = GAME_PLAY_DURATION
#onready var combo_countdown = COMBO_INTERVAL
onready var current_combo = 0

onready var total_score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set up the getset-ready timer
	game_start_timer.set_one_shot(true)
	game_start_timer.set_wait_time(WAIT_TIME)
	
	# Set up the game play timer
	remaining_time_timer.set_one_shot(true)
	remaining_time_timer.set_wait_time(GAME_PLAY_DURATION)
	
	# Set up the combo timer
	combo_timer.set_one_shot(true)
	combo_timer.set_wait_time(COMBO_INTERVAL)
	
	# Start the getset-ready timer counting down
	game_start_timer.start()
	

func _process(delta):
	# Checks the game start countdown and updates the GUI board
	if not game_start_timer.is_stopped():
		if game_start_countdown != ceil(game_start_timer.get_time_left()):
			game_start_countdown = ceil(game_start_timer.get_time_left())
			before_game_obstacle.update_game_start_countdown(str(game_start_countdown))
	
	# Checks the game play remaining time and updates the GUI board
	if not remaining_time_timer.is_stopped():
		if remaining_time != ceil(remaining_time_timer.get_time_left()):
			remaining_time = ceil(remaining_time_timer.get_time_left())
			gui_board.update_remaining_time(str(remaining_time))
			

func _on_AppleCluster_score_updated(cluster_score, has_damaged):
	# If there is a damaged apple in the finished cluster, cut the combo
	if has_damaged:
		cut_combo()
	# Add the score based on the current combo
	total_score += cluster_score * (1 + float(current_combo) / 100)
	gui_board.update_score_label(str(total_score))
	
# Start the game
func _on_GameStartTimer_timeout():
	before_game_obstacle.remove_obstacle()
	setup_apples()
	remaining_time_timer.start()
	
# Increment the combo whenever an apple is picked. Updates the score board and start a new combo timer countdown. 
func _on_AppleCluster_apple_picked():
	current_combo += 1
	gui_board.update_combo_label(str(current_combo))
	combo_timer.start()

# Connect custom signals with apples and make them interactable
func setup_apples():
	for child in $AppleTree.get_children():
		if "Branch" in child.get_groups():
			for branch_child in child.get_children():
				if "AppleCluster" in branch_child.get_groups():
					branch_child.connect("score_updated", self, "_on_AppleCluster_score_updated")
					branch_child.connect("apple_picked", self, "_on_AppleCluster_apple_picked")
					branch_child.is_interactable = true

# Game time is up
func _on_RemainingTimeTimer_timeout():
	set_apple_not_pickable()
	
func set_apple_not_pickable():
	for child in $AppleTree.get_children():
		if "Branch" in child.get_groups():
			for branch_child in child.get_children():
				if "AppleCluster" in branch_child.get_groups():
					branch_child.is_interactable = false

func _on_ComboTimer_timeout():
	cut_combo()
	
# Set the combo to zero and update the GUI board
func cut_combo():
	current_combo = 0
	gui_board.update_combo_label(str(current_combo))

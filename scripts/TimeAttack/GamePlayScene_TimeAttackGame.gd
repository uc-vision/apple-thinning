extends Spatial

onready var apple_tree_scene = load("res://Scenes/TimeAttack/AppleTree_TimeAttackGame.tscn")

onready var game_start_timer = $GameStartTimer
onready var remaining_time_timer = $RemainingTimeTimer
onready var combo_timer = $ComboTimer
onready var wait_tree_spawn_timer = $WaitTreeSpawnTimer
onready var wait_tree_remove_timer = $WaitTreeRemoveTimer
onready var go_to_game_results_scene_timer = $GoToGameResultsSceneTimer
onready var platform = $Platform
onready var pause_button = $Platform/PauseButton
onready var pause_dialog = $Platform/PauseDialog
onready var confirmation_dialog = $Platform/ConfirmationDialog
onready var bgm_player = $BGM_Player

const DIALOG_WAIT_TIME = 5
const GAME_PLAY_DURATION = 5
const COMBO_INTERVAL = 3
const TREE_REMOVE_WAIT_TIMER = 0.5
const TREE_SPAWN_WAIT_TIME = 0.5
const WAIT_BEFORE_GO_TO_RESULTS_TIME = 3

var game_start_countdown = DIALOG_WAIT_TIME
var remaining_time = GAME_PLAY_DURATION
var current_combo = 0
var remaining_time_watch 
var score_and_combo_watch
var total_score: int = 0
var num_apples_picked: int = 0
var max_combo = 0
var game_play_data
var is_signal_sent = false


signal go_to_game_results(game_results_data)
signal exit_to_menu

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect the game pause UI signals
	pause_dialog.connect("exit_button_pressed", self, "_on_ExitButton_pressed")
	pause_dialog.connect("resume_button_pressed", self, "_on_ResumeButton_pressed")
	pause_button.connect("pause_button_pressed", self, "_on_PauseButton_pressed")
	confirmation_dialog.connect("confirm_exit_pressed", self, "_on_ConfirmExit_pressed")
	confirmation_dialog.connect("cancel_button_pressed", self, "_on_CancelButton_pressed")

	# Set up the getset-ready timer
	game_start_timer.set_one_shot(true)
	game_start_timer.set_wait_time(DIALOG_WAIT_TIME)
	
	# Set up the game play timer
	remaining_time_timer.set_one_shot(true)
	remaining_time_timer.set_wait_time(GAME_PLAY_DURATION)
	
	# Set up the combo timer
	combo_timer.set_one_shot(true)
	combo_timer.set_wait_time(COMBO_INTERVAL)
	
	# Set up the wait apple tree removing timer
	wait_tree_remove_timer.set_one_shot(true)
	wait_tree_remove_timer.set_wait_time(TREE_REMOVE_WAIT_TIMER)
	
	# Set up the wait apple tree spawning timer
	wait_tree_spawn_timer.set_one_shot(true)
	wait_tree_spawn_timer.set_wait_time(TREE_SPAWN_WAIT_TIME)
	
	# Set up the go to game results scene timer
	go_to_game_results_scene_timer.set_one_shot(true)
	go_to_game_results_scene_timer.set_wait_time(WAIT_BEFORE_GO_TO_RESULTS_TIME)
	
	# Start the getset-ready timer counting down
	game_start_timer.start()
	
func set_player(player):
	# Add the player to GamePlayScene with human readable name
	platform.add_child(player, true)
	player.set_name("ARVROrigin")
	remaining_time_watch = $Platform/ARVROrigin/LeftHand/RemainingTimeWatch
	remaining_time_watch.reset_label(GAME_PLAY_DURATION)
	remaining_time_watch.set_visible(true)
	score_and_combo_watch = $Platform/ARVROrigin/RightHand/ScoreAndComboWatch
	score_and_combo_watch.reset_label()
	score_and_combo_watch.set_visible(true)

func set_game_play_data(data):
	game_play_data = data
	
func _process(delta):
	# Checks the game start countdown and updates the GUI board
	if not game_start_timer.is_stopped():
		if game_start_countdown != ceil(game_start_timer.get_time_left()):
			game_start_countdown = ceil(game_start_timer.get_time_left())
			platform.update_before_game_obstacle(game_start_countdown)
	
	# Checks the game play remaining time and updates the GUI board
	if not remaining_time_timer.is_stopped():
		if remaining_time != ceil(remaining_time_timer.get_time_left()):
			remaining_time = ceil(remaining_time_timer.get_time_left())
			remaining_time_watch.update_remaining_time(str(remaining_time))

func _on_AppleCluster_score_updated(cluster_score, has_damaged):
	# If there is a damaged apple in the finished cluster, cut the combo
	if has_damaged:
		cut_combo()
	# Add the score based on the current combo
	total_score += cluster_score * (1 + float(current_combo) / 100)
	score_and_combo_watch.update_score_label(str(total_score))
	
# Start the game
func _on_GameStartTimer_timeout():
	platform.hide_game_flow_obstacle()
	setup_apples()
	platform.enable_platform_motion()
	remaining_time_timer.start()
	bgm_player.play()
	
# Increment the combo whenever an apple is picked. Updates the score board and start a new combo timer countdown. 
func _on_AppleCluster_apple_picked():
	num_apples_picked += 1
	current_combo += 1
	if current_combo > max_combo:
		max_combo = current_combo
	score_and_combo_watch.update_combo_label(str(current_combo))
	combo_timer.start()

# Connect custom signals with apples and make them interactable
func setup_apples():
	$AppleTree.connect("all_clusters_thinned", self, "_on_AppleTree_finished_thinning")
	
	for child in $AppleTree.get_children():
		if "Branch" in child.get_groups():
			for branch_child in child.get_children():
				if "AppleCluster" in branch_child.get_groups():
					branch_child.is_interactable = true
					branch_child.connect("score_updated", self, "_on_AppleCluster_score_updated")
					branch_child.connect("apple_picked", self, "_on_AppleCluster_apple_picked")
					get_tree().root.get_node("Game/AudioStreamPlayer").play()
					

# Game time is up
func _on_RemainingTimeTimer_timeout():
	bgm_player.stop()
	# Make apples not interactable
	set_apple_not_pickable()
	remaining_time_watch.update_remaining_time(str(0))
	# Put obstacle between the player and a tree
	platform.show_game_flow_obstacle()
	pause_button.disable()
	platform.disable_platform_motion()
	go_to_game_results_scene_timer.start()

	
func set_apple_pickable():
	for child in $AppleTree.get_children():
		if "Branch" in child.get_groups():
			for branch_child in child.get_children():
				if "AppleCluster" in branch_child.get_groups():
					branch_child.is_interactable = true
	
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
	score_and_combo_watch.update_combo_label(str(current_combo))
	
# Pauses the game
func _on_PauseButton_pressed():
	# Pause the game play BGM
	bgm_player.set_stream_paused(true)
	
	pause_button.disable()
	platform.disable_platform_motion()
	
	# Pauses the timers
	game_start_timer.set_paused(true)
	remaining_time_timer.set_paused(true)
	combo_timer.set_paused(true)
	
	# Make apples not interactable
	set_apple_not_pickable()
	
	pause_dialog.enable(false)
	
# Resumes the game
func _on_ResumeButton_pressed():
	pause_dialog.disable()
	platform.enable_platform_motion()
	pause_button.enable()
	
	# Makes apples interactalble again
	set_apple_pickable()
	
	# Resume the game play BGM
	bgm_player.set_stream_paused(false)
	
	# Resumes the timers
	game_start_timer.set_paused(false)
	remaining_time_timer.set_paused(false)
	combo_timer.set_paused(false)
	

# Asks player for the confirmation
func _on_ExitButton_pressed():
	pause_dialog.disable()
	confirmation_dialog.enable(true)
	
# Exit the GamePlayScene to MenuScene
func _on_ConfirmExit_pressed():
	if !is_signal_sent:
		is_signal_sent = true
		emit_signal("exit_to_menu")
	
# Show the PauseDialog again
func _on_CancelButton_pressed():
	confirmation_dialog.disable()
	pause_dialog.enable(true)

# Remove the tree that's finished thinning and prepare the new tree.	
func _on_AppleTree_finished_thinning():
	wait_tree_remove_timer.start()

# Remove the finished apple tree
func _on_WaitTreeRemoveTimer_timeout():
	$AppleTree.queue_free()
	# Wait for a moment to spawn a new tree
	wait_tree_spawn_timer.start()

# Spawn a new apple tree
func _on_WaitTreeSpawnTimer_timeout():
	var new_apple_tree = apple_tree_scene.instance()
	add_child(new_apple_tree, true)
	new_apple_tree.set_name("AppleTree")
	if not remaining_time_timer.is_stopped():
		setup_apples()


func _on_GoToGameResultsSceneTimer_timeout():
	if game_play_data:
		game_play_data.set_score(total_score)
		game_play_data.set_highest_score(0)
		game_play_data.set_num_picked(num_apples_picked)
		game_play_data.set_max_combo(max_combo)
		
	emit_signal("go_to_game_results", game_play_data)

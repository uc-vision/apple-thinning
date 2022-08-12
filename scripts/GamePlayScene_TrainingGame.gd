extends Spatial

onready var go_to_game_results_scene_timer = $GoToGameResultsSceneTimer
onready var platform = $Platform_NoTimeLimit
onready var confirmation_dialog = $Platform/ConfirmationDialog

const WAIT_BEFORE_GO_TO_RESULTS_TIME = 3

var total_score: int = 0
var num_apples_picked: int = 0
var max_combo = 0
var game_play_data

signal go_to_game_results(game_results_data)

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Set up the go to game results scene timer
	go_to_game_results_scene_timer.set_one_shot(true)
	go_to_game_results_scene_timer.set_wait_time(WAIT_BEFORE_GO_TO_RESULTS_TIME)
	
	# Set up interactive objects
	setup_apples()
	platform.enable_platform_motion()

	
func set_player(player):
	# Add the player to GamePlayScene with human readable name
	platform.add_child(player, true)
	player.set_name("ARVROrigin")
	$Platform/ARVROrigin/LeftHand/RemainingTimeWatch.set_visible(false)
	$Platform/ARVROrigin/RightHand/ScoreAndComboWatch.set_visible(false)

func set_game_play_data(data):
	game_play_data = data

# Increment the combo whenever an apple is picked. Updates the score board and start a new combo timer countdown. 
func _on_AppleCluster_apple_picked():
	pass

# Connect custom signals with apples and make them interactable
func setup_apples():
	for child in $AppleTree_NoTimeLimit.get_children():
		if "Branch" in child.get_groups():
			for branch_child in child.get_children():
				if "AppleCluster" in branch_child.get_groups():
					branch_child.connect("apple_picked", self, "_on_AppleCluster_apple_picked")
					branch_child.is_interactable = true

func set_apple_pickable():
	for child in $AppleTree_NoTimeLimit.get_children():
		if "Branch" in child.get_groups():
			for branch_child in child.get_children():
				if "AppleCluster" in branch_child.get_groups():
					branch_child.is_interactable = true
	
func set_apple_not_pickable():
	for child in $AppleTree_NoTimeLimit.get_children():
		if "Branch" in child.get_groups():
			for branch_child in child.get_children():
				if "AppleCluster" in branch_child.get_groups():
					branch_child.is_interactable = false
					

func _on_GoToGameResultsSceneTimer_timeout():
	# Set the game play data
	if game_play_data:
		game_play_data.set_score(total_score)
		game_play_data.set_highest_score(0)
		game_play_data.set_num_picked(num_apples_picked)
		game_play_data.set_max_combo(max_combo)
		
	emit_signal("go_to_game_results", game_play_data)

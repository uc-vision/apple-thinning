extends Spatial

var game_play_scene = preload("res://Levels/GamePlayScene.tscn")
var game_results_scene = load("res://Levels/GameResultsScene.tscn") 
var GamePlayData = load("res://scripts/Classes/GamePlayData.gd")

var player
var game_play_level
var game_results_level
var game_play_data

func _ready():
	game_play_data = GamePlayData.new()
	enter_game_play_scene()

func enter_game_play_scene():
	
	# First time to load GamePlayScene
	if not player:
		player = $ARVROrigin

	# Detatch the player from a current parent
	if player and player.get_parent():
		player.get_parent().remove_child(player)

	# Instantiated the GamePlayScene
	game_play_level = game_play_scene.instance()
	
	# Add the level with a human readable name
	$Levels.add_child(game_play_level, true)
	game_play_level.set_name("GamePlayScene")
	
	# Add the player to GamePlayScene
	game_play_level.set_player(player)
	game_play_level.set_game_play_data(game_play_data)
	
	# Connect signal to request transition from GamePlayScene to GameResultsScene
	game_play_level.connect("go_to_game_results", self, "_on_GamePlayScene_go_to_game_results")

# Level transition from GamePlayScene --> GameResultsScene
func _on_GamePlayScene_go_to_game_results(data):

	# Detach the player from GamePlayScene level before deleting the level
	player = get_node("Levels/GamePlayScene/Platform/ARVROrigin")
	if player and player.get_parent():
		player.get_parent().remove_child(player)

	# Delete the GamePlayScene
	game_play_level.queue_free()

	# Instantiate the GameResultsScene
	game_results_level = game_results_scene.instance()
	
	# Add the level to the Levels with a human readable node name
	$Levels.add_child(game_results_level, true)
	game_results_level.set_name("GameResultsScene")
	
	# Add player to the GameResultsScene
	game_results_level.set_player(player)
	game_results_level.connect("play_again", self, "_on_GameResultsScene_play_again")
	game_results_level.set_game_results_data(data)

# Level transition from GameResultsScene --> GamePlayScene (TODO: Change the distination to GamePreparationScene once the scene is created)
func _on_GameResultsScene_play_again():
	
	# Detach the player from Game
	player = get_node("Levels/GameResultsScene/ARVROrigin")
	if player and player.get_parent():
		player.get_parent().remove_child(player)

	game_results_level.queue_free()
	enter_game_play_scene()

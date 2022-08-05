extends Spatial

var menu_scene = preload("res://Levels/MenuScene.tscn")
var game_play_scene = preload("res://Levels/GamePlayScene.tscn")
var no_time_limit_game_play_scene = preload("res://Levels/GamePlayScene_NoTimeLimit.tscn")
var game_results_scene = load("res://Levels/GameResultsScene.tscn") 
var GamePlayData = load("res://scripts/Classes/GamePlayData.gd")

var player
var menu_level
var game_play_level
var no_time_limit_game_play_level
var game_results_level
var game_play_data

func _ready():
	game_play_data = GamePlayData.new()
	enter_menu_scene()
	
func enter_menu_scene():
	# First time to load GamePlayScene
	if not player:
		player = $ARVROrigin

	# Detatch the player from a current parent
	if player and player.get_parent():
		player.get_parent().remove_child(player)
	
	# Instantiate the MenuScene	
	menu_level = menu_scene.instance()
	
	# Add the level with a human readable name
	$Levels.add_child(menu_level, true)
	menu_level.set_name("MenuScene")
	
	# Add the player ot the MenuScene
	menu_level.set_player(player)
	
	# Connect signals to request transition to either GamePlayScene or GamePlayScene_NoTimeLimit scene
	menu_level.connect("play_no_time_limit_mode", self, "_on_MenuScene_play_no_time_limit")
	menu_level.connect("play_time_attack_mode", self, "_on_MenuScene_play_time_attack")

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
	game_results_level.connect("go_to_menu", self, "_on_GameResultsScene_go_to_menu")
	game_results_level.set_game_results_data(data)

# Level transition from GameResultsScene --> GamePlayScene (TODO: Change the distination to GamePreparationScene once the scene is created)
func _on_GameResultsScene_play_again():
	
	# Detach the player from GameResultsScene
	player = get_node("Levels/GameResultsScene/ARVROrigin")
	if player and player.get_parent():
		player.get_parent().remove_child(player)

	game_results_level.queue_free()
	
	# Instantiate the GamePlayScene
	game_play_level = game_play_scene.instance()
	
	# Add the level with a human readable name
	$Levels.add_child(game_play_level, true)
	game_play_level.set_name("GamePlayScene")
	
	# Add the player to GamePlayScene
	game_play_level.set_player(player)
	game_play_level.set_game_play_data(game_play_data)
	
	# Connect signal to request transition from GamePlayScene to GameResultsScene
	game_play_level.connect("go_to_game_results", self, "_on_GamePlayScene_go_to_game_results")
	
func _on_GameResultsScene_go_to_menu():
	
	# Detach the player from GameResultsScene
	player = get_node("Levels/GameResultsScene/ARVROrigin")
	if player and player.get_parent():
		player.get_parent().remove_child(player)

	game_results_level.queue_free()
	
	# Instantiate the MenuScene	
	menu_level = menu_scene.instance()
	
	# Add the level with a human readable name
	$Levels.add_child(menu_level, true)
	menu_level.set_name("MenuScene")
	
	# Add the player ot the MenuScene
	menu_level.set_player(player)
	
	# Connect signals to request transition to either GamePlayScene or GamePlayScene_NoTimeLimit scene
	menu_level.connect("play_no_time_limit_mode", self, "_on_MenuScene_play_no_time_limit")
	menu_level.connect("play_time_attack_mode", self, "_on_MenuScene_play_time_attack")
	
# Level transition from MenuScene --> GamePlayScene_NoTimeLimit
func _on_MenuScene_play_no_time_limit():
	# Detach the player from MenuScene level before deleting the level
	player = get_node("Levels/MenuScene/ARVROrigin")
	if player and player.get_parent():
		player.get_parent().remove_child(player)

	# Delete the GamePlayScene
	menu_level.queue_free()

	# Instantiate the GameResultsScene
	no_time_limit_game_play_level = no_time_limit_game_play_scene.instance()
	
	# Add the level to the Levels with a human readable node name
	$Levels.add_child(no_time_limit_game_play_level, true)
	no_time_limit_game_play_level.set_name("GamePlayScene_NoTimeLimit")
	
	# Add player to the GameResultsScene
	no_time_limit_game_play_level.set_player(player)
	
	# Connect signal to request transition from GamePlayScene to GameResultsScene
	no_time_limit_game_play_level.connect("go_to_game_results", self, "_on_GamePlayScene_go_to_game_results")
	
# Level transition from MenuScene --> GamePlayScene
func _on_MenuScene_play_time_attack():
	# Detatch the player from a current parent
	player = get_node("Levels/MenuScene/ARVROrigin")
	if player and player.get_parent():
		player.get_parent().remove_child(player)
		
	menu_level.queue_free()

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

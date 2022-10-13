extends Spatial

var menu_scene = preload("res://Levels/MenuScene.tscn")
var time_attack_game_scene = preload("res://Levels/TimeAttackGameScene.tscn")
var training_game_scene = preload("res://Levels/TrainingGameScene.tscn")
var tutorial_game_scene = preload("res://Levels/TutorialGameScene.tscn")
var game_results_scene = load("res://Levels/GameResultsScene.tscn")
var TimeAttackGameData = load("res://scripts/Classes/TimeAttackGameData.gd")

var player
var menu_level
var time_attack_game_level
var training_game_level
var tutorial_game_level
var game_results_level
var time_attack_game_data
var player_height = 1.7


func _ready():
	time_attack_game_data = TimeAttackGameData.new()
	$Debugger.new_debug_log(player_height)
	player_height = $ARVROrigin/ARVRCamera.transform.origin.y
	$Debugger.new_debug_log(player_height)
	enter_menu_scene()
	
	
func enter_menu_scene():
	# First time to load MenuScene
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
	
	# Connect signals to request transition to either TimeAttackGameScene or TrainingGameScene scene
	menu_level.connect("play_training_game_mode", self, "_on_MenuScene_play_training_game")
	menu_level.connect("play_time_attack_game_mode", self, "_on_MenuScene_play_time_attack_game")
	menu_level.connect("play_tutorial_game_mode", self, "_on_MenuScene_play_tutorial_game")



# Level transition from TimeAttackGameScene --> GameResultsScene
func _on_TimeAttackGameScene_go_to_game_results(data):

	# Detach the player from TimeAttackGameScene level before deleting the level
	player = get_node("Levels/TimeAttackGameScene/ARVROrigin")
	if player and player.get_parent():
		player.get_parent().remove_child(player)

	# Delete the TimeAttackGameScene
	time_attack_game_level.queue_free()
	
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
	


# Exitting the TimeAttackGameScene --> MenuScene in the middle of the game
func _on_TimeAttackGameScene_exit_to_menu():
	# Detach the player from TimeAttackGameScene level before deleting the level
	player = get_node("Levels/TimeAttackGameScene/ARVROrigin")
	if player and player.get_parent():
		player.get_parent().remove_child(player)

	# Delete the TimeAttackGameScene
	time_attack_game_level.queue_free()
	
	# Instantiate the MenuScene
	menu_level = menu_scene.instance()
	
	# Add the level with a human readable name
	$Levels.add_child(menu_level, true)
	menu_level.set_name("MenuScene")
	
	# Add the player ot the MenuScene
	menu_level.set_player(player)
	
	# Connect signals to request transition to either TimeAttackGameScene or TrainingGameScene scene
	menu_level.connect("play_training_game_mode", self, "_on_MenuScene_play_training_game")
	menu_level.connect("play_time_attack_game_mode", self, "_on_MenuScene_play_time_attack_game")
	menu_level.connect("play_tutorial_game_mode", self, "_on_MenuScene_play_tutorial_game")



# Level transition from GameResultsScene --> TimeAttackGameScene (TODO: Change the distination to GamePreparationScene once the scene is created)
func _on_GameResultsScene_play_again():
	
	# Detach the player from GameResultsScene
	player = get_node("Levels/GameResultsScene/ARVROrigin")
	if player and player.get_parent():
		player.get_parent().remove_child(player)

	game_results_level.queue_free()
	
	# Instantiate the TimeAttackGameScene
	time_attack_game_level = time_attack_game_scene.instance()
	
	# Add the level with a human readable name
	$Levels.add_child(time_attack_game_level, true)
	time_attack_game_level.set_name("TimeAttackGameScene")
	
	# Add the player to TimeAttackGameScene
	time_attack_game_level.set_player(player)
	time_attack_game_level.set_game_play_data(time_attack_game_data)
	
	# Connect signal to request transition from TimeAttackGameScene to GameResultsScene
	time_attack_game_level.connect("go_to_game_results", self, "_on_TimeAttackGameScene_go_to_game_results")
	
	
	
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
	
	# Connect signals to request transition to either TimeAttackGameScene or TrainingGameScene
	menu_level.connect("play_training_game_mode", self, "_on_MenuScene_play_training_game")
	menu_level.connect("play_time_attack_game_mode", self, "_on_MenuScene_play_time_attack_game")
	menu_level.connect("play_tutorial_game_mode", self, "_on_MenuScene_play_tutorial_game")
	
	
	
# Level transition from MenuScene --> TrainingGameScene
func _on_MenuScene_play_training_game():
	# Detach the player from MenuScene level before deleting the level
	player = get_node("Levels/MenuScene/ARVROrigin")
	if player and player.get_parent():
		player.get_parent().remove_child(player)

	# Delete the MenuScene
	menu_level.queue_free()

	# Instantiate the TrainingGameScene
	training_game_level = training_game_scene.instance()
	
	# Add the level to the Levels with a human readable node name
	$Levels.add_child(training_game_level, true)
	training_game_level.set_name("TrainingGameScene")
	
	# Add player to the TrainingGameScene
	training_game_level.set_player(player)
	
	# Connect signal to request transition from TrainingGameScene to MenuScene
	training_game_level.connect("exit_to_menu", self, "_on_TrainingGameScene_exit_to_menu")
	
	
	
func _on_TrainingGameScene_exit_to_menu():
	# Detach the player from the TrainingGameScene level before deleting the level
	player = get_node("Levels/TrainingGameScene/ARVROrigin")
	if player and player.get_parent():
		player.get_parent().remove_child(player)
		
	# Delete the TrainingGameScene
	training_game_level.queue_free()
	
	# Go to the MenuScene
	enter_menu_scene()



# Level transition from MenuScene --> TimeAttackGameScene
func _on_MenuScene_play_time_attack_game():
	# Detatch the player from a current parent
	player = get_node("Levels/MenuScene/ARVROrigin")
	if player and player.get_parent():
		player.get_parent().remove_child(player)
		
	menu_level.queue_free()

	# Instantiated the TimeAttackGameScene
	time_attack_game_level = time_attack_game_scene.instance()
	
	# Add the level with a human readable name
	$Levels.add_child(time_attack_game_level, true)
	time_attack_game_level.set_name("TimeAttackGameScene")
	
	# Add the player to TimeAttackGameScene
	time_attack_game_level.set_player(player)
	time_attack_game_level.set_game_play_data(time_attack_game_data)
	
	# Connect signal to request transition from TimeAttackGameScene to GameResultsScene
	time_attack_game_level.connect("go_to_game_results", self, "_on_TimeAttackGameScene_go_to_game_results")
	time_attack_game_level.connect("exit_to_menu", self, "_on_TimeAttackGameScene_exit_to_menu")


# Level transition from menu to the tutorial
func _on_MenuScene_play_tutorial_game():
	# Detatch the player from a current parent
	player = get_node("Levels/MenuScene/ARVROrigin")
	if player and player.get_parent():
		player.get_parent().remove_child(player)
		
	menu_level.queue_free()

	# Instantiated the TimeAttackGameScene
	tutorial_game_level = tutorial_game_scene.instance()
	
	# Add the level with a human readable name
	$Levels.add_child(tutorial_game_level, true)
	tutorial_game_level.set_name("TutorialGameScene")
	
	# Add the player to TimeAttackGameScene
	tutorial_game_level.set_player(player)

	# Connect signal to request transition from TimeAttackGameScene to GameResultsScene
	tutorial_game_level.connect("exit_to_menu", self, "_on_TutorialGameScene_exit_to_menu")
	

func _on_TutorialGameScene_exit_to_menu():
	# Detatch the player from a current parent
	player = get_node("Levels/TutorialGameScene/ARVROrigin")
	if player and player.get_parent():
		player.get_parent().remove_child(player)
	
	tutorial_game_level.queue_free()
	
	enter_menu_scene()
	
	
	

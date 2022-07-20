extends Spatial

onready var game_results_scene = load("res://Levels/GameResultsScene.tscn")
onready var player
onready var game_play_scene

func _ready():
	enter_game_play_scene()
	$Levels/GamePlayScene.connect("go_to_game_results", self, "_on_GamePlayScene_go_to_game_results")
	
func enter_game_play_scene():
	player = $ARVROrigin

	if player and player.get_parent():
		player.get_parent().remove_child(player)
	
	game_play_scene = $Levels/GamePlayScene
	game_play_scene.set_player(player)

func _on_GamePlayScene_go_to_game_results():
#	var platform = $Levels/GamePlayScene/Platform
#	for platform.get_children():
		
	player = get_node("Levels/GamePlayScene/Platform/ARVROrigin")
	
	if player and player.get_parent():
		player.get_parent().remove_child(player)
	
	game_play_scene.queue_free()
	var game_results_level = game_results_scene.instance()
	$Levels.add_child(game_results_level)
	game_results_level.set_player(player)
	
	

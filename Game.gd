extends Spatial

onready var player

func _ready():
	enter_game_play_scene()
	$Levels/GamePlayScene.connect("go_to_game_results", self, "_on_GamePlayScene_go_to_game_results")
	
func enter_game_play_scene():
	player = $ARVROrigin

	if player and player.get_parent():
		player.get_parent().remove_child(player)
	
	var game_play_scene = $Levels/GamePlayScene
	game_play_scene.set_player(player)

func _on_GamePlayScene_go_to_game_results():
	pass

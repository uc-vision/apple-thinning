extends Spatial
	
onready var player = $ARVROrigin

func _ready():
	enter_game_play_scene()
	
func enter_game_play_scene():
	if player.get_parent():
		player.get_parent().remove_child(player)
	
	var game_play_scene = $Levels/GamePlayScene
	game_play_scene.set_player(player)

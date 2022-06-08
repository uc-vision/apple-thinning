extends RigidBody

func interact():
	reset_game()
	
func reset_game():
	get_tree().root.get_node("Game/AudioStreamPlayer").play()
	get_tree().change_scene("res://Game.tscn")

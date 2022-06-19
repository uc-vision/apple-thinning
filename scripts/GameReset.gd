extends RigidBody

func interact():
	reset_game()
	
func reset_game():
	# Beep sound for debugging purpose
	get_tree().root.get_node("Game/AudioStreamPlayer").play()
	
	# Destroy the current level and load a new level
	var world = get_tree().root.get_node("Game/Levels")
	var current_level = world.get_child(0)
	current_level.queue_free()
	
	var new_level = load("res://Levels/Level1.tscn").instance()
	world.add_child(new_level)

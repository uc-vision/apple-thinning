extends RigidBody

# A timer to avoid resetting game multiple times in one attempt
const WAIT_TIME  = 2
onready var timer = $GameResetTimer

func _ready():
	# Timer setup. No repeat, counts down 2 seconds, and start
	timer.set_one_shot(true)
	timer.set_wait_time(WAIT_TIME)
	timer.start()

func interact():
	# The game reset valid after the timer's remaining time reaches 0
	if timer.get_time_left() == 0:
		# Rest the level
		reset_game()
		# Restart the timer
		timer.start()
	
func reset_game():
	# Beep sound for debugging purpose
	get_tree().root.get_node("Game/AudioStreamPlayer").play()
	
	# Destroy the current level and load a new level
	var world = get_tree().root.get_node("Game/Levels")
	var current_level = world.get_child(0)
	current_level.queue_free()
	
	var new_level = load("res://Levels/GamePlayScene.tscn").instance()
	world.add_child(new_level)

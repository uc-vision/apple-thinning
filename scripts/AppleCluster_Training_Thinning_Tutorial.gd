extends "res://scripts/Apple_Cluster_Tutorial.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# MAX_APPLE_NUM_TO_LEAVE
# remaining_apple_count

func check_apples():
	if MAX_APPLE_NUM_TO_LEAVE == remaining_apple_count:
		$Tick.set_visible(true)
		$Exclamation.set_visible(false)
	else:
		$Tick.set_visible(false)
		$Exclamation.set_visible(true)
	

func _on_HealthyLargeApple_on_picked(apple):
	emit_signal("apple_picked")
	play_apple_picked_sound()
	remaining_apple_count -= 1
	check_apples()
	

func _on_HealthySmallApple_on_picked(apple):
	emit_signal("apple_picked")
	play_apple_picked_sound()
	remaining_apple_count -= 1
	check_apples()

func _on_DamagedApple_on_picked(apple):
	emit_signal("apple_picked")
	play_apple_picked_sound()
	remaining_apple_count -= 1
	check_apples()

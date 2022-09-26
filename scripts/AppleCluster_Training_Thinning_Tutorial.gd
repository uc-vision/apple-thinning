extends "res://scripts/Apple_Cluster_Tutorial.gd"

# checks game for apples in cluster and displays feedback to user
func check_apples():
	if MAX_APPLE_NUM_TO_LEAVE == remaining_apple_count:
		$Tick.set_visible(true)
		$Exclamation.set_visible(false)
	else:
		$Tick.set_visible(false)
		$Exclamation.set_visible(true)


# Following three functions are inherited and check_apples() added on pick triggers

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

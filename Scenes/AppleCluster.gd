extends Spatial

onready var score = 0
onready var apple_pick_sound_player = $ApplePickSound
var point

const Point = {
	HEALTHY_LARGE = 1.5,
	HEALTHY_SMALL = 1,
	DAMAGED = -3,
}


func _on_HealthyLargeApple_on_picked():
	play_apple_picked_sound()
	score += Point.HEALTHY_LARGE


func _on_HealthySmallApple_on_picked():
	play_apple_picked_sound()
	score += Point.HEALTHY_SMALL
	

func _on_DamagedApple_on_picked():
	play_apple_picked_sound()
	score += Point.DAMAGED
	
func play_apple_picked_sound():
	apple_pick_sound_player.play()

extends Spatial

onready var score = 0
onready var remaining_apple_count = 0
onready var apple_pick_sound_player = $ApplePickSound
var point
var MAX_APPLE_NUM_TO_LEAVE = 2

const Point = {
	HEALTHY_LARGE = 1.5,
	HEALTHY_SMALL = 1,
	DAMAGED = -3,
}

func _ready():
	var children = get_children()
	for child in children:
		if child.get_groups().has("Apple"):
			remaining_apple_count += 1


func _on_HealthyLargeApple_on_picked():
	play_apple_picked_sound()
	remaining_apple_count -= 1
	if remaining_apple_count <= MAX_APPLE_NUM_TO_LEAVE:
		calculate_score()


func _on_HealthySmallApple_on_picked():
	play_apple_picked_sound()
	remaining_apple_count -= 1
	if remaining_apple_count <= MAX_APPLE_NUM_TO_LEAVE:
		calculate_score()
	

func _on_DamagedApple_on_picked():
	play_apple_picked_sound()
	remaining_apple_count -= 1
	if remaining_apple_count <= MAX_APPLE_NUM_TO_LEAVE:
		calculate_score()
		
func calculate_score():
	var children = get_children()
	for child in children:
		var groups = child.get_groups()
		if groups.has("Apple") and !child.picked_off:
			var point
			if groups.has("HealthyLarge"):
				point = Point.HEALTHY_LARGE
			elif groups.has("HealthySmall"):
				point = Point.HEALTHY_SMALL
			else:
				point = Point.DAMAGED
			
			score += point
			child.show_point()
		
	
func play_apple_picked_sound():
	apple_pick_sound_player.play()

extends Spatial

onready var apple_pick_sound_player = $ApplePickSound
var rng = RandomNumberGenerator.new()
var score = 0
var remaining_apple_count = 0 setget set_remaining_apple_count, get_remaining_apple_count
# Makes apples only pickable during the game play.
var is_interactable = false
var hasDamaged
var initial_apple_count = 0

signal score_computed(score)
signal apple_picked

const Point = {
	HEALTHY_LARGE = 200,
	HEALTHY_SMALL = 100,
	DAMAGED = -300,
}

#== Getters and setters =====

func get_remaining_apple_count():
	return remaining_apple_count
	
func set_remaining_apple_count(num_apple):
	remaining_apple_count = num_apple

#== End of getters and setters ====

func _ready():
	var counter = 0
	var children = get_children()
	for child in children:
		if child.get_groups().has("Apple"):
			counter += 1
	initial_apple_count = counter
	set_remaining_apple_count(counter)

func initialize(spawn_location):
	set_translation(spawn_location)
	# Give a random rotation on the apple clusters in Y direction
	var rotation_offset = rng.randf_range(-180, 180)
	var rotation_vector = Vector3(0, deg2rad(rotation_offset), 0)
	set_rotation(rotation_vector)


func _on_HealthyLargeApple_on_picked(apple):
	emit_signal("apple_picked")
	play_apple_picked_sound()
	set_remaining_apple_count(get_remaining_apple_count() - 1)

func _on_HealthySmallApple_on_picked(apple):
	emit_signal("apple_picked")
	play_apple_picked_sound()
	set_remaining_apple_count(get_remaining_apple_count() - 1)

func _on_DamagedApple_on_picked(apple):
	emit_signal("apple_picked")
	play_apple_picked_sound()
	set_remaining_apple_count(get_remaining_apple_count() - 1)

func calculate_score():
	score = 0
	hasDamaged = false
	var children = get_children()
	for child in children:
		var groups = child.get_groups()
		if groups.has("Apple") and !child.picked_off:
			if groups.has("HealthyLarge"):
				score += Point.HEALTHY_LARGE
			elif groups.has("HealthySmall"):
				score += Point.HEALTHY_SMALL
			else:
				hasDamaged = true
				score += Point.DAMAGED
			
			child.show_point()
	
	emit_signal("score_computed", score)
	
func play_apple_picked_sound():
	apple_pick_sound_player.play()

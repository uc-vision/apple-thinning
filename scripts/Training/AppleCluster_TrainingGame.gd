extends Spatial

onready var apple_pick_sound_player = $ApplePickSound
var rng = RandomNumberGenerator.new()
var score = 0
var remaining_apple_count = 0 setget set_remaining_apple_count, get_remaining_apple_count
# Makes apples only pickable during the game play.
var is_interactable = false
var hasDamaged
var initial_apple_count

signal score_computed(score)
signal apple_picked

const Point = {
	HEALTHY_LARGE = 200,
	HEALTHY_SMALL = 100,
	DAMAGED = -300,
}

# TODO Make this globa since this is also used in AppleTree_TrainingGame.gd
enum EvaluateNumFruitletLeftResult {
	SUCCESSFUL, OVERTHINNED, UNDERTHINNED, MISSED
}

#== Getters and setters =====

func get_remaining_apple_count():
	return remaining_apple_count
	
func set_remaining_apple_count(num_apple):
	remaining_apple_count = num_apple

#== End of getters and setters ====

func _ready():
	initial_apple_count = $Apples.get_child_count()
	set_remaining_apple_count(initial_apple_count)
	is_interactable = true


func initialize(spawn_location):
	# Spawn this cluster on the given location
	set_translation(spawn_location)
	# Give a random rotation on the apple clusters in Y direction
	var rotation_offset = rng.randf_range(-180, 180)
	var rotation_vector = Vector3(0, deg2rad(rotation_offset), 0)
	$Apples.set_rotation(rotation_vector)


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
	var apples = $Apples.get_children()
	for apple in apples:
		var groups = apple.get_groups()
		if !apple.picked_off:
			if groups.has("HealthyLarge"):
				score += Point.HEALTHY_LARGE
			elif groups.has("HealthySmall"):
				score += Point.HEALTHY_SMALL
			else:
				hasDamaged = true
				score += Point.DAMAGED
			
			apple.show_point()
	
	emit_signal("score_computed", score)
	
func play_apple_picked_sound():
	apple_pick_sound_player.play()
	
func show_evaluation_feedback(result):
	
	# Enable the visibility of the parent node of evaluation feedback icons
	$EvaluationFeedback.set_visible(true)
	
	if result == EvaluateNumFruitletLeftResult.SUCCESSFUL:
		$EvaluationFeedback/Tick.set_visible(true)
	else:
		$EvaluationFeedback/Exclamation.set_visible(true)

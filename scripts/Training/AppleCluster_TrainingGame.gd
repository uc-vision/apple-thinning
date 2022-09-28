extends Spatial

onready var apple_pick_sound_player = $ApplePickSound
var rng = RandomNumberGenerator.new()
var score = 0
var remaining_apple_count = 0 setget set_remaining_apple_count, get_remaining_apple_count
var diseased_apple_count = 0 setget ,get_diseased_apple_count
var large_apple_count = 0 setget ,get_large_apple_count
var small_apple_count = 0 setget ,get_small_apple_count
var sunshine_apple_count = 0 setget, get_sunshine_apple_count

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

enum EvaluationIconType {
	ERROR, WARNING, PASS, ONE_STAR, DOUBLE_STARS, TRIPLE_STARS 
}

#== Getters and setters =====

func get_remaining_apple_count():
	return remaining_apple_count
	
func set_remaining_apple_count(num_apple):
	remaining_apple_count = num_apple

func get_diseased_apple_count():
	var result = 0
	var apples = $Apples.get_children()
	for apple in apples:
		var groups = apple.get_groups()
		if !apple.picked_off:
			if groups.has("Damaged"):
				result += 1
		
	return result
	
func get_large_apple_count():
	var result = 0
	var apples = $Apples.get_children()
	for apple in apples:
		var groups = apple.get_groups()
		if !apple.picked_off:
			if groups.has("HealthyLarge"):
				result += 1
		
	return result
	
func get_small_apple_count():
	var result = 0
	var apples = $Apples.get_children()
	for apple in apples:
		var groups = apple.get_groups()
		if !apple.picked_off:
			if groups.has("HealthySmall"):
				result += 1
		
	return result

func get_sunshine_apple_count():
	sunshine_apple_count = 0
	var apples = $Apples.get_children()
	for apple in apples:
		if apple.has_strong_sun_exposure:
			sunshine_apple_count += 1

	return sunshine_apple_count

#== End of getters and setters ====

func _ready():
	initial_apple_count = $Apples.get_child_count()
	set_remaining_apple_count(initial_apple_count)
	is_interactable = true
	
	var apple_type
	for apple in $Apples.get_children():
		apple_type = apple.get_groups()
		if "HealthyLarge" in apple_type:
			apple.connect("on_picked", self, "_on_HealthyLargeApple_on_picked")
		elif "HealthySmall" in apple_type:
			apple.connect("on_picked", self, "_on_HealthySmallApple_on_picked")
		elif "Damaged" in apple_type:
			apple.connect("on_picked", self, "_on_DamagedApple_on_picked")


func initialize(spawn_location):
	
	# Spawn this cluster on the given location
	set_translation(spawn_location)
	
	# Give a random rotation on the apple clusters in Y direction
	var rotation_offset = rng.randf_range(-180, 180)
	var rotation_vector = Vector3(0, deg2rad(rotation_offset), 0)
	$Apples.set_rotation(rotation_vector)
	
	# Set the rotation of the cluster to make the cluster evaluation faced to player
	transform.origin = Vector3()


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
	
func show_icon(feedback_type):
	$EvaluationFeedback.set_visible(true)
	
	if feedback_type == EvaluationIconType.PASS:
		$EvaluationFeedback/Tick.set_visible(true)
	elif feedback_type == EvaluationIconType.ONE_STAR:
		$EvaluationFeedback/Tick.set_visible(true)
		$EvaluationFeedback/OneStar.set_visible(true)
	elif feedback_type == EvaluationIconType.DOUBLE_STARS:
		$EvaluationFeedback/Tick.set_visible(true)
		$EvaluationFeedback/DoubleStars.set_visible(true)
	elif feedback_type == EvaluationIconType.TRIPLE_STARS:
		$EvaluationFeedback/Tick.set_visible(true)
		$EvaluationFeedback/TripleStars.set_visible(true)
	elif feedback_type == EvaluationIconType.WARNING:
		$EvaluationFeedback/Warning.set_visible(true)
	elif feedback_type == EvaluationIconType.ERROR:
		$EvaluationFeedback/Exclamation.set_visible(true)


# Based on the given evaluation results, assign the feedback type to the cluster. 
# Called from AppleTree_TrainingGame.gd
func show_evaluation_feedback(is_num_fruitlet_success, num_left_damaged, num_left_large):
	var feedback_type
	
	if is_num_fruitlet_success:
		if num_left_damaged == 0:
			if num_left_large == 2:
				if sunshine_apple_count > 0:
					feedback_type = EvaluationIconType.TRIPLE_STARS
				else:
					feedback_type = EvaluationIconType.DOUBLE_STARS
			elif num_left_large == 1:
				if sunshine_apple_count > 0:
					feedback_type = EvaluationIconType.DOUBLE_STARS
				else:
					feedback_type = EvaluationIconType.ONE_STAR
			elif num_left_large == 0:
				if sunshine_apple_count > 0:
					feedback_type = EvaluationIconType.ONE_STAR
				else:
					feedback_type = EvaluationIconType.PASS
		else:
			feedback_type = EvaluationIconType.WARNING
			
	else:
		feedback_type = EvaluationIconType.ERROR

	# Enable the visibility of the parent node of evaluation feedback icons
	
	show_icon(feedback_type)

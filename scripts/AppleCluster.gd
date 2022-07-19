extends Spatial

onready var rng = RandomNumberGenerator.new()
onready var score = 0
onready var remaining_apple_count = 0
onready var apple_pick_sound_player = $ApplePickSound
onready var isDropped = false
# Makes apples only pickable during the game play.
onready var is_interactable = false
onready var hasDamaged

const MAX_APPLE_NUM_TO_LEAVE = 2

signal score_updated(new_score, has_damaged)
signal apple_picked
signal cluster_finished

const Point = {
	HEALTHY_LARGE = 200,
	HEALTHY_SMALL = 100,
	DAMAGED = -300,
}

func _ready():
	var children = get_children()
	for child in children:
		if child.get_groups().has("Apple"):
			remaining_apple_count += 1


func initialize(spawn_location):
	set_translation(spawn_location)
	# Give a random rotation on the apple clusters in Y direction
	var rotation_offset = rng.randf_range(-180, 180)
	var rotation_vector = Vector3(0, deg2rad(rotation_offset), 0)
	set_rotation(rotation_vector)


func _on_HealthyLargeApple_on_picked(apple):
	emit_signal("apple_picked")
	play_apple_picked_sound()
	hide_point(apple)
	remaining_apple_count -= 1
	if remaining_apple_count <= MAX_APPLE_NUM_TO_LEAVE:
		calculate_score()
		is_interactable = false


func _on_HealthySmallApple_on_picked(apple):
	emit_signal("apple_picked")
	play_apple_picked_sound()
	hide_point(apple)
	remaining_apple_count -= 1
	if remaining_apple_count <= MAX_APPLE_NUM_TO_LEAVE:
		calculate_score()
		is_interactable = false
	

func _on_DamagedApple_on_picked(apple):
	emit_signal("apple_picked")
	play_apple_picked_sound()
	hide_point(apple)
	remaining_apple_count -= 1
	if remaining_apple_count <= MAX_APPLE_NUM_TO_LEAVE:
		calculate_score()
		is_interactable = false
		
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
	
	if hasDamaged:
		$PoorlyThinnedSoundPlayer.play()
	else:
		$ThinningCompletedSoundPlayer.play()
	
	emit_signal("score_updated", score, hasDamaged)
	emit_signal("cluster_finished")
	
func play_apple_picked_sound():
	apple_pick_sound_player.play()
	
func hide_point(apple):
	if apple.is_score_visible:
		apple.hide_point()

func drop_cluster():
	# Drop all the apples in the cluster
	for child in get_children():
		if "Apple" in child.get_groups():
			if child.get_mode() == RigidBody.MODE_STATIC:
				child.set_mode(RigidBody.MODE_RIGID)
				
	score = 0
	emit_signal("cluster_finished")
	emit_signal("score_updated", score, false)
	isDropped = true
	is_interactable = false

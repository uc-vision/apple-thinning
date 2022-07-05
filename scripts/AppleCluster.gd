extends Spatial

onready var old_score
onready var current_score = 0
onready var remaining_apple_count = 0
onready var apple_pick_sound_player = $ApplePickSound
onready var score = get_tree().root.get_node("Game/Score")
onready var point
onready var isDropped = false
# Makes apples only pickable during the game play.
onready var isPickable = false

onready var MAX_APPLE_NUM_TO_LEAVE = 2

signal score_updated(old_score, new_score)

const Point = {
	HEALTHY_LARGE = 2,
	HEALTHY_SMALL = 1,
	DAMAGED = -3,
}

func _ready():
	var children = get_children()
	for child in children:
		if child.get_groups().has("Apple"):
			remaining_apple_count += 1


func initialize(spawn_location):
	set_translation(spawn_location)
	play_apple_picked_sound()


func _on_HealthyLargeApple_on_picked(apple):
	play_apple_picked_sound()
	hide_point(apple)
	remaining_apple_count -= 1
	if remaining_apple_count <= MAX_APPLE_NUM_TO_LEAVE:
		calculate_score()


func _on_HealthySmallApple_on_picked(apple):
	play_apple_picked_sound()
	hide_point(apple)
	remaining_apple_count -= 1
	if remaining_apple_count <= MAX_APPLE_NUM_TO_LEAVE:
		calculate_score()
	

func _on_DamagedApple_on_picked(apple):
	play_apple_picked_sound()
	hide_point(apple)
	remaining_apple_count -= 1
	if remaining_apple_count <= MAX_APPLE_NUM_TO_LEAVE:
		calculate_score()
		
func calculate_score():
	old_score = current_score
	current_score = 0
	var children = get_children()
	for child in children:
		var groups = child.get_groups()
		if groups.has("Apple") and !child.picked_off:
			if groups.has("HealthyLarge"):
				current_score += Point.HEALTHY_LARGE
			elif groups.has("HealthySmall"):
				current_score += Point.HEALTHY_SMALL
			else:
				current_score += Point.DAMAGED
			
			child.show_point()
	
	emit_signal("score_updated", old_score, current_score)

	
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
				
	old_score = current_score
	current_score = 0
	emit_signal("score_updated", old_score, current_score)
	isDropped = true

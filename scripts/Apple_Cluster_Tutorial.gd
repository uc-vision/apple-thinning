extends Spatial

onready var rng = RandomNumberGenerator.new()
onready var score = 0
onready var remaining_apple_count = 0
onready var apple_pick_sound_player = $ApplePickSound
# Makes apples only pickable during the game play.
onready var is_interactable = true
onready var hasDamaged

const MAX_APPLE_NUM_TO_LEAVE = 2

signal apple_picked


func _ready():
	var children = get_children()
	for child in children:
		if child.get_groups().has("Apple"):
			remaining_apple_count += 1


func _on_HealthyLargeApple_on_picked(apple):
	emit_signal("apple_picked")
	play_apple_picked_sound()
	remaining_apple_count -= 1

func _on_HealthySmallApple_on_picked(apple):
	emit_signal("apple_picked")
	play_apple_picked_sound()
	remaining_apple_count -= 1

func _on_DamagedApple_on_picked(apple):
	emit_signal("apple_picked")
	play_apple_picked_sound()
	remaining_apple_count -= 1


func play_apple_picked_sound():
	apple_pick_sound_player.play()

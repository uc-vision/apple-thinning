extends Spatial

onready var choose_level_dialog = $ChooseLevelDialog

signal play_training_game_mode
signal play_time_attack_game_mode
signal play_tutorial_game_mode

# Called when the node enters the scene tree for the first time.
func _ready():
	choose_level_dialog.connect("play_training_game_pressed", self, "_on_NoTimeLimit_pressed")
	choose_level_dialog.connect("play_time_attack_game_pressed", self, "_on_TimeAttack_pressed")
	choose_level_dialog.connect("play_tutorial_game_pressed", self, "_on_Tutorial_pressed")

func set_player(player):
	# Add the player to MenuScene with human readable name
	add_child(player, true)
	player.set_name("ARVROrigin")
	$ARVROrigin/LeftHand/RemainingTimeWatch.set_visible(false)
	$ARVROrigin/RightHand/ScoreAndComboWatch.set_visible(false)

func _on_NoTimeLimit_pressed():
	emit_signal("play_training_game_mode")
	
func _on_TimeAttack_pressed():
	emit_signal("play_time_attack_game_mode")

func _on_Tutorial_pressed():
	get_tree().root.get_node("Game/AudioStreamPlayer").play()
	emit_signal("play_tutorial_game_mode")

extends Spatial

onready var choose_level_dialog = $ChooseLevelDialog

signal play_no_time_limit_mode
signal play_time_attack_mode

# Called when the node enters the scene tree for the first time.
func _ready():
	choose_level_dialog.connect("no_time_limit_pressed", self, "_on_NoTimeLimit_pressed")
	choose_level_dialog.connect("time_attack_pressed", self, "_on_TimeAttack_pressed")

func set_player(player):
	# Add the player to GamePlayScene with human readable name
	add_child(player, true)
	player.set_name("ARVROrigin")
	$ARVROrigin/LeftHand/RemainingTimeWatch.set_visible(false)
	$ARVROrigin/RightHand/ScoreAndComboWatch.set_visible(false)

func _on_NoTimeLimit_pressed():
	choose_level_dialog.disable_buttons()
	emit_signal("play_no_time_limit_mode")
	
func _on_TimeAttack_pressed():
	choose_level_dialog.disable_buttons()
	emit_signal("play_time_attack_mode")

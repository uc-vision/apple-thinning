extends Spatial

signal exit_to_menu
var signal_sent = false

var CURRENT_SECTION = 0
var SECTION_LIST = [] # list of items to generate for each section

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func set_player(player):
	# Add the player to MenuScene with human readable name
	add_child(player, true)
	player.set_name("ARVROrigin")
	$ARVROrigin/LeftHand/RemainingTimeWatch.set_visible(false)
	$ARVROrigin/RightHand/ScoreAndComboWatch.set_visible(false)

func play_button_press_sound():
	$ButtonPressSoundPlayer.play()

func _on_ExitToMenuGameButton_area_entered(area):
	if "HandArea" in area.get_groups() and not signal_sent:
		#get_tree().root.get_node("Game/AudioStreamPlayer").play()
		play_button_press_sound()
		signal_sent = true
		emit_signal("exit_to_menu")


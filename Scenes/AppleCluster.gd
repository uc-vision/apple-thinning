extends Spatial

var score


# Called when the node enters the scene tree for the first time.
func _ready():
	score = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Apple_on_picked(points):
	score += points
	get_node("/root/AudioStreamPlayer").play()
	$AudioStreamPlayer.play()

	play_beep()
	
		
func play_beep():
	var beep_player = get_node("../AudioStreamPlayer")
	beep_player.play()

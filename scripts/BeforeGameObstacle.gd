extends MeshInstance




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func update_game_start_countdown(countdown_time_text):
	$Viewport/GameStartContdownContainer/GameStartCountdown.set_text(countdown_time_text)

func remove_obstacle():
	self.queue_free()

extends MeshInstance




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func update_label(ready_set_go_text):
	$Viewport/GameStartCountdown.set_text(ready_set_go_text)

func say_ready():
	$ReadyVoicePlayer.play()
	
func say_set():
	$SetVoicePlayer.play()
	
func say_go():
	$GoVoicePlayer.play()

func play_times_up_whistle():
	$TimesUpWhistlePlayer.play()

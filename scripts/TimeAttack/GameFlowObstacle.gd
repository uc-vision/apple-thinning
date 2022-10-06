extends MeshInstance

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

		
func update_before_game_obstacle(game_start_countdown):
	if game_start_countdown == 3:
		update_label("Ready")
		say_ready()
	elif game_start_countdown == 2:
		update_label("Set")
		say_set()
	elif game_start_countdown == 1:
		update_label("Go!")
		say_go()
		
func hide_game_flow_obstacle():
	set_visible(false)
	
func show_game_flow_obstacle():
	update_label("Finish!")
	set_visible(true)
	play_times_up_whistle()

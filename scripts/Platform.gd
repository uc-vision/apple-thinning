extends Spatial

onready var controller = $PlatformController
onready var game_flow_obstacle = $GameFlowObstacle
onready var pause_button = $PauseButton
onready var platform_up_sound_player = $PlatformUpSoundPlayer
onready var platform_down_sound_player = $PlatformDownSoundPlayer

var elevate_vector
var lower_vector
const PLATFORM_SPEED = 0.7
const ELEVATE_DIRECTION = Vector3(0, 1, 0)
const LOWER_DIRECTION = Vector3(0, -1, 0)
const LOW_BOUNDARY = 0.05
const HIGH_BOUNDARY = 2

enum State {
	DISABLED,
	IDLE,
	ELEVATING,
	LOWERING
}
	
func enable_platform_motion():
	controller.enable_buttons()
	
func disable_platform_motion():
	controller.disable_buttons()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	# Elavate the platform
	if (controller.current_state == State.ELEVATING and get_translation().y < HIGH_BOUNDARY):
		elevate_vector = PLATFORM_SPEED * ELEVATE_DIRECTION * delta
		translate(elevate_vector)
		if not platform_up_sound_player.is_playing():
			platform_up_sound_player.play()
		
	# Lower the platform
	if (controller.current_state == State.LOWERING and get_translation().y > LOW_BOUNDARY):
		lower_vector = PLATFORM_SPEED * LOWER_DIRECTION * delta
		translate(lower_vector)
		if not platform_down_sound_player.is_playing():
			platform_down_sound_player.play()
		
func update_before_game_obstacle(game_start_countdown):
	if game_start_countdown == 3:
		game_flow_obstacle.update_label("Ready")
		game_flow_obstacle.say_ready()
	elif game_start_countdown == 2:
		game_flow_obstacle.update_label("Set")
		game_flow_obstacle.say_set()
	elif game_start_countdown == 1:
		game_flow_obstacle.update_label("Go!")
		game_flow_obstacle.say_go()
		
func hide_game_flow_obstacle():
	game_flow_obstacle.set_visible(false)
	
func show_game_flow_obstacle():
	game_flow_obstacle.update_label("Finish!")
	game_flow_obstacle.set_visible(true)
	game_flow_obstacle.play_times_up_whistle()

	
func play_button_press_sound():
	$ButtonPressSoundPlayer.play()

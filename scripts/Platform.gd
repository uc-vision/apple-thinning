extends Spatial

onready var controller = $PlatformController
onready var before_game_obstacle = $BeforeGameObstacle

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
		
	# Lower the platform
	if (controller.current_state == State.LOWERING and get_translation().y > LOW_BOUNDARY):
		lower_vector = PLATFORM_SPEED * LOWER_DIRECTION * delta
		translate(lower_vector)
		
func update_before_game_obstacle(game_start_countdown):
	if game_start_countdown == 3:
		before_game_obstacle.update_label("Ready")
	elif game_start_countdown == 2:
		before_game_obstacle.update_label("Set")
	elif game_start_countdown == 1:
		before_game_obstacle.update_label("Go!")

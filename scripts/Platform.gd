extends Spatial

onready var controller = $PlatformController
var player = get_tree().root.get_node("Game/ARVROrigin")
var current_player_translate

var elevate_vector
var lower_vector
const PLATFORM_SPEED = 0.7
const ELEVATE_DIRECTION = Vector3(0, 1, 0)
const LOWER_DIRECTION = Vector3(0, -1, 0)

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
	if (controller.current_state == State.ELEVATING):
		elevate_vector = PLATFORM_SPEED * ELEVATE_DIRECTION * delta
		translate(elevate_vector)
		
	# Lower the platform
	if (controller.current_state == State.LOWERING):
		lower_vector = PLATFORM_SPEED * LOWER_DIRECTION * delta
		translate(lower_vector)

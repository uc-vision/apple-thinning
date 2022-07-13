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

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func enable_platform_motion():
	controller.enable_buttons()
	
func disable_platform_motion():
	controller.disable_buttons()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	if (controller.current_state == State.ELEVATING):
		get_tree().root.get_node("Game/AudioStreamPlayer").play()
		elevate_vector = PLATFORM_SPEED * ELEVATE_DIRECTION * delta
		translate(elevate_vector)
		player.global_translate(elevate_vector)

	if (controller.current_state == State.LOWERING):
		get_tree().root.get_node("Game/AudioStreamPlayer").play()
		lower_vector = PLATFORM_SPEED * LOWER_DIRECTION * delta
		translate(lower_vector)
		player.global_translate(lower_vector)

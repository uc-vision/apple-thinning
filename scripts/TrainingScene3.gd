extends Spatial

onready var TV = $Viewport/VideoPlayer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const PATH = "res://Assets/Videos/%s.webm"

# Called when the node enters the scene tree for the first time.
func _ready():
	play_video()



func play_video():
	# Called every time the node is added to the scene.
	# Initialization here
	get_tree().root.get_node("Game/AudioStreamPlayer").play()
	var parent_name = get_parent().get_name()
	var video_path = PATH % parent_name
	
	if load(video_path):
		TV.stream = load(video_path)
		TV.play()
	
	#$Viewport/VideoPlayer.set_stream("res://Assets/Videos/TrainingScene1.webm")
	#var parent_name = get_parent().get_name()
	#var video_path = PATH % parent_name
	


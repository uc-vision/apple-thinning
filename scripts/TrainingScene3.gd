extends Spatial

onready var TV = $Viewport/VideoPlayer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const PATH = "res://Assets/Videos/%s.ogv"

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false) # dont check for video playing until video is playing

func _process(delta):    
	if not TV.is_playing():        
		TV.play()


func play_video():
	# Called every time the node is added to the scene.
	# Initialization here
	
	var parent_name = get_parent().get_name()
	var video_path = PATH % parent_name
	var video = load(video_path)
	
	if video: 
		TV.stream = video
		TV.play()
	
	set_process(true) # start process checking video player to loop playing
	
	#$Viewport/VideoPlayer.set_stream("res://Assets/Videos/TrainingScene1.webm")
	#var parent_name = get_parent().get_name()
	#var video_path = PATH % parent_name


#Timer to wait 1 second before starting video
func _on_VideoWaitTimer_timeout():
	play_video()
	

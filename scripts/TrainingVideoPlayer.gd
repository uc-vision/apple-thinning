extends Spatial

onready var TV = $Viewport/VideoPlayer
const PATH = "res://Assets/Videos/%s.ogv"

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false) # dont check for video playing until video is playing

# Continual monitoring for video end to restart video
func _process(delta):    
	if not TV.is_playing():        
		TV.play()

# Called every time the node is added to the scene.
# Initialization of video preformed here
func play_video():
	var parent_name = get_parent().get_name()
	var video_path = PATH % parent_name
	var video = load(video_path)
	
	# play when loaded
	if video: 
		TV.stream = video
		TV.play()
	
	# start process checking video player to loop playing
	set_process(true) 

#Timer to wait 1 second before starting video
func _on_VideoWaitTimer_timeout():
	play_video()

extends Spatial

# JADES DEBUGGING MAGIC
# get_tree().root.get_node("Game/AudioStreamPlayer").play()

const MAX_SCENE_NUMBER = 5 # Scences start at 0 like arrays but end on last scene #
const SCENE_PATH = "res://Scenes/Tutorial/TrainingScene%s.tscn"

var current_scene_number = 0
var current_scene
var scene_instance


# Called when the node enters the scene tree for the first time.
func _ready():
	current_scene = load(SCENE_PATH % 0)
	scene_instance = current_scene.instance()
	add_child(scene_instance)



# Logic to check transition is valid and then make trasition
func next_scene(transition):
	if current_scene_number == 0 and transition == -1:
		# TODO add error sound
		pass
	elif current_scene_number == MAX_SCENE_NUMBER and transition == 1:
		# TODO add error sound
		pass
	else:
		current_scene_number += transition
		load_scene(current_scene_number)
	

func load_scene(scene_num):
	delete_scene()
	current_scene = load(SCENE_PATH % scene_num)
	scene_instance = current_scene.instance()
	add_child(scene_instance)

func delete_scene():
	scene_instance.queue_free()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

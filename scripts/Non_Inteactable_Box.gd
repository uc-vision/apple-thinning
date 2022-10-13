extends Spatial

onready var BlueShader = preload("res://Assets/Meshes/MaterialBlue.material")
onready var GreyShader = preload("res://Assets/Meshes/MaterialTransparentGrey.material")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#get_tree().root.get_node("Game/AudioStreamPlayer").play()
	#get_tree().root.get_node("Game/Debugger").new_debug_log("loaded")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_Area_area_entered(area):
	#area.get_name()
	get_tree().root.get_node("Game/AudioStreamPlayer").play()
	#get_tree().root.get_node("Game/Debugger").new_debug_log(area.get_parent().get_name())
	
	if area.get_parent().get_name() == "RightHand":
		get_tree().root.get_node("Game/Debugger").new_debug_log("RIGHT!")
		area.get_node("../HandContainer/HandModel/Armature/Skeleton/r_handMeshNode").set_surface_material(0, GreyShader)
	elif area.get_parent().get_name() == "LeftHand":
		get_tree().root.get_node("Game/Debugger").new_debug_log("LEFT!")
		area.get_node("../HandContainer/HandModel/Armature/Skeleton/l_handMeshNode").set_surface_material(0, GreyShader)
	else:
		get_tree().root.get_node("Game/Debugger").new_debug_log("Something went wrong!")

	pass # Replace with function body.


func _on_Area_area_exited(area):
		#area.get_name()
	get_tree().root.get_node("Game/AudioStreamPlayer").play()
	#get_tree().root.get_node("Game/Debugger").new_debug_log(area.get_parent().get_name())
	
	if area.get_parent().get_name() == "RightHand":
		get_tree().root.get_node("Game/Debugger").new_debug_log("RIGHT!")
		area.get_node("../HandContainer/HandModel/Armature/Skeleton/r_handMeshNode").set_surface_material(0, BlueShader)
	elif area.get_parent().get_name() == "LeftHand":
		get_tree().root.get_node("Game/Debugger").new_debug_log("LEFT!")
		area.get_node("../HandContainer/HandModel/Armature/Skeleton/l_handMeshNode").set_surface_material(0, BlueShader)
	else:
		get_tree().root.get_node("Game/Debugger").new_debug_log("Something went wrong!")
	pass # Replace with function body.

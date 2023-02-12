extends Spatial

onready var BlueShader = preload("res://Assets/Meshes/Material_Hand.tres")
onready var GreyShader = preload("res://Assets/Meshes/MaterialRed.material")


func _ready():
	pass # Replace with function body.



func _on_Area_area_entered(area):
	
	if area.get_parent().get_name() == "RightHand":
		area.get_node("../HandContainer/HandModel/Armature/Skeleton/r_handMeshNode").set_surface_material(0, GreyShader)
	elif area.get_parent().get_name() == "LeftHand":
		area.get_node("../HandContainer/HandModel/Armature/Skeleton/l_handMeshNode").set_surface_material(0, GreyShader)
	pass # Replace with function body.



func _on_Area_area_exited(area):
	
	if area.get_parent().get_name() == "RightHand":
		area.get_node("../HandContainer/HandModel/Armature/Skeleton/r_handMeshNode").set_surface_material(0, BlueShader)
	elif area.get_parent().get_name() == "LeftHand":
		area.get_node("../HandContainer/HandModel/Armature/Skeleton/l_handMeshNode").set_surface_material(0, BlueShader)
	pass # Replace with function body.

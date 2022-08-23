extends MeshInstance


# Declare member variables here. Examples:
# var a = 2
# var b = "text"




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_PreviousButtonArea_area_entered(area):
	$ButtonPressSoundPlayer.play()
	get_node("../../SceneController").next_scene(-1)
	pass # Replace with function body.


func _on_NextButtonButtonArea_area_entered(area):
	$ButtonPressSoundPlayer.play()
	get_node("../../SceneController").next_scene(1)
	pass # Replace with function body.


func _on_NextButtonButtonArea_area_exited(area):
	pass # Replace with function body.


func _on_PreviousButtonArea_area_exited(area):
	pass # Replace with function body.

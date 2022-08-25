extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#get_tree().root.get_node("Game/AudioStreamPlayer").play()
	setup_apples()
	

# Called when the node enters the scene tree for the first time.
# apples and make them interactable
func setup_apples():
	#$AppleTree.connect("all_clusters_thinned", self, "_on_AppleTree_finished_thinning")
	
	for child in $Trunk.get_children():
		#get_tree().root.get_node("Game/AudioStreamPlayer").play()
		if "Branch" in child.get_groups():
			for branch_child in child.get_children():
				if "AppleCluster" in branch_child.get_groups():
					#branch_child.connect("score_updated", self, "_on_AppleCluster_score_updated")
					#branch_child.connect("apple_picked", self, "_on_AppleCluster_apple_picked")
					branch_child.is_interactable = true
					get_tree().root.get_node("Game/AudioStreamPlayer").play()



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

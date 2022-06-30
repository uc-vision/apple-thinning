extends Spatial

onready var apple_cluster_a = preload("res://Scenes/AppleCluster_TypeA.tscn")
onready var apple_cluster_b = preload("res://Scenes/AppleCluster_TypeB.tscn")
onready var apple_cluster_c = preload("res://Scenes/AppleCluster_TypeC.tscn")
onready var rng = RandomNumberGenerator.new()
onready var cluster_type
onready var cluster_spawn_location

enum CLUSTER_TYPE {
	A,
	B,
	C
}
const MAX_CLUSTER_PER_BRANCH = 5
const NUM_BRANCH = 3

func _ready():
	
	# Iterate over branches in the tree
	for child in get_children():
		if 'Branch' in child.get_groups():
		
			# Get the spawn path on the branch
			var cluster_spawn_path = child.get_node("AppleClusterSpawnPath")
			
			# Random number of apples per branch is spawned 
			for i in range(rng.randi_range(1, MAX_CLUSTER_PER_BRANCH)):
				
				# Get the spawning location node
				cluster_spawn_location = cluster_spawn_path.get_node("PathFollow")
				# Give a random offset of the spawning location
				cluster_spawn_location.unit_offset = rng.randf()
				# Pick a type of apple cluster to spawn randomly
				cluster_type = rng.randi() % 3

				# Instantiate the apple cluster
				if cluster_type == 0:
					var apple_cluster_a_instance = apple_cluster_a.instance()
					apple_cluster_a_instance.initialize(cluster_spawn_location.translation)
					child.add_child(apple_cluster_a_instance)
				elif cluster_type == 1:
					var apple_cluster_b_instance = apple_cluster_b.instance()
					apple_cluster_b_instance.initialize(cluster_spawn_location.translation)
					child.add_child(apple_cluster_b_instance)
				else:
					var apple_cluster_c_instance = apple_cluster_c.instance()
					apple_cluster_c_instance.initialize(cluster_spawn_location.translation)
					child.add_child(apple_cluster_c_instance)
					
func tree_hit():
	var area_node = get_node("Branch1/Areas/Area")
	get_tree().root.get_node("Game/AudioStreamPlayer").play()
	
	var branch = area_node.get_parent().get_parent()
	
	for child in branch.get_children():
		if "AppleCluster" in child.get_groups():
			child.drop_cluster()

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

# Find all the spawn path on a tree. Different trees may have different numbers of branch. So the number of path is dynamic.
	for child in get_children():
		if 'ClusterSpawnPath' in child.get_groups():
			for i in range(rng.randi_range(1, MAX_CLUSTER_PER_BRANCH)):
				cluster_spawn_location = child.get_child(0)
				cluster_spawn_location.unit_offset = rng.randf()
				
				cluster_type = rng.randi() % 3
#
				if cluster_type == 0:
					var apple_cluster_a_instance = apple_cluster_a.instance()
					apple_cluster_a_instance.initialize(cluster_spawn_location.translation)
					add_child(apple_cluster_a_instance)
				elif cluster_type == 1:
					var apple_cluster_b_instance = apple_cluster_b.instance()
					apple_cluster_b_instance.initialize(cluster_spawn_location.translation)
					add_child(apple_cluster_b_instance)
				else:
					var apple_cluster_c_instance = apple_cluster_c.instance()
					apple_cluster_c_instance.initialize(cluster_spawn_location.translation)
					add_child(apple_cluster_c_instance)

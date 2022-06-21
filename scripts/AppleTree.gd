extends Spatial

onready var apple_cluster_a = preload("res://Scenes/AppleCluster_TypeA.tscn")
onready var apple_cluster_b = preload("res://Scenes/AppleCluster_TypeB.tscn")
onready var apple_cluster_c = preload("res://Scenes/AppleCluster_TypeC.tscn")
onready var rng = RandomNumberGenerator.new()

enum CLUSTER_TYPE {
	A,
	B,
	C
}
const MAX_CLUSTER_PER_BRANCH = 5
const NUM_BRANCH = 3

func _ready():
	
	var cluster_instance = apple_cluster_a.instance()
	var cluster_spawn_location = $AppleClusterSpawnPath1/PathFollow
	cluster_instance.initialize(cluster_spawn_location.translation)
	add_child(cluster_instance)
	
	
	
#	# Find all the spawn path on a tree. Different trees may have different numbers of branch. So the number of path is dynamic.
#	for child in get_children():
#		if 'ClusterSpawnPath' in child.get_groups():
#			for i in range(rng.randi() % MAX_CLUSTER_PER_BRANCH):
#				var cluster_spawn_location = child.get_child(0)
#				cluster_spawn_location.unit_offset = rng.randf()
#
#				var cluster_type = randi() % 3
#				get_node("AudioStreamPlayer3D").play()
#				match cluster_type:
#					CLUSTER_TYPE.A:
#						add_child(apple_cluster_a.instance())
#						apple_cluster_a.initialize(cluster_spawn_location.translation)
#					CLUSTER_TYPE.B:
#						add_child(apple_cluster_b.instance())
#						apple_cluster_b.initialize(cluster_spawn_location.translation)
#					CLUSTER_TYPE.C:
#						add_child(apple_cluster_c.instance())
#						apple_cluster_c.initialize(cluster_spawn_location.translation)

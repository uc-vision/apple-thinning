extends Spatial

onready var apple_cluster_a = preload("res://Scenes/AppleCluster_TypeA.tscn")
onready var apple_cluster_b = preload("res://Scenes/AppleCluster_TypeB.tscn")
onready var apple_cluster_c = preload("res://Scenes/AppleCluster_TypeC.tscn")
onready var apple_cluster_fall_sound_player = get_node("AppleClusterFallSoundPlayer")
onready var rng = RandomNumberGenerator.new()
onready var cluster_type
onready var cluster_spawn_location
onready var num_cluster = 0

const MAX_CLUSTER_PER_BRANCH = 5
const NUM_BRANCH = 3
const TREE_TRANSLATE = Vector3(-0.8, 0.13, 0.08)
const TREE_ROTATION = Vector3(0, 2.4, 0)

signal all_clusters_thinned

func _ready():
	
	set_translation(TREE_TRANSLATE)
	set_rotation(TREE_ROTATION)
	
	# Iterate over branches in the tree
	for child in get_children():
		if 'Branch' in child.get_groups():
		
			# Get the spawn path on the branch
			var cluster_spawn_path = child.get_node("AppleClusterSpawnPath")
			
			# Random number of apples per branch is spawned 
			for i in range(rng.randi_range(1, MAX_CLUSTER_PER_BRANCH)):
				
				# Count the number of apple clusters spawned in the tree.
				num_cluster += 1
				
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
					apple_cluster_a_instance.connect("cluster_finished", self, "_on_AppleCluster_finished")
					child.add_child(apple_cluster_a_instance)
				elif cluster_type == 1:
					var apple_cluster_b_instance = apple_cluster_b.instance()
					apple_cluster_b_instance.initialize(cluster_spawn_location.translation)
					apple_cluster_b_instance.connect("cluster_finished", self, "_on_AppleCluster_finished")
					child.add_child(apple_cluster_b_instance)
				else:
					var apple_cluster_c_instance = apple_cluster_c.instance()
					apple_cluster_c_instance.initialize(cluster_spawn_location.translation)
					apple_cluster_c_instance.connect("cluster_finished", self, "_on_AppleCluster_finished")
					child.add_child(apple_cluster_c_instance)
					
func tree_hit(area_node):
	
	# Get all the clusters belong to the hit area
	var overlapping_apples = area_node.get_overlapping_areas()
	
	# Drop the clusters that belong to the area
	for area in overlapping_apples:
		if area.get_name() == "ClusterHub":
			var parent_cluster = area.get_parent()
			if not parent_cluster.isDropped and parent_cluster.is_interactable:
				apple_cluster_fall_sound_player.play()
				parent_cluster.drop_cluster()

func _on_AppleCluster_finished():
	num_cluster -= 1
	if num_cluster == 0:
		$ThinningCompletedSoundPlayer.play()
		emit_signal("all_clusters_thinned")

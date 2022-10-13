extends Spatial

onready var apple_cluster_a = preload("res://Scenes/TimeAttack/AppleCluster_TimeAttackGame_TypeA.tscn")
onready var apple_cluster_b = preload("res://Scenes/TimeAttack/AppleCluster_TimeAttackGame_TypeB.tscn")
onready var apple_cluster_c = preload("res://Scenes/TimeAttack/AppleCluster_TimeAttackGame_TypeC.tscn")
onready var apple_cluster_fall_sound_player = get_node("AppleClusterFallSoundPlayer")
onready var rng = RandomNumberGenerator.new()
onready var cluster_type
onready var cluster_spawn_location
onready var num_cluster = 0

const MAX_CLUSTER_PER_BRANCH = 2
const NUM_BRANCH = 3
const TREE_TRANSLATE = Vector3(0, 0, -0.85)
const TREE_ROTATION = Vector3(0, deg2rad(-90), 0)

signal all_clusters_thinned

func _ready():
	
	set_translation(TREE_TRANSLATE)
	set_rotation(TREE_ROTATION)
	
	rng.randomize()
	
	# Iterate over branches in the tree
	for child in get_children():
		if 'Branch' in child.get_groups() and child.get_node("AppleClusterSpawnPath"):

			var cluster_spawn_location = child.get_node("AppleClusterSpawnPath/PathFollow")
			
			# Random number of apples per branch is spawned 
			for i in range(rng.randi_range(1, MAX_CLUSTER_PER_BRANCH)):
				
				# Count the number of apple clusters spawned in the tree.
				num_cluster += 1
				
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


func _on_AppleCluster_finished():
	num_cluster -= 1
	if num_cluster == 0:
		$ThinningCompletedSoundPlayer.play()
		emit_signal("all_clusters_thinned")

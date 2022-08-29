extends Spatial

onready var apple_cluster_a = preload("res://Scenes/Training/AppleCluster_TrainingGame_TypeA.tscn")
onready var apple_cluster_b = preload("res://Scenes/Training/AppleCluster_TrainingGame_TypeB.tscn")
onready var apple_cluster_c = preload("res://Scenes/Training/AppleCluster_TrainingGame_TypeC.tscn")
onready var apple_cluster_fall_sound_player = get_node("AppleClusterFallSoundPlayer")
onready var rng = RandomNumberGenerator.new()
onready var cluster_type
onready var cluster_spawn_location
onready var num_cluster = 0
var TrainingGameData = load("res://scripts/Classes/TrainingGameData.gd")

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
		if 'Branch' in child.get_groups():
		
			# Get the spawn path on the branch
			var cluster_spawn_path = child.get_node("AppleClusterSpawnPath")
			# Initialize a spawning location node and add to to the spawn path
			var cluster_spawn_location = PathFollow.new()
			cluster_spawn_path.add_child(cluster_spawn_location)
			
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
					child.add_child(apple_cluster_a_instance)
				elif cluster_type == 1:
					var apple_cluster_b_instance = apple_cluster_b.instance()
					apple_cluster_b_instance.initialize(cluster_spawn_location.translation)
					child.add_child(apple_cluster_b_instance)
				else:
					var apple_cluster_c_instance = apple_cluster_c.instance()
					apple_cluster_c_instance.initialize(cluster_spawn_location.translation)
					child.add_child(apple_cluster_c_instance)



# Evaluate the Rule 1: Thin down each cluster into two fruitlets
func evaluate_num_fruitlet_left(cluster):
	pass
#	var cluster.get_remaining_apple_count()



# Evaluate the Rule 2: Remove damaged/diseased fruitlets and leave healthy fruitlets
func evaluate_diseased_fruitlet_left(cluster):
	pass



# Evaluate the Rule 3: Remove smaller fruitlets and leave larger fruitlets
func evaluate_fruitlet_size(cluster):
	pass



#Rule 4. Leave fruitlets with more sun exposure
func evaluate_fruitlet_sun_exposure(cluster):
	pass



func evaluate():
	
	var training_game_data = TrainingGameData.new()
	
	# Iterate over branches in the tree
	for child in get_children():
		if 'Branch' in child.get_groups():
			for branch_child in child.get_children():
				if "AppleCluster" in branch_child.get_groups():
					evaluate_num_fruitlet_left(branch_child)
					evaluate_diseased_fruitlet_left(branch_child)
					evaluate_fruitlet_size(branch_child)
					evaluate_fruitlet_sun_exposure(branch_child)

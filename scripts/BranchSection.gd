extends Area

onready var parent_tree
onready var hand_area = null
var hand_velocity = Vector3(0, 0, 0)
var prior_hand_velocities = []
var prior_hand_position = Vector3(0, 0, 0)

const MIN_BRANCH_HIT_SPEED = 20

func _ready():
	# Get the parent tree which this branch area section belongs to
	parent_tree = get_parent().get_parent().get_parent()
	set_physics_process(false)

func _physics_process(delta):
	
	# If hand enters the branch section
	if hand_area:
		
		# Calculate the average speed of hand colliding to the branch
		var hand_global_transform = hand_area.global_transform
		
		if prior_hand_velocities.size() > 0:
			for velocity in prior_hand_velocities:
				hand_velocity += velocity
				
			hand_velocity = hand_velocity / prior_hand_velocities.size()
			
		if prior_hand_position:
			prior_hand_velocities.append((hand_global_transform.origin - prior_hand_position) / delta)
			hand_velocity += (hand_global_transform.origin - prior_hand_position) / delta
			
		prior_hand_position = hand_global_transform.origin
		
		if prior_hand_velocities.size() > 20:
			prior_hand_velocities.remove(0)
			
		# If the hand is colliding fast enough to the branch, make the cluster on that area fall
		if hand_velocity.length() > MIN_BRANCH_HIT_SPEED:
			parent_tree.tree_hit(self)


func _on_Section_area_entered(area):
	# Check if the entered area is a player'a hand.
	if "HandArea" in area.get_groups():
		hand_area = area
		get_node("BranchHitSoundPlayer").play()
		set_physics_process(true)


func _on_Section_area_exited(area):
	hand_area = null
	set_physics_process(false)

class_name OculusHandTracker
extends OculusTracker
# Extension of the OculusTracker class to support Oculus hands tracking.

var held_object = null
var held_object_time = 0
var held_object_original_parent = null
var grab_point_velocity = Vector3(0, 0, 0)
var prior_grab_point_velocities = []
var prior_grab_point_position = Vector3(0, 0, 0)

# Current hand pinch mapping for the tracked hands
# Godot itself also exposes some of these constants via JOY_VR_* and JOY_OCULUS_*
# this enum here is to document everything in place and includes the pinch event mappings
enum FINGER_PINCH {
	MIDDLE_PINCH = 1,
	PINKY_PINCH = 15,
	INDEX_PINCH = 7,
	RING_PINCH = 2,
}

# Current hand ping strength axis mapping for tracked hands.
enum FINGER_PINCH_STRENGTH_AXIS {
	INDEX = 4,
	MIDDLE = 5,
	RING = 8,
	PINKY = 9,
}

var hand_skel : Skeleton = null

# Oculus mobile APIs available at runtime.
var ovr_hand_tracking = null;
var ovr_utilities = null;

# This array is used to get the orientations from the sdk each frame (an array of Quat)
var _vrapi_bone_orientations = [];

# Remap the bone ids from the hand model to the bone orientations we get from the vrapi
var _hand_bone_mappings = [0, 23,  1, 2, 3, 4,  6, 7, 8,  10, 11, 12,  14, 15, 16, 18, 19, 20, 21];

# inverse mapping to get from the godot hand bone ids to the vrapi bone ids
const _hand2vrapi_bone_map = [0, 2, 3, 4, 5,19, 6, 7, 8, 20,  9, 10, 11, 21, 12, 13, 14, 22, 15, 16, 17, 18, 23, 1];

# we need the inverse neutral pose to compute the estimates for gesture detection
var _vrapi_inverse_neutral_pose = []; # this is filled when clearing the rest pose

# This is a test pose for the left hand used only on desktop so the hand has a proper position
var _test_pose_left_ThumbsUp = [Quat(0, 0, 0, 1), Quat(0, 0, 0, 1), Quat(0.321311, 0.450518, -0.055395, 0.831098),
Quat(0.263483, -0.092072, 0.093766, 0.955671), Quat(-0.082704, -0.076956, -0.083991, 0.990042),
Quat(0.085132, 0.074532, -0.185419, 0.976124), Quat(0.010016, -0.068604, 0.563012, 0.823536),
Quat(-0.019362, 0.016689, 0.8093, 0.586839), Quat(-0.01652, -0.01319, 0.535006, 0.844584),
Quat(-0.072779, -0.078873, 0.665195, 0.738917), Quat(-0.0125, 0.004871, 0.707232, 0.706854),
Quat(-0.092244, 0.02486, 0.57957, 0.809304), Quat(-0.10324, -0.040148, 0.705716, 0.699782),
Quat(-0.041179, 0.022867, 0.741938, 0.668812), Quat(-0.030043, 0.026896, 0.558157, 0.828755),
Quat(-0.207036, -0.140343, 0.018312, 0.968042), Quat(0.054699, -0.041463, 0.706765, 0.704111),
Quat(-0.081241, -0.013242, 0.560496, 0.824056), Quat(0.00276, 0.037404, 0.637818, 0.769273),
]


#GESTURE DETECTION
var tracking_confidence = 1.0;

onready var hand_model : Spatial = $HandContainer/HandModel
onready var grabPoint: Spatial = $HandContainer/GrabPoint
var defaultClickLocationColour = null

func _ready():
	_initialize_hands()

	ovr_hand_tracking = load("res://addons/godot_ovrmobile/OvrHandTracking.gdns");
	if (ovr_hand_tracking): ovr_hand_tracking = ovr_hand_tracking.new()

	ovr_utilities = load("res://addons/godot_ovrmobile/OvrUtilities.gdns")
	if (ovr_utilities): ovr_utilities = ovr_utilities.new()


func _initialize_hands():
	hand_skel = $HandContainer/HandModel/Armature/Skeleton

	_vrapi_bone_orientations.resize(24);
	_clear_bone_rest(hand_skel);


func _get_tracker_label():
	return "Oculus Tracked Left Hand"


# The rotations we get from the OVR sdk are absolute and not relative
# to the rest pose we have in the model; so we clear them here to be
# able to use set pose
# This is more like a workaround then a clean solution but allows to use
# the hand model from the sample without major modifications
func _clear_bone_rest(skel):
	_vrapi_inverse_neutral_pose.resize(skel.get_bone_count());
	skel.set_bone_rest(0, Transform());
	for i in range(0, skel.get_bone_count()):
		var bone_rest = skel.get_bone_rest(i);
		skel.set_bone_pose(i, Transform(bone_rest.basis)); # use the original rest as pose
		bone_rest.basis = Basis();
		skel.set_bone_rest(i, bone_rest);
		_vrapi_inverse_neutral_pose[_hand2vrapi_bone_map[i]] = bone_rest.basis.get_rotation_quat().inverse();
		_vrapi_bone_orientations[_hand2vrapi_bone_map[i]]  = bone_rest.basis.get_rotation_quat()


func _update_hand_model(model : Spatial, skel: Skeleton):
	if (ovr_hand_tracking): # check if the hand tracking API was loaded
		# scale of the hand model as reported by VrApi
		var ls = ovr_hand_tracking.get_hand_scale(controller_id);
		if (ls > 0.0): model.scale = Vector3(ls, ls, ls);

		tracking_confidence = ovr_hand_tracking.get_hand_pose(controller_id, _vrapi_bone_orientations);
		if (tracking_confidence > 0.0):
			model.visible = true;
			for i in range(0, _hand_bone_mappings.size()):
				skel.set_bone_pose(_hand_bone_mappings[i], Transform(_vrapi_bone_orientations[i]));
		else:
			model.visible = false;
		return true;
	else:
		return false;
	
	
	
func grab_object(object_to_pickup):
	if 'Apple' in object_to_pickup.get_groups() and object_to_pickup.is_interactable() and not object_to_pickup.is_picked_off():
		held_object = object_to_pickup
		held_object.mode = RigidBody.MODE_STATIC
		var original_position = held_object.global_transform
		
		held_object_original_parent  = held_object.get_parent()
		
		held_object_original_parent.remove_child(held_object)
		grabPoint.add_child(held_object)
		held_object.set_owner(grabPoint)
		held_object.global_transform = original_position
		held_object.picked_up()

	if object_to_pickup.has_method("interact"):
		#held_object = object_to_pickup #Does this need to be here?
		held_object.interact()
	
func drop_object():
	var original_position = held_object.global_transform
	
	grabPoint.remove_child(held_object)
	held_object_original_parent.add_child(held_object)
	held_object.set_owner(held_object_original_parent)
	held_object_original_parent  = null
	
	held_object.mode = RigidBody.MODE_RIGID
	held_object.global_transform = original_position
	if (held_object_time < 0.1):
		held_object.apply_impulse(Vector3(0, 0, 0), Vector3(0, 0, 0))
	else:
		held_object.apply_impulse(Vector3(0, 0, 0), grab_point_velocity)
	
	held_object = null
	held_object_time = 0


func _process(delta_t):
	if (held_object):
		held_object_time += delta_t
	
	_update_hand_model(hand_model, hand_skel);
	
	#This function is for the respective hand interaction mechanics
	var object_to_pickup = $HandContainer.detect_grabbing_object()
	
	
	
	
	if object_to_pickup and not held_object:
		grab_object(object_to_pickup)
	elif not object_to_pickup and held_object:
		drop_object()
	
	
	# If we are on desktop or don't have hand tracking we set a debug pose on the left hand
	if (controller_id == LEFT_TRACKER_ID && !ovr_hand_tracking):
		for i in range(0, _hand_bone_mappings.size()):
			hand_skel.set_bone_pose(_hand_bone_mappings[i], Transform(_test_pose_left_ThumbsUp[i]));


func _physics_process(delta):
	if held_object:
		# Get grab point velocity. Useful when wanting to throw objects
		grab_point_velocity = Vector3(0, 0, 0)
		if prior_grab_point_velocities.size() > 0:
			for vel in prior_grab_point_velocities:
				grab_point_velocity += vel

			# Get the average velocity, instead of just adding them together.
			grab_point_velocity = grab_point_velocity / prior_grab_point_velocities.size()

		prior_grab_point_velocities.append((grabPoint.global_transform.origin - prior_grab_point_position) / delta)

		grab_point_velocity += (grabPoint.global_transform.origin - prior_grab_point_position) / delta
		prior_grab_point_position = grabPoint.global_transform.origin

		if prior_grab_point_velocities.size() > 30:
			prior_grab_point_velocities.remove(0)

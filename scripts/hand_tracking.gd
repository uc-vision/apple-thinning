class_name OculusHandTracker
extends OculusTracker
# Extension of the OculusTracker class to support Oculus hands tracking.

var held_object = null
var held_object_data = {"mode":RigidBody.MODE_RIGID, "layer":1, "mask":1}
var grab_point_velocity = Vector3(0, 0, 0)
var prior_grab_point_velocities = []
var prior_grab_point_position = Vector3(0, 0, 0)
var gripping = false

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

var _t = 0.0

onready var hand_model : Spatial = $HandModel
onready var hand_pointer : Spatial = $HandModel/HandPointer
onready var grabPoint: Spatial = $GrabPoint
var defaultClickLocationColour = null

func _ready():
	_initialize_hands()

	ovr_hand_tracking = load("res://addons/godot_ovrmobile/OvrHandTracking.gdns");
	if (ovr_hand_tracking): ovr_hand_tracking = ovr_hand_tracking.new()

	ovr_utilities = load("res://addons/godot_ovrmobile/OvrUtilities.gdns")
	if (ovr_utilities): ovr_utilities = ovr_utilities.new()


func _process(delta_t):
	_update_hand_model(hand_model, hand_skel);
	_update_hand_pointer(hand_pointer)
	
	gripping = detect_gripping()
	if gripping and not held_object:
		grab_object()
	elif not gripping and held_object:
		drop_object()
	
	if held_object:
		get_node("../../OutputNode/Viewport/OtherLabel").text = held_object.get_name()
	else:
		get_node("../../OutputNode/Viewport/OtherLabel").text = "Not Holding anything"
	
	if gripping:
		get_node("../../OutputNode/Viewport/GripLabel").text = "Gripping"
	else:
		get_node("../../OutputNode/Viewport/GripLabel").text = "Not Gripping"
	
	# If we are on desktop or don't have hand tracking we set a debug pose on the left hand
	if (controller_id == LEFT_TRACKER_ID && !ovr_hand_tracking):
		for i in range(0, _hand_bone_mappings.size()):
			hand_skel.set_bone_pose(_hand_bone_mappings[i], Transform(_test_pose_left_ThumbsUp[i]));

	_t += delta_t;
	if (_t > 1.0):
		_t = 0.0;

		# here we print every second the state of the pinches
		print("%s Pinches: %.3f %.3f %.3f %.3f" %
			["Left" if controller_id == LEFT_TRACKER_ID else "Right",
			get_joystick_axis(FINGER_PINCH_STRENGTH_AXIS.INDEX),
			get_joystick_axis(FINGER_PINCH_STRENGTH_AXIS.MIDDLE),
			get_joystick_axis(FINGER_PINCH_STRENGTH_AXIS.RING),
			get_joystick_axis(FINGER_PINCH_STRENGTH_AXIS.PINKY)]);


func _initialize_hands():
	hand_skel = $HandModel/ArmatureLeft/Skeleton if controller_id == LEFT_TRACKER_ID else $HandModel/ArmatureRight/Skeleton

	_vrapi_bone_orientations.resize(24);
	_clear_bone_rest(hand_skel);


func _get_tracker_label():
	return "Oculus Tracked Left Hand" if controller_id == LEFT_TRACKER_ID else "Oculus Tracked Right Hand"


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


func _update_hand_pointer(model: Spatial):
	if (ovr_hand_tracking): # check if the hand tracking API was loaded
		if (ovr_hand_tracking.is_pointer_pose_valid(controller_id)):
			model.visible = true
			model.global_transform = ovr_hand_tracking.get_pointer_pose(controller_id)
		else:
			model.visible = false

func _on_LeftHand_pinch_pressed(button):
	if (button == FINGER_PINCH.INDEX_PINCH): 
		var clickLocation = $HandModel/HandPointer/RayCast/RayReticle
		var material = clickLocation.get_surface_material(0)
		defaultClickLocationColour = material.albedo_color
		material.albedo_color = Color(1, 0, 0)
		#does not work??
		clickLocation.set_surface_material(0, material)


func _on_RightHand_pinch_pressed(button):
	if (button == FINGER_PINCH.INDEX_PINCH): 
		var clickLocation = $HandModel/HandPointer/RayCast/RayReticle
		var material = clickLocation.get_surface_material(0)
		defaultClickLocationColour = material.albedo_color
		material.albedo_color = Color(1, 0, 0)
		#does not work??
		clickLocation.set_surface_material(0, material)


func _on_finger_pinch_release(button):
	if (button == FINGER_PINCH.INDEX_PINCH):
		var clickLocation = $HandModel/HandPointer/RayCast/RayReticle
		var material = clickLocation.get_surface_material(0)
		if defaultClickLocationColour:
			material.albedo_color = defaultClickLocationColour
		else:
			material.albedo_color = Color(1, 1, 1)
		#does not work??
		clickLocation.set_surface_material(0, material)











#GESTURE DETECTION
var tracking_confidence = 1.0;
const tracking_confidence_threshold = 1.0


enum ovrHandFingers {
	Thumb		= 0,
	Index		= 1,
	Middle		= 2,
	Ring		= 3,
	Pinky		= 4,
	Max,
	EnumSize = 0x7fffffff
};

enum ovrHandBone {
	Invalid						= -1,
	WristRoot 					= 0,	# root frame of the hand, where the wrist is located
	ForearmStub					= 1,	# frame for user's forearm
	Thumb0						= 2,	# thumb trapezium bone
	Thumb1						= 3,	# thumb metacarpal bone
	Thumb2						= 4,	# thumb proximal phalange bone
	Thumb3						= 5,	# thumb distal phalange bone
	Index1						= 6,	# index proximal phalange bone
	Index2						= 7,	# index intermediate phalange bone
	Index3						= 8,	# index distal phalange bone
	Middle1						= 9,	# middle proximal phalange bone
	Middle2						= 10,	# middle intermediate phalange bone
	Middle3						= 11,	# middle distal phalange bone
	Ring1						= 12,	# ring proximal phalange bone
	Ring2						= 13,	# ring intermediate phalange bone
	Ring3						= 14,	# ring distal phalange bone
	Pinky0						= 15,	# pinky metacarpal bone
	Pinky1						= 16,	# pinky proximal phalange bone
	Pinky2						= 17,	# pinky intermediate phalange bone
	Pinky3						= 18,	# pinky distal phalange bone
	MaxSkinnable				= 19,

	# Bone tips are position only. They are not used for skinning but useful for hit-testing.
	# NOTE: ThumbTip == MaxSkinnable since the extended tips need to be contiguous
	ThumbTip					= 19 + 0,	# tip of the thumb
	IndexTip					= 19 + 1,	# tip of the index finger
	MiddleTip					= 19 + 2,	# tip of the middle finger
	RingTip						= 19 + 3,	# tip of the ring finger
	PinkyTip					= 19 + 4,	# tip of the pinky
	Max 						= 19 + 5,
	EnumSize 					= 0x7fff
};

const _ovrHandFingers_Bone1Start = [ovrHandBone.Thumb1, ovrHandBone.Index1, ovrHandBone.Middle1, ovrHandBone.Ring1,ovrHandBone.Pinky1];


# we need to remap the bone ids from the hand model to the bone orientations we get from the vrapi and the inverse
# This is only for the actual bones and skips the tips (vrapi 19-23) as they do not need to be updated I think
const _vrapi2hand_bone_map = [0, 23,  1, 2, 3, 4,  6, 7, 8,  10, 11, 12,  14, 15, 16, 18, 19, 20, 21];
# inverse mapping to get from the godot hand bone ids to the vrapi bone ids
const _hand2vrapi_bone_map = [0, 2, 3, 4, 5,19, 6, 7, 8, 20,  9, 10, 11, 21, 12, 13, 14, 22, 15, 16, 17, 18, 23, 1];

# we need the inverse neutral pose to compute the estimates for gesture detection
var _vrapi_inverse_neutral_pose = []; # this is filled when clearing the rest pose



func _get_bone_angle_diff(ovrHandBone_id):
	var quat_diff = _vrapi_bone_orientations[ovrHandBone_id] * _vrapi_inverse_neutral_pose[ovrHandBone_id];
	var a = acos(clamp(quat_diff.w, -1.0, 1.0));
	return rad2deg(a);

func get_finger_angle_estimate(finger):
	var angle = 0.0;
	angle += _get_bone_angle_diff(_ovrHandFingers_Bone1Start[finger]+0);
	angle += _get_bone_angle_diff(_ovrHandFingers_Bone1Start[finger]+1);
	angle += _get_bone_angle_diff(_ovrHandFingers_Bone1Start[finger]+2);
	return angle;

onready var last_detected_gripping = false

func detect_gripping():
	if (tracking_confidence <= 0.5): return last_detected_gripping;
	
	for i in range(0, 5):
		var finger_angle = get_finger_angle_estimate(i)
		if finger_angle > 70:
			last_detected_gripping = true
			return true
	last_detected_gripping = false
	return false


func get_closest_rigidbody(palm_area, bodies):
	var closest_body: RigidBody = null
	var closest_distance = null
	for body in bodies:
		var curr_distance = palm_area.global_transform.origin.distance_to(body.global_transform.origin)
		# closest_body == null is first case
		if body is RigidBody and (closest_body == null or curr_distance < closest_distance):
			closest_body = body
			closest_distance = curr_distance
	return closest_body
	
func grab_object():
	if !held_object:
		var palm_area = hand_skel.get_node("Palm/Grab_Range")
		var bodies = palm_area.get_overlapping_bodies()
		var rigid_body = get_closest_rigidbody(palm_area, bodies)
		if rigid_body:
			
			if 'Apple' in rigid_body.get_groups() and rigid_body.is_interactable():
				held_object = rigid_body
				held_object_data["mode"] = held_object.mode
				held_object_data["layer"] = held_object.collision_layer
				held_object_data["mask"] = held_object.collision_mask
				held_object.mode = RigidBody.MODE_STATIC
				held_object.collision_layer = 0
				held_object.collision_mask = 0
				held_object.picked_up()
				
			if rigid_body.has_method("interact"):
				rigid_body.interact()
			
	else:
		held_object.mode = held_object_data["mode"]
		held_object.collision_layer = held_object_data["layer"]
		held_object.collision_mask = held_object_data["mask"]
		held_object = null
	
func drop_object():
	held_object.mode = RigidBody.MODE_RIGID
	held_object.collision_layer = held_object_data["layer"]
	held_object.collision_mask = held_object_data["mask"]
	held_object.apply_impulse(Vector3(0, 0, 0), grab_point_velocity)
	held_object = null
	
	#get_node("../../OutputNode/Viewport/OtherLabel").text = ""

func _physics_process(delta):
	if held_object:
		var palm_global_transform = grabPoint.global_transform
		held_object.global_transform = grabPoint.global_transform
		#held_object.global_transform = grabPoint.global_transform #WHY DOES THIS NOT WORK???!?!?!??!?!?!?!?!?!?
		#held_object.transform.basis = transform.basis.rotated(Vector3(50.5, 0, 0), PI)
			
		
		
		# Get grab point velocity. Useful when wanting to throw objects
		grab_point_velocity = Vector3(0, 0, 0)
		if prior_grab_point_velocities.size() > 0:
			for vel in prior_grab_point_velocities:
				grab_point_velocity += vel

			# Get the average velocity, instead of just adding them together.
			grab_point_velocity = grab_point_velocity / prior_grab_point_velocities.size()

		prior_grab_point_velocities.append((palm_global_transform.origin - prior_grab_point_position) / delta)

		grab_point_velocity += (palm_global_transform.origin - prior_grab_point_position) / delta
		prior_grab_point_position = palm_global_transform.origin

		if prior_grab_point_velocities.size() > 30:
			prior_grab_point_velocities.remove(0)

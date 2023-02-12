extends Node

#This interaction mechanic uses areas on the users fingers to detect when 
#fingers are inside of grabable objects and then the detect_grabbing_object 
#function returns the gripping object if the users thumb and at least one other 
#finger are inside of the object.

var enteredBodies = {}

func _on_body_entered_finger_area(body, fingerName):
	
	if not body in enteredBodies:
		enteredBodies[body] = [fingerName]
	else:
		enteredBodies[body].append(fingerName)


func _on_body_exited_finger_area(body, fingerName):
	
	enteredBodies[body].erase(fingerName)
	
	if enteredBodies[body].empty():
		enteredBodies.erase(body)

func detect_grabbing_object():
	var objects = enteredBodies.keys()
	var num_fingers = 0
	var grabbingObject = null
	
	for object in enteredBodies:
		var fingers = enteredBodies[object]
		if "ThumbTip" in fingers and num_fingers < len(fingers) and len(fingers) >= 2:
			num_fingers = len(fingers)
			grabbingObject = object
			if num_fingers >= 3: break
	
	return grabbingObject

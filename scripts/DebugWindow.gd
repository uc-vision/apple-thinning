extends Spatial

var buffer = [".", ".", "Welcome to debugger"]

# Called when the node enters the scene tree for the first time.
func _ready():
	print_to_debug()
	pass

#print a message to debug by itself
func output(message):
	$Viewport/Label.set_text(str(message))

#add new log to bugger and prints latest 3 logs
func new_debug_log(string):
	buffer.append(str(string))
	print_to_debug()

#prints latest 3 logs
func print_to_debug():
	var logs = ""
	var start_pos = buffer.size()
	var end_pos = buffer.size() - 3
	var things = buffer.slice(start_pos, end_pos, -1)
	for i in things:
		logs += str(i) + "\n\n"
	$Viewport/Label.set_text(logs)

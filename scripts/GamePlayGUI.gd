extends MeshInstance

#onready var score_label = $GUI/Viewport/MarginContainer/VBoxContainer/TopRow/ScoreContainer/Score


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func update_remaining_time(remaining_time_text):
	$Viewport/MarginContainer/VBoxContainer/BottomRow/RemainingTimeContainer/RemainingTime.set_text(remaining_time_text)

func update_score_label(score_text):
	$Viewport/MarginContainer/VBoxContainer/TopRow/ScoreContainer/Score.set_text(score_text)

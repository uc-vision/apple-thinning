extends Spatial

onready var score_value_label = $ScoreSection/Viewport2/ScoreValue
onready var picked_number_value_label = $PickedNumberLabel/Viewport2/PickedNumberValue
onready var max_combo_value_label = $MaxComboSection/Viewport2/MaxComboValue
onready var grade_label = $GradeSection/Viewport/GradeValue

func set_score_text(score_text: String):
	score_value_label.set_text(score_text)
	
func set_picked_number_value_text(num_picked_text: String):
	picked_number_value_label.set_text(num_picked_text)
	
func set_max_combo_text(max_combo: String):
	max_combo_value_label.set_text(max_combo)
	
func set_grade_text(grade_text: String):
	grade_label.set_text(grade_text)

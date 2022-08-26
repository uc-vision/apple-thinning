extends Spatial

onready var score_value_label = $ScoreSection/Viewport2/ScoreValue
onready var picked_number_value_label = $PickedNumberSection/Viewport2/PickedNumberValue
onready var max_combo_value_label = $MaxComboSection/Viewport2/MaxComboValue
onready var grade_label = $GradeSection/Viewport/GradeValue
onready var high_score_label = $ScoreSection/HighScoreLabel
onready var full_combo_label = $MaxComboSection/FullComboLabel

func set_score_text(score_text: String):
	score_value_label.set_text(score_text)

func set_picked_number_value_text(num_picked_text: String):
	picked_number_value_label.set_text(num_picked_text)

func set_max_combo_text(max_combo: String):
	max_combo_value_label.set_text(max_combo)

func set_grade(grade):
	if grade == 0:
		grade_label.set_text("D")
	elif grade == 1:
		grade_label.set_text("C")
	elif grade == 2:
		grade_label.set_text("B")
	elif grade == 3:
		grade_label.set_text("A")
	elif grade == 4:
		grade_label.set_text("S")
	else:
		grade_label.set_text("N")

# Show the high score label if the score is the high score
func set_high_score_label_visibility(is_visible):
	high_score_label.set_visible(is_visible)
	
# Show full combo label if it is full combo
func set_full_combo_label_visibilitu(is_visible):
	full_combo_label.set_visible(is_visible)

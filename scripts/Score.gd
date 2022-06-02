extends Spatial

onready var score_label = $Viewport/Control/Score
onready var total_score_text
onready var total_score = 0
			

func update_score(old_score, current_score):
	total_score += current_score - old_score
	
	score_label.text = str(total_score)

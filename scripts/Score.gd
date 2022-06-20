extends Spatial

onready var score_label = $Viewport/Control/Score
onready var total_score_text
onready var total_score = 0
			
# Updates the score by subtracting the old score and adding the current score. 
# Called from AppleCluster.gd
func update_score(old_score, current_score):
	total_score += current_score - old_score
	
	score_label.text = str(total_score)
	
# Resets the score game when loading a level again
# Called from GameReset.gd
func reset_score():
	total_score = 0
	score_label.text = str(total_score)

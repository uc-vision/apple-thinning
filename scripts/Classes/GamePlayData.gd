extends Reference

class_name GamePlayData

enum Grade {
	D, C, B, A, S, NA = -1
}

# Properties
var score: int = 0 setget set_score, get_score
var highest_score: int = 0 setget set_highest_score, get_highest_score
var is_new_record: bool = false setget , get_is_new_record
var num_picked: int = 0 setget set_num_picked, get_num_picked
var max_combo: int = 0 setget set_max_combo, get_max_combo
var grade = Grade.NA setget , get_grade

func set_score(game_play_score: int):
	score = game_play_score

func get_score():
	return score
	
func set_highest_score(current_high_score: int):
	highest_score = current_high_score
	
func get_highest_score():
	return highest_score
	
func get_is_new_record():
	if get_highest_score() < get_score():
		is_new_record = true
	else:
		is_new_record = false
	return is_new_record
	
func set_num_picked(num_apple_picked: int):
	num_picked = num_apple_picked
	
func get_num_picked():
	return num_picked
	
func set_max_combo(new_max_combo: int):
	max_combo = new_max_combo
	
func get_max_combo():
	return max_combo
	
func get_grade():
	var sub_grades = []
	
	var game_score = get_score()
	if game_score < 1000:
		sub_grades.append(Grade.D)
	elif game_score in range(1000, 1500):
		sub_grades.append(Grade.C)
	elif game_score in range(1500, 2000):
		sub_grades.append(Grade.B)
	elif game_score in range(2000, 2500):
		sub_grades.append(Grade.A)
	else:
		sub_grades.append(Grade.S)
		
	var apple_picked = get_num_picked()
	if num_picked < 10:
		sub_grades.append(Grade.D)
	elif num_picked in range(10, 20):
		sub_grades.append(Grade.C)
	elif num_picked in range(20, 30):
		sub_grades.append(Grade.B)
	elif num_picked in range(30, 40):
		sub_grades.append(Grade.A)
	else:
		sub_grades.append(Grade.S)
		
	var game_max_combo = get_max_combo()
	if game_max_combo < 10:
		sub_grades.append(Grade.D)
	elif game_max_combo in range(10, 20):
		sub_grades.append(Grade.C)
	elif game_max_combo in range(20, 30):
		sub_grades.append(Grade.B)
	elif game_max_combo in range(30, 40):
		sub_grades.append(Grade.A)
	else:
		sub_grades.append(Grade.S)
		
	var grade_point = 0
	for sub_grade in sub_grades:
		grade_point += sub_grade
	
	var grade_point_average = float(grade_point) / len(sub_grades)
	if grade_point_average < 1:
		grade = Grade.D
	elif grade_point_average in range(1, 2):
		grade = Grade.C
	elif grade_point_average in range(2, 3):
		grade = Grade.B
	elif grade_point_average in range(3, 4):
		grade = Grade.A
	else:
		grade = Grade.S
		
	return grade

extends Reference

class_name TrainingGameData

enum Grade {
	D, C, B, A, S, NA = -1
}

# Properties
var num_successful_clusters: int = 0 setget set_num_successful_clusters, get_num_successful_clusters
var num_overthinned_clusters: int = 0 setget set_num_overthinned_clusters, get_num_overthinned_clusters
var num_underthinned_clusters: int = 0 setget set_num_underthinned_clusters, get_num_underthinned_clusters
var num_missed_clusters: int = 0 setget set_num_missed_clusters, get_num_missed_clusters
var num_left_damaged: int = 0 setget set_num_left_damaged, get_num_left_damaged
var num_left_large: int = 0 setget set_num_left_large, get_num_left_large
var num_left_small: int = 0 setget set_num_left_small, get_num_left_small
var num_sunshine_apple: int = 0 setget set_num_sunshine_apple, get_num_sunshine_apple

func set_num_successful_clusters(num_clusters):
	num_successful_clusters = num_clusters
	
func get_num_successful_clusters():
	return num_successful_clusters
	
func set_num_overthinned_clusters(num_clusters):
	num_overthinned_clusters = num_clusters
	
func get_num_overthinned_clusters():
	return num_overthinned_clusters
	
func set_num_underthinned_clusters(num_clusters):
	num_underthinned_clusters = num_clusters
	
func get_num_underthinned_clusters():
	return num_underthinned_clusters
	
func set_num_missed_clusters(num_clusters):
	num_missed_clusters = num_clusters
	
func get_num_missed_clusters():
	return num_missed_clusters
	
func set_num_left_damaged(num_fruitlet):
	num_left_damaged = num_fruitlet
	
func get_num_left_damaged():
	return num_left_damaged
	
func set_num_left_large(num_fruitlet):
	num_left_large = num_fruitlet
	
func get_num_left_large():
	return num_left_large
	
func set_num_left_small(num_fruitlet):
	num_left_small = num_fruitlet
	
func get_num_left_small():
	return num_left_small
	
func set_num_sunshine_apple(num_fruitlet):
	num_sunshine_apple = num_fruitlet
	
func get_num_sunshine_apple():
	return num_sunshine_apple

extends Spatial

# References to the stats value labels
onready var successful_clusters_label = $SuccessfulClustersSection/Viewport2/Value
onready var overthinned_clusters_label = $OverthinnedClustersSection/Viewport2/Value
onready var underthinned_clusters_label = $UnderthinnedClustersSection/Viewport2/Value
onready var missed_clusters_label = $MissedClustersSection/Viewport2/Value
onready var damaged_fruitlets_label = $DamagedFruitletsSection/Viewport2/Value
onready var large_fruitlets_label = $LargeFruitletsSection/Viewport2/Value
onready var small_fruitlets_label = $SmallFruitletsSection/Viewport2/Value
onready var sun_exposure_fruitlets_label = $SunExposureFruitletsSection/Viewport2/Value

func set_successful_clusters_label(value: String):
	successful_clusters_label.set_text(value)


func set_overthinned_clusters_label(value: String):
	overthinned_clusters_label.set_text(value)


func set_underthinned_clusters_label(value: String):
	underthinned_clusters_label.set_text(value)


func set_missed_clusters_label(value: String):
	missed_clusters_label.set_text(value)


func set_damaged_fruitlets_label(value: String):
	damaged_fruitlets_label.set_text(value)


func set_large_fruitlets_label(value: String):
	large_fruitlets_label.set_text(value)


func set_small_fruitlets_label(value: String):
	small_fruitlets_label.set_text(value)


func set_sun_exposure_fruitlets_label(value: String):
	sun_exposure_fruitlets_label.set_text(value)

# Called GamePlayScene_TrainingGame.gd
# Recieved evaluation stats object TrainingGameData
func show_data(data):
	set_successful_clusters_label(str(data.get_num_successful_clusters()))
	set_overthinned_clusters_label(str(data.get_num_overthinned_clusters()))
	set_underthinned_clusters_label(str(data.get_num_underthinned_clusters()))
	set_missed_clusters_label(str(data.get_num_missed_clusters()))
	set_damaged_fruitlets_label(str(data.get_num_left_damaged()))
	set_large_fruitlets_label(str(data.get_num_left_large()))
	set_small_fruitlets_label(str(data.get_num_left_small()))
	set_sun_exposure_fruitlets_label(str(data.get_num_sunshine_apple()))
	
	set_visible(true)

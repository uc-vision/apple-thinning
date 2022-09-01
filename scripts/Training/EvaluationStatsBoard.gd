extends Spatial

# References to the stats value labels
onready var successful_clusters_label = $SuccessfulClustersSection/Sprite3D2
onready var overthinned_clusters_label = $OverthinnedClustersSection/Sprite3D2
onready var underthinned_clusters_label = $UnderthinnedClustersSection/Sprite3D2
onready var missed_clusters_label = $MissedClustersSection/Sprite3D2
onready var damaged_fruitlets_label = $DamagedFruitletsSection/Sprite3D2
onready var large_fruitlets_label = $LargeFruitletsSection/Sprite3D2
onready var small_fruitlets_label = $SmallFruitletsSection/Sprite3D2
onready var sun_exposure_fruitlets_label = $SunExposureFruitletsSection/Sprite3D2

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


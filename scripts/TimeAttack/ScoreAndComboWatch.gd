extends MeshInstance

func update_score_label(score_text):
	$ScoreSection/Viewport/Score.set_text(score_text)

func update_combo_label(combo_text):
	$ComboSection/Viewport/Combo.set_text(combo_text)

func reset_label():
	$ScoreSection/Viewport/Score.set_text("0")
	$ComboSection/Viewport/Combo.set_text("0")

extends Control

var combo_count: int = 0

func _ready():
	Signals.IncrementScore.connect(IncrementScore)
	Signals.IncrementCombo.connect(IncrementCombo)
	Signals.ResetCombo.connect(ResetCombo)
	
	ResetCombo()
	
func IncrementScore(incr: int):
	Signals.score += incr
	%ScoreLabel.text = str(Signals.score) + " pts "

func IncrementCombo():
	combo_count += 1
	%ComboCountLabel.text = str(combo_count) + "x combo "

func ResetCombo():
	combo_count = 0
	%ComboCountLabel.text = str(combo_count) + "x combo "

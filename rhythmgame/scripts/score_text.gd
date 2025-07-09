extends Control

# perfekt ffbf00
# great 9c009c
# good 3498DB
# ok 27AE60
# miss 808B96

func set_text_info(text: String):
	$ScoreTextLabel.text = "[center]" + text
	
	match text:
		"PERFECT":
			$ScoreTextLabel.set("theme_override_colors/default_color", Color("ffbf00"))
		"GREAT":
			$ScoreTextLabel.set("theme_override_colors/default_color", Color("9c009c"))
		"GOOD":
			$ScoreTextLabel.set("theme_override_colors/default_color", Color("3498db"))
		"OK":
			$ScoreTextLabel.set("theme_override_colors/default_color", Color("27ae60"))
		_:
			$ScoreTextLabel.set("theme_override_colors/default_color", Color("808b96"))

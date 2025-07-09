extends Node2D


func _ready() -> void:
	$FinalScoreLabel.text = str("Your Score: \n", Signals.score)


func _on_replay_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_selection_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/start_screen.tscn")

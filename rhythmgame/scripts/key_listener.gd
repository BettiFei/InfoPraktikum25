extends Sprite2D

@onready var falling_key = preload("res://scenes/falling_key.tscn")
@export var key_name: String = ""

func _process(_delta):
	if Input.is_action_just_pressed(key_name):
		create_falling_key()

func create_falling_key():
	var fk_inst = falling_key.instantiate()
	get_tree().get_root().add_child(fk_inst)
	fk_inst.setup(position.x, frame + 4)

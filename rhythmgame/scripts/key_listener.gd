extends Sprite2D

@onready var falling_key = preload("res://scenes/falling_key.tscn")
@onready var score_text = preload("res://scenes/score_text.tscn")
@export var key_name: String = ""

var falling_key_queue = []

# scoring thresholds (if distance_from_pass < threshold, give score):
@export var perfect_threshold: float = 25
@export var great_threshold: float = 40
@export var good_threshold: float = 50
@export var ok_threshold: float = 70
# if distance_from_pass > ok_threshold: miss)

# scores:
@export var perfect_score = 250
@export var great_score = 100
@export var good_score = 50
@export var ok_score = 20

func _ready():
	$GlowOverlay.frame = frame + 4
	Signals.CreateFallingKey.connect(create_falling_key)

func _process(_delta):
	if Input.is_action_just_pressed(key_name):
		Signals.KeyListenerPress.emit(key_name, frame)
	
	# check that there is a FK
	if falling_key_queue.size() > 0:
		
		print("falling_key_queue.size(): ", falling_key_queue.size())
		print("has_passed: ", falling_key_queue.front().has_passed)
		
		# if FK has passed screen, remove from queue:
		if falling_key_queue.front().has_passed:
			falling_key_queue.pop_front()
			
			# set MISS when player does not press any input:
			var st_inst = score_text.instantiate()
			get_tree().get_root().add_child(st_inst)
			st_inst.set_text_info("MISS")
			st_inst.global_position = global_position + Vector2(-50,0)
			Signals.ResetCombo.emit()
	
		# if input is pressed, remove FK from queue and calculate distance from target area
		if Input.is_action_just_pressed(key_name):			
			# get first FK of FK queue:
			var key_to_pop = falling_key_queue.pop_front()
			
			print("key_to_pop: ", key_to_pop)
			
			if !key_to_pop:
				return
			
			# get distance of FK from target area (KL):
			var distance_from_pass = abs(key_to_pop.pass_threshold - key_to_pop.global_position.y)
			
			$AnimationPlayer.stop()
			$AnimationPlayer.play("key_hit")
			
			var score_text_label: String = ""
			if distance_from_pass < perfect_threshold:
				Signals.IncrementScore.emit(perfect_score)
				score_text_label = "PERFECT"
				Signals.IncrementCombo.emit()
			elif distance_from_pass < great_threshold:
				Signals.IncrementScore.emit(great_score)
				score_text_label = "GREAT"
				Signals.IncrementCombo.emit()
			elif distance_from_pass < good_threshold:
				Signals.IncrementScore.emit(good_score)
				score_text_label = "GOOD"
				Signals.IncrementCombo.emit()
			elif distance_from_pass < ok_threshold:
				Signals.IncrementScore.emit(ok_score)
				score_text_label = "OK"
				Signals.IncrementCombo.emit()
			else:
				score_text_label = "MISS"
				Signals.ResetCombo.emit()
				
			key_to_pop.queue_free()
			
			var st_inst = score_text.instantiate()
			get_tree().get_root().add_child(st_inst)
			st_inst.set_text_info(score_text_label)
			st_inst.global_position = global_position + Vector2(-50,0)

func create_falling_key(button_name: String):
	if button_name == key_name:
		var fk_inst = falling_key.instantiate()
		get_tree().get_root().add_child(fk_inst)
		fk_inst.setup(position.x, frame + 4)
		
		falling_key_queue.push_back(fk_inst)


func _on_random_spawn_timer_timeout() -> void:
	#create_falling_key()
	$RandomSpawnTimer.wait_time = randf_range(0.4,3)
	$RandomSpawnTimer.start()

extends Sprite2D

@onready var falling_key = preload("res://scenes/falling_key.tscn")
@onready var score_text = preload("res://scenes/score_text.tscn")
@export var key_name: String = ""

var falling_key_queue = []

# scoring thresholds (if distance_from_pass < threshold, give score):
@export var perfect_threshold: float = 30
@export var great_threshold: float = 45
@export var good_threshold: float = 60
@export var ok_threshold: float = 80
# if distance_from_pass > ok_threshold: miss)

# scores:
@export var perfect_score = 250
@export var great_score = 100
@export var good_score = 50
@export var ok_score = 20

func _process(_delta):
	# check that there is a FK
	if falling_key_queue.size() > 0:
		
		# if FK has passed screen, remove from queue:
		if falling_key_queue.front().has_passed:
			falling_key_queue.pop_front()
			#print("popped")
	
		# if input is pressed, remove FK from queue and calculate distance from target area
		if Input.is_action_just_pressed(key_name):
			# get first FK of FK queue:
			var key_to_pop = falling_key_queue.pop_front()
			
			# get distance of FK from target area (KL):
			var distance_from_pass = abs(key_to_pop.pass_threshold - key_to_pop.global_position.y)
			#print(distance_from_pass)
			
			if distance_from_pass < perfect_threshold:
				Signals.IncrementScore.emit(perfect_score)
			elif distance_from_pass < great_threshold:
				Signals.IncrementScore.emit(great_score)
			elif distance_from_pass < good_threshold:
				Signals.IncrementScore.emit(good_score)
			elif distance_from_pass < ok_threshold:
				Signals.IncrementScore.emit(ok_score)
			else:
				#MISS
				pass
				
			key_to_pop.queue_free()
			
			var st_inst = score_text.instantiate()
			get_tree().get_root().add_child(st_inst)
			st_inst.global_position.y = global_position.y
			st_inst.global_position.x = global_position.x - 50

func create_falling_key():
	var fk_inst = falling_key.instantiate()
	get_tree().get_root().add_child(fk_inst)
	fk_inst.setup(position.x, frame + 4)
	
	falling_key_queue.push_back(fk_inst)


func _on_random_spawn_timer_timeout() -> void:
	create_falling_key()
	$RandomSpawnTimer.wait_time = randf_range(0.4,3)
	$RandomSpawnTimer.start()

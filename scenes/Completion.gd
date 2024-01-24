extends Label
var rng = RandomNumberGenerator.new()
@export var current_completion = 0
@export var penalty_for_miss = 10
@export var reward_for_hit = 5
var li = preload("res://assets/sounds/sound effects/Li.mp3")
var la = preload("res://assets/sounds/sound effects/La.mp3")
func miss():
	if current_completion>=penalty_for_miss:
		current_completion-=10
	else:
		current_completion = 0
	if has_node("../audio") and get_node("../audio").is_inside_tree():
		$"../audio".play()

func hit(button_type = ""):
	current_completion+=reward_for_hit
	if has_node("../audio_good_hit"):
		if button_type == "↑":
			$"../audio_good_hit".pitch_scale = 1.35
		elif button_type == "←":
			$"../audio_good_hit".pitch_scale = 1.25
		elif button_type == "→":
			$"../audio_good_hit".pitch_scale = 1.15
		else:
			$"../audio_good_hit".pitch_scale = 1.05
		if rng.randi_range(0,1):
			$"../audio_good_hit".stream = la
		else:
			$"../audio_good_hit".stream = li
			
		$"../audio_good_hit".play()


func _process(_delta):
	text = str(current_completion)+" %"
		
	if current_completion >=100:
		get_tree().paused = false
		$"..".queue_free()

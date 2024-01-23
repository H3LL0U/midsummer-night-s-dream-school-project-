extends Label

@export var current_completion = 0
@export var penalty_for_miss = 10
@export var reward_for_hit = 5
func miss():
	if current_completion>=penalty_for_miss:
		current_completion-=10
	else:
		current_completion = 0
	if has_node("../audio"):
		$"../audio".play()

func hit():
	current_completion+=reward_for_hit
	if has_node("../audio_good_hit"):
		$"../audio_good_hit".play()


func _process(delta):
	text = str(current_completion)+" %"
		
	if current_completion >=100:
		get_tree().paused = false
		$"..".queue_free()

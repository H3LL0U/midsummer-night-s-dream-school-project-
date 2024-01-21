extends Node2D



@export var timeline_max_scale = 688.5
@export var default_time = 60.0

@onready var time =default_time
@export var timer_active = true
const wrong_sfx = preload("res://assets/sounds/sound effects/wrong.mp3")
#@export var action = func():
	
	#var button_to_cancel = $"..".current_button
	#print("???")
	#$"..".get_node("quick_time_event1").my_turn = true
	#$"..".get_node("quick_time_event"+str(button_to_cancel)).my_turn = false
	#$"../Connection_line".points = []
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$timeline_complete.scale.x = timeline_max_scale*time/default_time
	#$Label.text = str(int($/root/gameplay.completion*100))+"%"
	if timer_active:
		time-=delta
	if time<0:
		
		var button_to_cancel = $"..".current_button
		
		$"..".get_node("quick_time_event1").my_turn = true
		$"..".get_node("quick_time_event"+str(button_to_cancel)).my_turn = false
		$"..".get_node("quick_time_event"+str(button_to_cancel)).visible = false
		$"../Connection_line".points = []
		time = default_time
		$"../../speechspeaker/soundspeaker".stream = wrong_sfx
		$"../../speechspeaker/soundspeaker".play()

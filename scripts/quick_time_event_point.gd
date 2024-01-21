extends AnimatedSprite2D


@export var quick_event_button = "w" 
@export var my_turn = false
var bold_font = preload("res://assets/fonts/calibri-bold.ttf")
var end_minigame = false
var destruction_timer = 2.5

const wrong_sfx = preload("res://assets/sounds/sound effects/wrong.mp3")
func change_state():
	
		play("press")
		match (quick_event_button):
			"Enter":
				$Label.text = '⏎'
				$Label.add_theme_font_size_override("font_size", 500)
				
			"Space":
				$Label.text = '⎵'
			_:
				$Label.text = quick_event_button.capitalize()
				
			
		visible = true

	
func _ready():
	scale*=1.5
	visible = false
	if my_turn:
		change_state()

		

func _process(delta):
	if my_turn:
		change_state()
	if destruction_timer<=0:
		$"..".queue_free()
		get_tree().paused = false
	if end_minigame:
		destruction_timer-=delta
		
		$"../full".modulate = Color(1,1,1,(1-(destruction_timer/2.5)))
		
	
func _unhandled_input(event:InputEvent):
	if event is InputEventKey:
		
			
		if event.pressed and !event.is_echo() and my_turn:
			
			if  event.as_text()==quick_event_button.capitalize() and my_turn and event.pressed and !event.is_echo():
				
				var next_number_index = int(str(name).substr(name.rfind("t")+1))+1
				my_turn = false
				
				if $"..".has_node("quick_time_event"+str(next_number_index)):
					$"..".get_node("quick_time_event"+str(next_number_index)).my_turn = true
					$"..".current_button = next_number_index
					$"../Connection_line".add_point(Vector2(position.x,position.y))
					
					
					
					
				else:
					$"../Connection_line".add_point(Vector2(position.x,position.y))
					end_minigame = true
					
				visible = false
			else :
				$"../../speechspeaker/soundspeaker".stream = wrong_sfx
				$"../../speechspeaker/soundspeaker".play()
				$"../Connection_line".points = []
				my_turn = false
				$"..".get_node("quick_time_event1").my_turn = true
				$"../Connection_line".add_point(Vector2(position.x,position.y))
				visible = false
			
		



func _on_frame_changed():
	

	if frame:
		$Label.position.y-=4
		$Label.position.x-=12
	else:
		$Label.position.x+=12
		$Label.position.y+=4



extends AnimatedSprite2D


@export var quick_event_button = "w" 
@export var my_turn = false
var bold_font = preload("res://assets/fonts/calibri-bold.ttf")
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
	visible = false
	if my_turn:
		change_state()
	

func _process(delta):
	if my_turn:
		change_state()
	
func _input(event:InputEvent):
	
	if event is InputEventKey and event.as_text()==quick_event_button.capitalize() and my_turn and event.pressed and !event.is_echo():
		
		var next_number_index = int(str(name).substr(name.rfind("t")+1))+1
		my_turn = false
		
		if $"..".has_node("quick_time_event"+str(next_number_index)):
			$"..".get_node("quick_time_event"+str(next_number_index)).my_turn = true
			$"../Connection_line".add_point(Vector2(position.x,position.y))
			
			
			
			
		else:
			
			get_tree().quit()
		queue_free()

		
			
		



func _on_frame_changed():
	

	if frame:
		$Label.position.y-=4
		$Label.position.x-=12
	else:
		$Label.position.x+=12
		$Label.position.y+=4



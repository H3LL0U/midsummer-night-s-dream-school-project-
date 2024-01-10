extends ParallaxBackground
@export var speed: int
@export var delay: float
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if delay>0:
		delay-=delta
	else:
		scroll_offset.y-=speed*delta
	
	if scroll_offset.y<-6700:
		get_tree().change_scene_to_file("res://.godot/exported/133200997/export-ce437267b8bb1179a3485e665475480c-main menu.scn")
	if scroll_offset.y>0:
		scroll_offset.y = 0

	
func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				scroll_offset.y +=speed
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				scroll_offset.y -=speed
	elif event is InputEventKey:
		get_tree().change_scene_to_file("res://.godot/exported/133200997/export-ce437267b8bb1179a3485e665475480c-main menu.scn")
				
				


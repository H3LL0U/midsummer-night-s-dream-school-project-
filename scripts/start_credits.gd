extends Node2D

var time_to_wait = 5
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if time_to_wait<=0:
		get_tree().change_scene_to_file("res://scenes/main menu.tscn")
	time_to_wait-=delta
func _input(event: InputEvent):
	
	if event is InputEventKey:
		if event.pressed:
			get_tree().change_scene_to_file("res://scenes/main menu.tscn")

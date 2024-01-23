extends Node2D



@export var speed = 1500.0



func _process(delta):
	
	position.x-=speed*delta
	if position.x <-5000:
		
		queue_free()
	

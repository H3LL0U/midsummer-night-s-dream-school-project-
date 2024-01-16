extends Node2D

@export var timeline_max_scale = 688.5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$timeline_complete.scale.x = timeline_max_scale* $/root/gameplay.completion
	$Label.text = str(int($/root/gameplay.completion*100))+"%"

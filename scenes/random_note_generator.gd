extends Node

var rng = RandomNumberGenerator.new()
var random_timer = rng.randf_range(3.0, 10.0)



func _process(delta):
	random_timer-=delta
	if random_timer<=0:
		$"..".spawn_note()
		random_timer = rng.randf_range(3.0, 10.0)

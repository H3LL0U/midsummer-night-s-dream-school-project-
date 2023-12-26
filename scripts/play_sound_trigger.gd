extends Area2D

var sound_effect = preload("res://assets/sounds/sound effects/thump_sound_effect.mp3")
# Called when the node enters the scene tree for the first time.

func _on_body_entered(body):
	if body.is_in_group("_"):
		$"../Label_logo/sound_effects".stream = sound_effect
		$"../Label_logo/sound_effects".play()

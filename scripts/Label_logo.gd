extends Label

var time_between_characters_default = 0.09
var time_between_characters = time_between_characters_default
var text_to_add = 'H3LL  0U\nstudios'


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if time_between_characters<=0 and text_to_add!="":
		$".".text +=text_to_add[0]
		text_to_add = text_to_add.substr(1)
		time_between_characters = time_between_characters_default
		$sound_effects.play()
	else:
		
		time_between_characters-=delta
	
		

		
		

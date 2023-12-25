extends HSlider

var sound_node
# Called when the node enters the scene tree for the first time.
func _ready():
	
	if self.name == "Music sound":
		sound_node = get_node("../../songspeaker")
	elif self.name == "General sounds":
		sound_node = get_node("../../speechspeaker")
	if sound_node:
		self.value = sound_node.volume_db+80


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if sound_node:
		sound_node.volume_db = self.value-80
		if self.value == 0:
			sound_node.volume_db =-999999

extends HSlider

var sound_node

func _ready():
	
	if self.name == "Music sound":
		sound_node = get_node("../../songspeaker")
	elif self.name == "General sounds":
		sound_node = get_node("../../speechspeaker")
	if sound_node:
		self.value = sound_node.volume_db+80



func _process(_delta):
	
	if sound_node:
		sound_node.volume_db = self.value-80
		if self.value == 0:
			sound_node.volume_db =-999999

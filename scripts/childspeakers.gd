extends AudioStreamPlayer
@export var sound_volume_offset = 0
@export var inherit_from = ".."
# Called when the node enters the scene tree for the first time.
func _ready():
	inherit_from = get_node(inherit_from)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	volume_db = inherit_from.volume_db+sound_volume_offset
#../../speechspeaker
  

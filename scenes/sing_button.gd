extends TextureButton



@export var shortcut_button = "a"
const note = preload("res://scenes/note.tscn")

var entred_notes = []
func spawn_note():
	var note_to_add = note.instantiate()
	note_to_add.position.x = $Note_spawner.position.x
	
	add_child(note_to_add)

func _ready():
	
	$Label.text = shortcut_button
	


	
			
			
func _on_area_2d_area_entered(area):
	
	entred_notes.append(area.get_parent())

var pressed_deletion = false
func _on_pressed():
	
	for i in entred_notes:
		if i != null:
			pressed_deletion = true
			
			i.queue_free()
			
			remove_child(i)
			pressed_deletion = false
			$"../../Completion".hit(shortcut_button)
			
	if entred_notes == []:
		$"../../Completion".miss()
	entred_notes = []

func _on_area_2d_area_exited(_area):
	
	
	if !pressed_deletion:
		entred_notes.remove_at(0)
		$"../../Completion".miss()


extends Node
#textboxpreload and characters
var text_box = preload("res://scenes/text_box.tscn")

var characters={
	"bottom":preload("res://assets/sprites/bottom_sprite.png"),
	"crowd":preload("res://assets/sprites/crowd_sprite.png"),
	"helena":preload("res://assets/sprites/Helena_sprite.png"),
	"hermia":preload("res://assets/sprites/Hermia_sprite.png"),
	"lysander":preload("res://assets/sprites/Lysander_sprite.png"),
	"oberon":preload("res://assets/sprites/oberon_sprite.png"),
	"puck":preload("res://assets/sprites/Puck_sprite.png"),
	"titania":preload("res://assets/sprites/Titania_sprite.png")
}


#POSSIBLE INSTRUCTIONS
func change_text (speaker :String = "NONE" ,newtext: String="NONE"):
	var wrapper =  func():
		
		if newtext!="NONE":
			$text_box/Sprite2D/Label_text.text= newtext
		if speaker!="NONE":
			$text_box/Sprite2D/Label_name.text =speaker
	return wrapper

func add_characters (characters_to_add: Array = [], x_coordinates :Array = []):
	var new_sprite
	var normal_width_const = 281.0
	var normal_height_const = 435.0
	var normal_y_const = 140.0
	#adds zeros for the x_coordinates as the default value when the x_coordinates are not filled correctly
	for i in range(characters_to_add.size()-x_coordinates.size()):
		x_coordinates.append(0)
		
		
		
	var wrapper = func():
		if characters_to_add!=[]:
			for idx in range(characters_to_add.size()):
				new_sprite = Sprite2D.new()
				new_sprite.texture=characters[characters_to_add[idx]]
				new_sprite.name = characters_to_add[idx]
				new_sprite.position.x = x_coordinates[idx]
				
				
				new_sprite.scale= Vector2(
					normal_width_const / float(new_sprite.texture.get_width()),
					normal_height_const / float(new_sprite.texture.get_height())
				)

				new_sprite.position.y = normal_y_const*(1+0.3*2)
				
				new_sprite.z_index = -1
				
				add_child(new_sprite)
				
	return wrapper
				
#instructions used per scene (index indecates the clicks made counting from 1)
var scene_instructions = {
1: [change_text("LENA", "ПРИВЕТ!"), add_characters(["oberon"], [900]), add_characters(["hermia"],[500])],
2: [change_text("костя", "ПРИВЕТ")],
3: [change_text("", "")],
4: [change_text("stop")]
}
var click_counter = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	#initial call

	
	add_child(text_box.instantiate())
	
	for i in scene_instructions[click_counter]:
		i.call()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_mask == MOUSE_BUTTON_LEFT:
				click_counter+=1
						
						
						
						
					
				if scene_instructions.keys().max()<click_counter+1:
					get_tree().quit()
					
					
				for i in scene_instructions[click_counter]:
					i.call()
				
				

				
			if event.button_index == MOUSE_BUTTON_RIGHT:
				pass

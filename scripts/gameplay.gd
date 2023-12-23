extends Node
#preload assets
var text_box = preload("res://scenes/text_box.tscn")

const characters={
	"bottom":preload("res://assets/sprites/bottom_sprite.png"),
	"crowd":preload("res://assets/sprites/crowd_sprite.png"),
	"helena":preload("res://assets/sprites/Helena_sprite.png"),
	"hermia":preload("res://assets/sprites/Hermia_sprite.png"),
	"lysander":preload("res://assets/sprites/Lysander_sprite.png"),
	"oberon":preload("res://assets/sprites/oberon_sprite.png"),
	"puck":preload("res://assets/sprites/Puck_sprite.png"),
	"titania":preload("res://assets/sprites/Titania_sprite.png")
}
const backgounds = {
	"castle":preload("res://assets/backgrounds/castle_background.jpg"),
	"forest":preload("res://assets/backgrounds/forest_background.jpg"),
	"theatre":preload("res://assets/backgrounds/forest_background_theatre.jpg"),
	"main_menu":preload("res://assets/backgrounds/main_menu_background.webp")
	
	
}
#POSSIBLE INSTRUCTIONS
var text_to_add = ""
var current_text_speed 
var default_current_text_speed
func change_text (speaker :String = "NONE" ,newtext: String="NONE", text_speed: float = 50.0):
	var wrapper =  func():
		
		#if newtext!="NONE":
			#$text_box/Sprite2D/Label_text.text= newtext
		$text_box/Sprite2D/Label_text.text =""
		text_to_add = newtext
		default_current_text_speed = text_speed/1000
		current_text_speed = text_speed/1000
		if speaker!="NONE":
			$text_box/Sprite2D/Label_name.text =speaker
	return wrapper
#x value 0 to -1152
func add_characters (characters_to_add: Array = [], x_coordinates :Array = []):
	var new_sprite
	var normal_width_const = 281.0
	var normal_height_const = 435.0
	var normal_y_const = 155.0
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
					#normal_width_const / float(new_sprite.texture.get_width()), #changes the width to match all the others
					1,
					normal_height_const / float(new_sprite.texture.get_height())
				)

				new_sprite.position.y = normal_y_const*(1+0.3*2)
				
				new_sprite.z_index = -1
				
				add_child(new_sprite)
				
	return wrapper
	
	
func remove_character(name: String):
	var wrapper = func():
		var character_to_remove = get_node(name)
		if character_to_remove:
			character_to_remove.queue_free()
		
	return wrapper
	
	
	
func change_background(new_background: String):

	var wrapper = func ():
		
		var screen_height = get_viewport().size.y
		var screen_width = get_viewport().size.x
		$background.position.y = 0
		$background.position.x = 0
		
		$background.texture = backgounds[new_background]

		$background.scale = Vector2(
		screen_width/float($background.texture.get_width()),
		screen_height/float($background.texture.get_height())
		)
		$background.position.y += $background.texture.get_height()*screen_height/float($background.texture.get_height())/2
		$background.position.x += $background.texture.get_width()*screen_width/float($background.texture.get_width())/2

	return wrapper



#instructions used per scene (index indecates the clicks made counting from 1)
var scene_instructions = {
1: [change_text("Demetrius", "Hallo"), add_characters(["helena"], [900]), add_characters(["lysander"],[500]), change_background("castle") ],
2: [change_text("Helena", "Hallo")],
3: [change_text("Demetrius", "BYE")],
4: [change_text("HELENA" , "BYE")],
5:[change_text("end")]
}
var click_counter = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	#initial call

	
	add_child(text_box.instantiate())
	
	for i in scene_instructions[click_counter]:
		i.call()


func _process(delta):
	#let letters manualy appear
	current_text_speed-=delta
	if text_to_add!="" and current_text_speed<=0:
		$text_box/Sprite2D/Label_text.text+=text_to_add[0]
		text_to_add = text_to_add.substr(1)
		current_text_speed = default_current_text_speed
		$speechspeaker.play()
		
		
	

func _input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_mask == MOUSE_BUTTON_LEFT and text_to_add == "":
				click_counter+=1
						
						
						
						
					
				if scene_instructions.keys().max()<click_counter+1:
					get_tree().quit()
					
				
				for i in scene_instructions[click_counter]:
					i.call()
			
			#finish the text when it's still showing
			elif event.button_mask == MOUSE_BUTTON_LEFT and text_to_add != "":
				$text_box/Sprite2D/Label_text.text +=text_to_add
				text_to_add = ""
				
				
			

				
			if event.button_index == MOUSE_BUTTON_RIGHT:
				pass

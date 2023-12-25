extends Node
#preload assets
var text_box = preload("res://scenes/text_box.tscn")

const characters={
	"bottom":preload("res://assets/sprites/bottom_sprite.png"),
	
	"helena":preload("res://assets/sprites/Helena_sprite.png"),
	"hermia":preload("res://assets/sprites/hermia_sprite.png"),
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
const sounds = {
	"text_appear": preload("res://assets/sounds/sound effects/rpg-text-speech-sound-131477-[AudioTrimmer.com].mp3"),
	"calm_song":preload("res://assets/sounds/music/04 Mitsukiyo 04 Lovely Picnic.mp3")
}

const menu = {
	"settings":preload("res://scenes/settings.tscn")
}
#POSSIBLE INSTRUCTIONS
var text_to_add = ""
var current_text_speed 
var default_current_text_speed
var text_delay_punctuation = {
	"!":0.15,
	".":0.15,
	",":0.10,
	"—":0.5,
	"?":0.15
}

func change_text (speaker :String = "NONE" ,newtext: String="NONE", text_speed_ms: float = 35.0):
	var wrapper =  func():
		
		#if newtext!="NONE":
			#$text_box/Sprite2D/Label_text.text= newtext
		$text_box/Sprite2D/Label_text.text =""
		text_to_add = newtext
		default_current_text_speed = text_speed_ms/1000
		current_text_speed = text_speed_ms/1000
		if speaker!="NONE":
			$text_box/Sprite2D/Label_name.text =speaker
	return wrapper
#x value 0 to -1152
func add_characters (characters_to_add: Array = [], x_coordinates :Array = []):
	var new_sprite
	var normal_width_const = 400.0
	var normal_height_const = 400.0
	var normal_y_const =165.0
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
					normal_width_const / float(new_sprite.texture.get_width()), #changes the width to match all the others
					#1,
					normal_height_const / float(new_sprite.texture.get_height())
				)

				new_sprite.position.y = normal_y_const*(1+0.3*2)
				
				new_sprite.z_index = -1
				#mirror a sprite if it is on the other side
				if new_sprite.position.x < get_viewport().size.x/2:
					new_sprite.scale.x *=-1
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

		
#this function changes the variables and the result gets calculated in _process
var new_pos
var cutscene_active = false
var cutscene_type = "Linear"
var character_name_to_animate
var cutscene_duration = 3.0
var animation_delay = 0
var character_speed
func cutscene(name: String, new_position: float,time : float = 2, animation_type: String ="Linear", delay: float=0.0):
	name = name.to_lower()
	var wrapper = func ():
		character_name_to_animate = get_node(name)
		
		if !character_name_to_animate:
			cutscene_active =false
		else:
			new_pos = new_position
			
			character_speed = (new_position-character_name_to_animate.position.x)/time
			cutscene_active = true
			cutscene_type = animation_type

			cutscene_duration = time
			animation_delay = delay
	return wrapper

func change_song(song_name:String):
	var wrapper = func():
		if song_name in sounds:
			$songspeaker.stream = sounds[song_name]
			$songspeaker.play()
	return wrapper
var sound_delay = 0.0
var play_sound_effect = false
func play_sound(sound_name:String, sound_delay_seconds = 0.0):
	var wrapper = func():
		if sound_name in sounds:
			$speechspeaker/soundspaeker.stream = sounds[sound_name]
			sound_delay = sound_delay_seconds
			play_sound_effect = true
			
	return wrapper
func END():
	var wrapper = func():
		get_tree().quit()
	return wrapper
			



#instructions used per scene (index indecates the clicks made counting from 1)
'''var scene_instructions = {
1: [change_text("Demetrius", "Hallo"), add_characters(["helena"], [900]), add_characters(["lysander"],[500]), change_background("castle") ],
2: [change_text("Helena", "Hallo"), cutscene('helena',90)],
3: [change_text("Demetrius", "BYE")],
4: [change_text("HELENA" , "BYE")],
5:[change_text("end")]
}
'''
var scene_instructions = {
	1: [change_text("Bottom", "Hey, fellow thespians! Our time to shine is here. But, heads up, we gotta tweak some things."), add_characters([ "bottom"],[200]), change_background('theatre'), change_song('calm_song'), cutscene("bottom", 900,2,'Linear',2)],
	2: [change_text("Quince", "Tweaks, Bottom? Spill the tea, please.")],
	3: [change_text("Bottom", "For the ladies, dear Quince! Can't mess with their vibes, you know? Delicate sensibilities and all that jazz.")],
	4: [change_text("Snug", "And to avoid confusion, let's be crystal—our lion ain't real, and our sword is just for show.")],
	5: [change_text("Starveling", "Show, got it! Wise moves, Snug. But seriously, no real lion? Bummer.")],
	6: [change_text("Bottom", "Also, let's spice it up. How 'bout someone plays a wall, and another brings the moonlight with a bush and lantern? Cool, huh?")],
	7: [change_text("Puck", "*Mischievously:* Let's sprinkle a bit of chaos from the shadows!")],
	8: [change_text("Bottom", "*Aside: Ah, friends, I'm stepping aside for a quick brainstorm on our epic play. Maybe even drop a sonnet about this wild night.*"), add_characters(["puck"],[900])],
	9: [change_text("Puck", "*Mischievously:* Now, time for a little mayhem!")],
	10: [change_text("Craftsmen", "*Terrified: An ass-headed monster! Run for your lives!*")],
	11: [change_text("Puck", "*Chasing after: Oh, the joy of chaos! Just another day in the enchanted forest, right?*")],
	12: [change_text("Titania", "*Awakening: What's this? An ass-headed delight! How charming!*")],
	13: [change_text("Bottom", "*Unaware: Fear not, fair Titania! Bottom is at your service. And yes, my head's up for grabs!*")],
	14: [change_text("Titania", "*Fair fairies, attend to him. Peaseblossom, Cobweb, Mote, Mustardseed, be his devoted companions. Don't skimp on the head rubs!*")],
	15: [change_text("Puck", "To Oberon: My lord, all's a bit wild. The lovers roam the forest, love-confused and all.")],
	16: [change_text("Oberon", "Great, Puck! The plan unfolds. Now, let's sort this mess.")],
	17: [change_text("Puck", "On it, my lord. No more love confusion. I'll untangle the lovers with the dawn. It's like fixing a magical Rubik's Cube.")],
	18: [change_text("Oberon", "And our queen enchanted by an ass! This night's a riot.")],
	19: [change_text("Puck", "Chuckles: Indeed, my lord. The night's mischief knows no bounds. It's almost as fun as pranking mortals.")],
	20: [change_text("Oberon", "Well, Puck, let the mortals sleep. We'll watch the sunrise and revel in the magic of a midsummer night's dream.")],
	21: [change_text("Puck", "*Overseeing the lovers as they wake up. Time to see how our little love potion plays out!*")],
	22: [change_text("Oberon", "Impressed: Look, Puck. The lovers are waking up, and all confusion has vanished.")],
	23: [change_text("Puck", "Grinning: A little mischief can lead to clarity, my lord. Who knew?")],
	24: [change_text("Oberon", "Nods: True, Puck. Sometimes, a touch of magic is all they need. We should start a magical advice column, don't you think?")],
	25: [change_text("Puck", "Gazes at the sunrise: A beautiful end to a magical night. And now, we wait for the reviews from our enchanted audience.")],
	26: [change_text("Oberon", "Agrees: Indeed, Puck. Let's leave them to their day. The magic of the night has done its work. Until the next night, my mischievous companion.")],
	27: [change_text("Puck", "Vanishing into the shadows: Until then, my lord. Remember, the night is young, and so are we.")],
	28: [change_text("Oberon", "Fading away: Until then, Puck. The magic will continue.")],
	29: [END()]
}




var click_counter = 1
var settings_opened = false

func _ready():
	#initial call

	
	add_child(text_box.instantiate())
	
	for i in scene_instructions[click_counter]:
		i.call()


func _process(delta):
	#let letters manualy appear
	current_text_speed-=delta
	if text_to_add!="" and current_text_speed<=0:
		current_text_speed = default_current_text_speed
		if text_to_add[0] in text_delay_punctuation:
			current_text_speed+=text_delay_punctuation[text_to_add[0]]
		$text_box/Sprite2D/Label_text.text+=text_to_add[0]
		text_to_add = text_to_add.substr(1)
		
		$speechspeaker.play()
		
	
		
	
	#cutscene behaviour
	
	if cutscene_active and animation_delay<=0:
		
		
		
		cutscene_duration-=delta
		match (cutscene_type):
			
			"Linear":
				character_name_to_animate.position.x+=character_speed*delta
			"Quadratic":
				pass
	#sound behaviour
	if sound_delay<0 and play_sound_effect:
		$speechspeaker/soundspaeker.play()
		play_sound_effect = false
	elif play_sound_effect:
		sound_delay-=delta
		
		
		
				
	#animation behaviour
	if animation_delay>0:
		animation_delay-=delta
	if cutscene_duration <=0:
		cutscene_active = false
	
	
	

		
		
		
		
		
	

func _input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_mask == MOUSE_BUTTON_LEFT and text_to_add == "" and settings_opened==false:
				click_counter+=1
						
						
						
						
					
				#if scene_instructions.keys().max()<click_counter+1:
					#get_tree().quit()
					
				
				for i in scene_instructions[click_counter]:
					i.call()
			
			#finish the text when it's still showing
			elif event.button_mask == MOUSE_BUTTON_LEFT and text_to_add != "" and settings_opened==false:
				$text_box/Sprite2D/Label_text.text +=text_to_add
				text_to_add = ""
				
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			if !has_node("settings"):
				settings_opened =true
				add_child(menu["settings"].instantiate())
			else:
				settings_opened = false
				$settings.queue_free()
				
				
			

				

			
		

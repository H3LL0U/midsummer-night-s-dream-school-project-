extends Node
#preload assets
var text_box = preload("res://scenes/text_box.tscn")

const characters={
	"bottom":preload("res://assets/sprites/bottom_sprite.png"),
	"bottom donkey":preload("res://assets/sprites/bottom_sprite_donkey.png"),
	"helena":preload("res://assets/sprites/Helena_sprite.png"),
	"hermia":preload("res://assets/sprites/hermia_sprite.png"),
	"lysander":preload("res://assets/sprites/Lysander_sprite.png"),
	"oberon":preload("res://assets/sprites/oberon_sprite.png"),
	"puck":preload("res://assets/sprites/Puck_sprite.png"),
	"titania":preload("res://assets/sprites/Titania_sprite.png"),
	"starveling":preload("res://assets/sprites/starveling_sprite.png"),
	"quince":preload("res://assets/sprites/quince_sprite.png"),
	"snout":preload("res://assets/sprites/snout_sprite.png"),
	"snug":preload("res://assets/sprites/snug_sprite.png"),
	"flute":preload("res://assets/sprites/flute_sprite.png")
	
}
const backgounds = {
	"castle":preload("res://assets/backgrounds/castle_background.jpg"),
	"forest":preload("res://assets/backgrounds/forest_background.jpg"),
	"theatre":preload("res://assets/backgrounds/theatre_background.jpg"),
	"main_menu":preload("res://assets/backgrounds/main_menu_background.webp"),
	"theatre_aside":preload("res://assets/backgrounds/theatre_background_aside.jpg")
	
	
}
const sounds = {
	"text_appear": preload("res://assets/sounds/sound effects/rpg-text-speech-sound-131477-[AudioTrimmer.com].mp3"),
	"lovely_picnic":preload("res://assets/sounds/music/04 Mitsukiyo 04 Lovely Picnic.mp3"),
	"initial_investigation": preload("res://assets/sounds/music/13. Initial Investigation 2001.mp3"),
	"unwelcome_school":preload("res://assets/sounds/music/07 Mitsukiyo 05 Unwelcome School.mp3"),
	"mischief":preload("res://assets/sounds/music/carefully-does-it.mp3")
}
const menu = {
	"settings":preload("res://scenes/settings.tscn")
}

const  mini_games = {
	"cast_a_spell": preload("res://scenes/minigame_spell_cast.tscn"),
	"singing_minigame": preload("res://scenes/singing_minigame.tscn")
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

func change_text (speaker :String = "NONE" ,newtext: String="NONE", text_speed_ms: float = 34.0, initial_delay: float = 0):
	var wrapper =  func():
		
		#if newtext!="NONE":
			#$text_box/Sprite2D/Label_text.text= newtext
		$text_box/Label_text.text =""
		text_to_add = newtext
		default_current_text_speed = text_speed_ms/1000
		current_text_speed = initial_delay
		if speaker!="NONE":
			$text_box/Label_name.text =speaker
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
	
	
func remove_characters(_names: Array):
	var wrapper = func():
		
		var character_to_remove
		for _name in _names:
			
			character_to_remove = get_node(_name)
		
			if character_to_remove:
				character_to_remove.queue_free()
				remove_child(character_to_remove)
		
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
var character_name_to_animate ={}
#var new_pos
var cutscene_active = false

@export var unable_voicelines = true

func cutscene(_names: Array, new_positions: Array,time : Array = [1], animation_type: Array =["Quadratic"], delay: Array=[0.0]):
	
	for i in range(_names.size()-time.size()):
		time.append(2)
	for i in range(_names.size()-animation_type.size()):
		animation_type.append("Quadratic")
	for i in range(_names.size()-delay.size()):
		delay.append(0)
	
		
	var wrapper = func ():

		
		if !_names:
			cutscene_active =false
		else:
			for i in range(len(_names)):
				if has_node(_names[i]):
					character_name_to_animate[get_node(_names[i])] = {
						"new_position":new_positions[i],
						"start_pos": get_node(_names[i]).position.x,
						"time":time[i],
						"default_time": time[i],
						"animation_type":animation_type[i],
						"delay":delay[i],
						"character_speed": (new_positions[i]-get_node(_names[i]).position.x)/time[i],
						"animation_active": true
						
						}
			cutscene_active = true
			
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
	
@export var minigame_active = false
func switch_to_minigame(minigame = ""):
	var wrapper = func ():
		voicelines_index-=1
		if minigame == "" or minigame == "cast_a_spell":
			add_child(mini_games["cast_a_spell"].instantiate())
			get_tree().paused = true
		elif minigame == "singing_minigame":
			add_child(mini_games["singing_minigame"].instantiate())
			minigame_active = true
			
		
		#get_tree().paused = true
		$speechspeaker/soundspeaker.stop()
		
		
		
	return wrapper


func END():
	var wrapper = func():
		get_tree().change_scene_to_file("res://scenes/end_credits.tscn")
	return wrapper
			

var voicelines_index = 0
func process_scene_instructions():
	click_counter+=1
	
	voicelines_index+=1
						
						
						
					
				#if scene_instructions.keys().max()<click_counter+1:
					#get_tree().quit()
					
				
	#for i in scene_instructions[click_counter-1]:
					
		#i.call()
	
	'''for i in characters:
					
		if has_node(i) and (get_node(i).name in $text_box/Label_name.text.to_lower() or $text_box/Label_name.text.to_lower() in get_node(i).name or $text_box/Label_name.text.to_lower()=="everyone") :
						
			get_node(i).modulate = Color(1,1,1,1)
			get_node(i).z_index = 1
		elif has_node(i):
			get_node(i).z_index = 0
			get_node(i).modulate = Color(0.56,0.56,0.56,1)
				#let the voicelines play
	'''
	if (len(voicelines)>=click_counter and unable_voicelines ) :
					
		$speechspeaker/soundspeaker.stream = voicelines[voicelines_index-1]
		$speechspeaker/soundspeaker.play()
	else:
			
			
				
		$speechspeaker/soundspeaker.stop()
	#dimm the characters that don't speak
	for i in scene_instructions[click_counter-1]:
					
		i.call()
	for i in characters:
					
		if has_node(i) and (get_node(i).name in $text_box/Label_name.text.to_lower() or $text_box/Label_name.text.to_lower() in get_node(i).name or $text_box/Label_name.text.to_lower()=="everyone") :
						
			get_node(i).modulate = Color(1,1,1,1)
			get_node(i).z_index = 1
		elif has_node(i):
			get_node(i).z_index = 0
			get_node(i).modulate = Color(0.56,0.56,0.56,1)
						
						
func open_settings_menu():

	if !has_node("settings"):
		settings_opened =true
		add_child(menu["settings"].instantiate())
	else:
		settings_opened = false
		$settings.queue_free()
		remove_child($settings)



	
#instructions used per scene (index indecates the clicks made counting from 1)


var scene_instructions = [
[
	
	change_text('Quince', "Alright, everyone here? Let's rehearse in this convenient spot. Our stage is this green plot, the dressing room is this hawthorn brake. We'll act it out as planned before the Duke."),
	change_background('theatre'),
	add_characters(["bottom","quince","snug","snout", "flute","starveling"], [200, 350, 500, 650, 800, 950]),
	
	
	change_song("initial_investigation")
],

 [
	
	change_text('Bottom', "Peter Quince?"),
	
],
 [
	change_text('Quince', "What's up, Bottom?")
],
 [
	change_text('Bottom', "There are problems in the Pyramus and Thisbe play. Pyramus has to kill himself with a sword, and the ladies won't like that. What do you think?")
],
 [
	change_text('Snout', "It's a dangerous idea! Oberon might kill us because of it!")
],
 [
	change_text('Starveling', "We should skip the killing.")
],
 [
	change_text('Bottom', "No, I have a plan. Write a prologue assuring them there's no harm, Pyramus isn't really dead, and that I'm not even Pyramus, but Bottom the weaver.")
],
 [
	change_text('Quince', "Okay, we'll do that in eight and six lines.")
],
 [
	change_text('Bottom', "Make it eight!")
],
 [
	change_text('Snout', "But won't the ladies be scared of the lion?")
],
 [
	change_text('Starveling', "I'm afraid so."),
],
[
	change_text('Bottom', "We can handle that. Another prologue saying the lion isn't real.")
],
[
	change_text('Snug', "That could work."),
],
[
	change_text('Bottom', "Also, he should speak through the lion's neck, introducing himself as Snug the joiner."),
],
[
	change_text('Quince', "Fine, we'll go with that. But there are other challenges, like bringing moonlight in and creating a wall.")
],
[
	change_text('Snug', "Does the moon shine the night of our play?")
],
[
	change_text('Bottom', "Check the calendar.")
],
[
	change_text('Quince', "Yes, it does.")
],
[
	change_text('Bottom', "Then leave a window open for the moon or have someone come in with a lantern and thorns to represent Moonshine.")
],
[
	change_text('Quince', "And what about the wall?")
],
[
	change_text('Bottom', "Snout can play a wall with plaster or loam, and Pyramus and Thisbe can talk through a cranny.")
],
[
	change_text('Quince', "That works, let's sit down and rehearse.")
],

[
	change_text('Everyone', "Allright!")
],
[
	change_text("Quince", "You can start, Pyramus"),
	cutscene(["snug","snout","starveling","flute"],[-300,1500,1500,1500],[1,1,1,1]),
	cutscene(["quince"],[500])
],
[
	change_text('Bottom', "Thisbe, the flowers of odorous savors sweet."),
	
],
[
	change_text('Quince', "Odors, not odorous!")
],
[
	change_text('Bottom', "Odors savors sweet. So hath thy breath, my dearest Thisbe dear."),
	cutscene(["bottom"],[-200],[1],["Linear"],[2])
],
[
	#include these change_text functions as well! as well please! please add all of these in the right order from up to down (not at the end)
	change_text('', 'Meanwhile behind the bush...',37),
	remove_characters(['quince']),
	remove_characters(['bottom']),
	add_characters(['bottom'],[500]),
	change_background('theatre_aside'),
	change_song('mischief')
	
	
	
],
[
	change_text("Bottom","I can practise my text while it's not my turn.")
],
[
	add_characters(['puck'],[1500]),
	cutscene(['puck'],[800]),
	change_text('Puck',"It's time to commit some mischief!")
],
[
	switch_to_minigame()
],
[
	
	change_text('Puck', 'Hehehehehe!'),
	remove_characters(['bottom']),
	add_characters(['bottom donkey'],[500]),
	cutscene(['puck'],[-500])
],
[
	change_text('Bottom donkey', "Looks like it should be my turn soon."),
	cutscene(['bottom donkey'],[1500])
],
[
	remove_characters(['bottom donkey']),
	add_characters(['bottom donkey'],[-300]),
	change_text('','Meanwhile at the stage...',37),
	change_background('theatre'),
	add_characters(['quince'],[500]),
	change_song('lovely_picnic')
],
[
	
	
	
	cutscene(["flute"],[1200],[1]),
	change_text('Flute', "Is it my turn?")
],
[
	change_text('Quince', "Yes, go for it. You're just going to see what the noise was and come back.")
],
[
	cutscene(["flute"],[900],[2]),
	change_text('Flute (as Thisbe)', "Most radiant Pyramus, most lily-white of hue...")
],

[
	change_song("unwelcome_school"),
	cutscene(["bottom donkey"],[200]),
	change_text('Bottom', "If I were fair, Thisbe, I were only thine.")
],
[
	change_text('Quince', "Monstrous! We're haunted! Run!"),
],
[
	cutscene(["quince","flute"],[1500,1500],[1,1]),
	change_text('Quince and Flute', "AAAAAAAAAA!")
	
],

[
	change_text('Bottom', "Why did they run? This is a trick to scare me."),
],

[
	cutscene(["snout"],[900],[1]),
	change_text('Snout', "Bottom, you've changed! What's on your head?",34,1.2),
],
[
	change_text('Bottom', "A donkey-head, just like yours."),
],

[
	cutscene(["snout","quince"],[1500,900],[1]),
	change_text('Quince', "Bless you, Bottom. You've transformed.",34,1.2),
],

[
	cutscene(["quince","bottom donkey"],[1500,600]),
	change_text('Bottom', "They're making a fool of me, but I won't leave. I'll sing to show I'm not scared.",34,1.2),
],
[
	change_song("lovely_picnic"),
	change_text('Bottom', "*Sings*"),
],
[
	switch_to_minigame("singing_minigame")
],
[
	add_characters(["titania"],[-400]),
	cutscene(['titania'],[200]),
	cutscene(["bottom donkey"],[900]),
	
	change_text('Titania', "Who woke me? What angel is this?")
],
[
	change_text('Bottom', "The finch, the sparrow, and the lark...~"),
],
[
	change_text('Titania', "Sing again. Your voice and appearance enchant me."),
],
[
	change_text('Bottom', "You should have little reason for that. But, to be honest, reason and love don't go together nowadays."),
],
[
	change_text('Titania', "You're as wise as you are beautiful."),
],
[
	change_text('Bottom', "Not really, but if I had the wit to leave this forest, I'd be fine."),
],
[
	change_text('Titania', "Don't leave. Stay with me. I'm a fairy, and I am in love with you.")
],
[
	change_text('Bottom', "Mistress, upon my life, I shall serve you truly."),
],
[
	change_text('Titania','Follow me to my forest bower we shall celebrate with other Fairies')
],
[
	change_text("Bottom",'Of course my mistress!')
],
[
	cutscene(['titania'],[1500]),
	cutscene(["bottom donkey"],[1500])
	
],
[
	change_text('',"The end of the Act 3 Scene 1",37)
],
[
END()
]
]

var voicelines = []





var click_counter = 0
@export var settings_opened = false

#get the completion

@export var completion = 0
func _ready():
	#initialize voicelines
	for i in range(len(scene_instructions)):
		
		
		if ResourceLoader.exists("res://assets/sounds/voicelines/"+str(i+1)+".mp3"):
			
			var str_to_preload = "res://assets/sounds/voicelines/"+str(i+1)+".mp3"
			voicelines.append(load(str_to_preload))
		else:
			var str_to_preload = "res://assets/sounds/voicelines/s.mp3"
			voicelines.append(load(str_to_preload))
			
	#initial call
	add_child(text_box.instantiate())
	process_scene_instructions()
	
	'''
	
	for i in scene_instructions[click_counter-1]:
		i.call()
	for i in characters:
		if has_node(i) and get_node(i).name in $text_box/Label_name.text.to_lower():
			get_node(i).z_index = 1
			get_node(i).modulate = Color(1,1,1,1)
		elif has_node(i):
			get_node(i).z_index = 0
			
			get_node(i).modulate = Color(0.56,0.56,0.56,1)
'''

func _process(delta):
	#let letters manualy appear
	current_text_speed-=delta
	if text_to_add!="" and current_text_speed<=0:
		current_text_speed = default_current_text_speed
		if text_to_add[0] in text_delay_punctuation:
			current_text_speed+=text_delay_punctuation[text_to_add[0]]
		$text_box/Label_text.text+=text_to_add[0]
		text_to_add = text_to_add.substr(1)
		if unable_voicelines==false:
			$speechspeaker.play()
		
	
		
	
	#change the dictionaries with characters new position and states for the animation 
	for chr in character_name_to_animate:
		
		if cutscene_active and character_name_to_animate[chr]["delay"]<=0:
			
			
			
			character_name_to_animate[chr]["time"]-=delta
			match (character_name_to_animate[chr]["animation_type"]):
				
				"Linear":
					
					chr.position.x+=character_name_to_animate[chr]["character_speed"]*delta
				
				"Quadratic":
					chr.position.x+=character_name_to_animate[chr]["character_speed"]*delta*(character_name_to_animate[chr]["time"]+0)*(character_name_to_animate[chr]["default_time"]+character_name_to_animate[chr]["time"])*1.22463916406/+character_name_to_animate[chr]["default_time"]**2#*(character_name_to_animate[chr]["new_position"]-character_name_to_animate[chr]["start_pos"])/character_name_to_animate[chr]["new_position"]*1.43
					#-434
					#-653.25364685058
					#distance to travel:
		
		if character_name_to_animate[chr]["delay"]>0:
			character_name_to_animate[chr]["delay"]-=delta
		if character_name_to_animate[chr]["time"] <=0:
			
			character_name_to_animate[chr]["animation_active"] = false	
	#check if all the animations have finished
	for chr in character_name_to_animate:
		if character_name_to_animate[chr]["animation_active"]:
			cutscene_active = true
			break
			
		else:
			cutscene_active = false
			
	if cutscene_active == false:
		character_name_to_animate = {}
	
	
		
					
		#sound behaviour
	if sound_delay<0 and play_sound_effect:
		$speechspeaker/soundspaeker.play()
		play_sound_effect = false
	elif play_sound_effect:
		sound_delay-=delta
		
		
	#update completion
	completion = float(click_counter) / float(len(scene_instructions))
	




	
	
	




		
		
		
		
		
	
func _on_settings_button_pressed():
	open_settings_menu()

func _unhandled_input (event: InputEvent):
	
	if event is InputEventMouseButton or event is InputEventKey and !event.is_echo():
		
		if event.pressed:
			
			if event is InputEventMouseButton and (event.button_mask == MOUSE_BUTTON_LEFT) and text_to_add == "" and settings_opened==false and cutscene_active==false and !minigame_active :
				
				process_scene_instructions()
			elif event is InputEventKey and event.keycode == KEY_SPACE and text_to_add == "" and settings_opened==false and cutscene_active==false and !minigame_active:
				process_scene_instructions()
				'''
				click_counter+=1
						
						
						
						
					
				#if scene_instructions.keys().max()<click_counter+1:
					#get_tree().quit()
					
				
				for i in scene_instructions[click_counter-1]:
					
					i.call()
				#dimm the characters that don't speak
				for i in characters:
					
					if has_node(i) and (get_node(i).name in $text_box/Label_name.text.to_lower() or $text_box/Label_name.text.to_lower() in get_node(i).name or $text_box/Label_name.text.to_lower()=="everyone") :
						
						get_node(i).modulate = Color(1,1,1,1)
						get_node(i).z_index = 1
					elif has_node(i):
						get_node(i).z_index = 0
						get_node(i).modulate = Color(0.56,0.56,0.56,1)
				#let the voicelines play
				if len(voicelines)>=click_counter and unable_voicelines:
					
					$speechspeaker/soundspeaker.stream = voicelines[click_counter-1]
					$speechspeaker/soundspeaker.play()
				else:
					
					$speechspeaker/soundspeaker.stop()
					
			'''
			
						
						
					
			
			#finish the text when it's still showing and you click
			elif event is InputEventMouseButton and event.button_mask == MOUSE_BUTTON_LEFT and text_to_add != "" and settings_opened==false and !minigame_active:
				$text_box/Label_text.text +=text_to_add
				text_to_add = ""
			elif event is InputEventKey and event.keycode == KEY_SPACE and text_to_add != "" and settings_opened==false and !minigame_active:
				$text_box/Label_text.text +=text_to_add
				text_to_add = ""
	if event is InputEventKey and event.pressed:
		
		if event.keycode == KEY_ESCAPE:
			open_settings_menu()
'''	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			if !has_node("settings"):
				settings_opened =true
				add_child(menu["settings"].instantiate())
			else:
				settings_opened = false
				$settings.queue_free()'''
				
				
			

				

			














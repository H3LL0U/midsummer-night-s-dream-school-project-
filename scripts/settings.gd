extends Node2D

var script_toggle_checkbox = false
var confirmation_menu
func _ready():
	confirmation_menu = preload("res://scenes/confirmation_menu.tscn")
	if has_node("/root/gameplay"):
		script_toggle_checkbox = true
		$CheckBox.button_pressed = $/root/gameplay.unable_voicelines
		script_toggle_checkbox = false
		
		
		
func _on_quit_button_pressed():
	if !has_node("confirmation_menu"):
		add_child(confirmation_menu.instantiate())

		


func _on_resume_pressed():
	get_node("../../gameplay").settings_opened = false
	self.queue_free()


func _on_check_box_toggled(toggled_on):
	
	if has_node("/root/gameplay") and not script_toggle_checkbox:
		
		$/root/gameplay.unable_voicelines = toggled_on
	
		


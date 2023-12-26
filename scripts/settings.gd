extends Node2D

func _on_quit_button_pressed():
	get_tree().quit()


func _on_resume_pressed():
	get_node("../../gameplay").settings_opened = false
	self.queue_free()

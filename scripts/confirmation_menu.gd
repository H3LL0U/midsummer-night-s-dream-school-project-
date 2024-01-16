extends Node2D









func _on_cancel_button_pressed():
	$".".queue_free()


func _on_quit_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main menu.tscn")

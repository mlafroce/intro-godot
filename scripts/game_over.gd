extends Control

func _on_play_again_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_game.tscn")

func _on_exit_button_pressed() -> void:
	get_tree().quit()

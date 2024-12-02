extends Node2D

const ENEMY = preload("res://scenes/enemy.tscn")

func spawn_enemy():
	var new_enemy = ENEMY.instantiate()
	%EnemySpawnLocation.progress_ratio = randf()
	
	new_enemy.global_position = %EnemySpawnLocation.global_position
	
	add_child(new_enemy)

func _process(delta: float) -> void:
	%WeaponProgressBar.set_bullet_progress(%Player.get_bullet_progress())

func _on_player_health_depleted() -> void:
	#get_tree().paused = true
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")


func _on_enemy_timer_timeout() -> void:
	spawn_enemy()

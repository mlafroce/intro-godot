extends Area2D

@onready var default_pos = %WandSprite.get_position()

var time = 0.0
var amplitude = 4.0
var frequency = 8.0

func _process(delta: float) -> void:
	%WandSprite.scale.x = move_toward(%WandSprite.scale.x, 0.455, 3 * delta)
	%WandSprite.scale.y = move_toward(%WandSprite.scale.y, 0.455, 3 * delta)
	

func _physics_process(delta: float) -> void:
	var enemies_in_range: Array[Node2D] = get_overlapping_bodies()
	time += delta * frequency

	if !enemies_in_range.is_empty():
		var target_enemy: CharacterBody2D = enemies_in_range.front()
		%WeaponPivot.look_at(target_enemy.global_position)
		%WandSpritePivot.look_at(target_enemy.global_position)
		%WandSprite.global_position = %WandSpritePivot.global_position
		%WandSprite.global_position = (%WandSpritePivot.global_position + Vector2(0, sin(time) * amplitude))
		
		var pos_h = %WandSprite.position.normalized()				
		%WandAnimationTree.set("parameters/blend_position", pos_h)
	else:
		%WeaponPivot.look_at(get_global_mouse_position())
		%WandSpritePivot.look_at(get_global_mouse_position())
		%WandSprite.global_position = %WandSpritePivot.global_position
		%WandSprite.global_position = (%WandSpritePivot.global_position + Vector2(0, sin(time) * amplitude))
		
		var pos_h = %WandSprite.position.normalized()				
		%WandAnimationTree.set("parameters/blend_position", pos_h)

func shoot():
	%WandSprite.scale = Vector2(0.650, 0.3)
	
	const BULLET = preload("res://scenes/bullet.tscn")
	const LASER = preload("res://scenes/laserbeam.tscn")
	var new_bullet = LASER.instantiate()
	
	new_bullet.global_position = %ShootingPoint.global_position
	new_bullet.global_rotation = %ShootingPoint.global_rotation
	
	%ShootingPoint.add_child(new_bullet)


func _on_timer_timeout() -> void:
	var enemies_in_range: Array[Node2D] = get_overlapping_bodies()

	if !enemies_in_range.is_empty():
		shoot()

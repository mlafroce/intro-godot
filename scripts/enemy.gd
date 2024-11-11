extends CharacterBody2D

const SPEED = 150.0

@onready var player = get_node("/root/MainGame/Player")
var health = 3

func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	
	velocity = direction * SPEED
	
	var dir_normalized = direction.normalized()
	
	if dir_normalized != Vector2.ZERO:
		%EnemyAnimationTree.set("parameters/Walk/blend_position", dir_normalized)
	
	move_and_slide()

func take_damage() -> void:
	health -= 1
	
	if health == 0:
		queue_free()

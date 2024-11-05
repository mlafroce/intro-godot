extends CharacterBody2D

const SPEED = 350

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * SPEED
	
	var dir_normalized = direction.normalized()
	
	if dir_normalized != Vector2.ZERO:
		%PlayerAnimationTree.set("parameters/Idle/blend_position", dir_normalized)
	
	move_and_slide()
	
	

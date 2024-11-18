extends CharacterBody2D

signal health_depleted

const SPEED = 350
var time = 0.0
var amplitude = 4.0
var frequency = 8.0
	
var amplitude_shadow = 0.125

var health: float = 100.0
const DMG_RATE = 5.0

@onready var default_pos = %MaguitoSketch.get_position()

func _process(delta: float) -> void:
	time += delta * frequency
	
	%MaguitoSketch.set_position(default_pos + Vector2(0, sin(time) * amplitude))
	
	%Sombra.scale = Vector2(0.963, 0.697) + Vector2(sin(time) * amplitude_shadow, sin(time) * amplitude_shadow)

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * SPEED
	
	var dir_normalized = direction.normalized()
	
	if dir_normalized != Vector2.ZERO:
		%PlayerAnimationTree.set("parameters/Idle/blend_position", dir_normalized)
		
	move_and_slide()
	
	var overlapping_enemies = %HurtBox.get_overlapping_bodies()
	
	if !overlapping_enemies.is_empty():
		health -= overlapping_enemies.size() * DMG_RATE
		
		if health <= 0.0:
			health_depleted.emit()

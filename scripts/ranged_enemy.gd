extends CharacterBody2D

const SPEED = 0.0

const MAX_GLOW = 1.0
const MIN_GLOW = 0.0
const GLOW_STEP = 10.0

@onready var player = get_node("/root/MainGame/Player")
var health = 2
var time = 0.0
const AMPLITUDE = 5.0
var FREQ = 8.0
var SHADOW_AMPLITUDE = 0.125 / 4
var current_glow = MIN_GLOW

func _ready() -> void:
	var shader = %RangedEnemySprite.material as ShaderMaterial
	# Instance uniforms are not implemented, workaround!
	%RangedEnemySprite.material = shader.duplicate()

func _process(delta: float) -> void:
	var shader = %RangedEnemySprite.material as ShaderMaterial
	shader.set_shader_parameter("EXTRA_GLOW", current_glow)
	if current_glow > 0.0:
		current_glow -= GLOW_STEP * delta
		if current_glow < 0.0:
			current_glow = 0.0

func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	%WeaponPivot.look_at(player.global_position)
	
	velocity = direction * SPEED
	time += delta * FREQ
	
	%RangedEnemySprite.set_position(Vector2(0, sin(time/1.5) * AMPLITUDE))
	%Shadow.scale = Vector2(0.963, 0.697) + Vector2(sin(time/1.5) * SHADOW_AMPLITUDE, sin(time/1.5) * SHADOW_AMPLITUDE)
	
	var dir_normalized = direction.normalized()	
	%RangedAnimationTree.set("parameters/Shoot/blend_position", dir_normalized)
	
	move_and_slide()

func take_damage(dmg: int) -> void:
	health -= dmg
	
	current_glow = MAX_GLOW;
	var shader = %RangedEnemySprite.material as ShaderMaterial
	shader.set_shader_parameter("EXTRA_GLOW", current_glow)
	
	if health <= 0:
		Events.emit_signal("enemy_died")
		queue_free()

func _on_shooting_timer_timeout() -> void:
	const ENEMY_BULLET = preload("res://scenes/enemy_bullet.tscn")
	var new_bullet = ENEMY_BULLET.instantiate()
	
	new_bullet.global_position = %ShootingPoint.global_position
	new_bullet.global_rotation = %ShootingPoint.global_rotation
	
	%ShootingPoint.add_child(new_bullet);

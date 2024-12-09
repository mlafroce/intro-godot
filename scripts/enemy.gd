extends CharacterBody2D

const SPEED = 150.0
const MAX_GLOW = 1.0
const MIN_GLOW = 0.0
const GLOW_STEP = 10.0

@onready var player = get_node("/root/MainGame/Player")

var health = 5
var current_glow = MIN_GLOW

func _ready() -> void:
	var shader = %PlaceholderSprite.material as ShaderMaterial
	# Instance uniforms are not implemented, workaround!
	%PlaceholderSprite.material = shader.duplicate()
	%HealthBar.max_value = health
	%HealthBar.value = health

func _process(delta: float) -> void:
	var shader = %PlaceholderSprite.material as ShaderMaterial
	shader.set_shader_parameter("EXTRA_GLOW", current_glow)
	if current_glow > 0.0:
		current_glow -= GLOW_STEP * delta
		if current_glow < 0.0:
			current_glow = 0.0		

func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * SPEED
	
	var dir_normalized = direction.normalized()
	
	if dir_normalized != Vector2.ZERO:
		%EnemyAnimationTree.set("parameters/Walk/blend_position", dir_normalized)
	
	#move_and_collide(velocity * delta)
	move_and_slide()

func take_damage(dmg: int) -> void:
	health -= dmg
	current_glow = MAX_GLOW;
	var shader = %PlaceholderSprite.material as ShaderMaterial
	shader.set_shader_parameter("EXTRA_GLOW", current_glow)
	%HealthBar.value = health
	
	if health <= 0:
		Events.emit_signal("enemy_died")
		queue_free()

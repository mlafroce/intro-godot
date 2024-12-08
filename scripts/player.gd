extends CharacterBody2D

signal health_depleted

const SPEED = 350
const MAX_HEALTH: float = 100.0
const HEALING_RATE = 1.0
const DMG_RATE = 20.0
const MAX_INVULNERABLE_ON_DMG = 1.0

var time = 0.0
var amplitude = 8.0
var frequency = 8.0

var amplitude_shadow = 0.125

var health: float = MAX_HEALTH
var invulnerable_time: float = 0.0

@onready var default_pos = %MaguitoSketch.get_position()

func _process(delta: float) -> void:
	time += delta * frequency
	
	%MaguitoSketch.set_position(default_pos + Vector2(0, sin(time) * amplitude))
	
	%Sombra.scale = Vector2(0.963, 0.697) + Vector2(sin(time) * amplitude_shadow, sin(time) * amplitude_shadow)
	if self.invulnerable_time > 0:
		self.invulnerable_time -= delta
		if self.invulnerable_time < 0:
			self.invulnerable_time = 0
		var factor = self.invulnerable_time / MAX_INVULNERABLE_ON_DMG
		self.set_shader_property("DAMAGED", factor)
		
	if health <= MAX_HEALTH:
		health += HEALING_RATE * delta
	if Input.is_action_just_pressed("change_weapon"):
		%Wand.changeWeapon()
		
	if Input.is_action_just_pressed("shoot_wand"):
		%Wand.shoot()

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * SPEED
	
	var dir_normalized = direction.normalized()
	
	if dir_normalized != Vector2.ZERO:
		%PlayerAnimationTree.set("parameters/Idle/blend_position", dir_normalized)
		
	move_and_collide(velocity * delta)
	
	var overlapping_enemies = %HurtBox.get_overlapping_bodies()
	
	if !overlapping_enemies.is_empty():
		take_damage(overlapping_enemies.size() * DMG_RATE)
		
func take_damage(damage: float):
	if self.invulnerable_time > 0:
		return
		
	health -= damage
	Events.emit_signal("player_took_damage", damage)
	
	self.invulnerable_time = MAX_INVULNERABLE_ON_DMG
	set_shader_property("DAMAGED", 1.0)
	if health <= 0.0:
		health_depleted.emit()

func set_shader_property(key: String, value):
	var shader = %MaguitoSketch.material as ShaderMaterial
	shader.set_shader_parameter(key, value)
	
func get_bullet_progress():
	return %Wand.bullet_shooter.get_bullet_progress()

func get_laser_progress():
	return %Wand.laser_shooter.get_bullet_progress()

extends Area2D

@onready var default_pos = %WandSprite.get_position()

enum WeaponMode { BULLET, LASER }

var bullet_shooter
var laser_shooter

var time = 0.0
var amplitude = 4.0
var frequency = 8.0

var currentWeapon = WeaponMode.BULLET

class BulletShooter:
	const SHOOTING_TIME = 0.3
	var remaining_time = 0
	var wand: Sprite2D
	var shooting_point: Marker2D
	
	func _init(wand: Sprite2D, shooting_point: Marker2D) -> void:
		self.wand = wand
		self.shooting_point = shooting_point
	
	func _process(delta):
		if remaining_time > 0:
			self.remaining_time -= delta
			if remaining_time < 0:
				remaining_time = 0
	
	func shoot():
		if remaining_time != 0:
			return
		self.remaining_time = SHOOTING_TIME
		self.wand.scale = Vector2(0.650, 0.3)
	
		const BULLET = preload("res://scenes/bullet.tscn")
		
		var new_bullet = BULLET.instantiate()
		
		new_bullet.global_position = self.shooting_point.global_position
		new_bullet.global_rotation = self.shooting_point.global_rotation
		
		self.shooting_point.add_child(new_bullet)
	
	func can_autoshoot() -> bool:
		return self.remaining_time == 0
	
	func get_bullet_progress():
		return 1 - (self.remaining_time / SHOOTING_TIME)

class LaserShooter:
	const SHOOTING_TIME = 2
	var remaining_time = 0
	var wand: Sprite2D
	var shooting_point: Marker2D
	
	func _init(wand: Sprite2D, shooting_point: Marker2D) -> void:
		self.wand = wand
		self.shooting_point = shooting_point
	
	func _process(delta):
		if remaining_time > 0:
			self.remaining_time -= delta
			if remaining_time < 0:
				remaining_time = 0
	
	func shoot():
		if remaining_time != 0:
			return
		self.remaining_time = SHOOTING_TIME
		self.wand.scale = Vector2(0.650, 0.3)
	
		const LASER = preload("res://scenes/laserbeam.tscn")
		
		var new_bullet = LASER.instantiate()
		new_bullet.position = self.shooting_point.get_global_position()
		new_bullet.rotation = self.shooting_point.get_global_rotation()
		
		self.shooting_point.add_child(new_bullet)
	
	func can_autoshoot() -> bool:
		return false
	
	func get_bullet_progress():
		return 1 - (self.remaining_time / SHOOTING_TIME)

func _ready() -> void:
	self.bullet_shooter = BulletShooter.new(%WandSprite, %ShootingPoint)
	self.laser_shooter = LaserShooter.new(%WandSprite, %ShootingPoint)

func _process(delta: float) -> void:
	%WandSprite.scale.x = move_toward(%WandSprite.scale.x, 0.455, 3 * delta)
	%WandSprite.scale.y = move_toward(%WandSprite.scale.y, 0.455, 3 * delta)
	self.bullet_shooter._process(delta)
	self.laser_shooter._process(delta)
	self.auto_shoot()

func auto_shoot():
	if self.bullet_shooter.can_autoshoot() \
		and currentWeapon == WeaponMode.BULLET \
		and !get_overlapping_bodies().is_empty():
		self.bullet_shooter.shoot()

func _physics_process(delta: float) -> void:
	var enemies_in_range: Array[Node2D] = get_overlapping_bodies()
	time += delta * frequency

	if !enemies_in_range.is_empty() and currentWeapon == WeaponMode.BULLET:
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

func changeWeapon() -> void:
	currentWeapon = (currentWeapon + 1) % WeaponMode.size()

func shoot():
	if currentWeapon == WeaponMode.LASER:
		self.laser_shooter.shoot()
		

class_name Weapon

extends Node

enum WeaponMode { BULLET, LASER }

const simpleBulletScene = preload("res://scenes/player/simpleBullet.tscn")
const laserScene = preload("res://scenes/player/laserBullet.tscn")
var currentWeapon;
var currentWeaponMode : WeaponMode;

# Called when the node enters the scene tree for the first time.
func _init() -> void:
	currentWeaponMode = WeaponMode.BULLET;
	self.updateWeapon(WeaponMode.BULLET) # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func rotateWeapon() -> void:
	currentWeaponMode = (currentWeaponMode + 1) % WeaponMode.size()
	updateWeapon(currentWeaponMode)

func updateWeapon(weaponMode: WeaponMode) -> void:
	if weaponMode == WeaponMode.BULLET:
		currentWeapon = BulletWeapon.new()
	elif weaponMode == WeaponMode.LASER:
		currentWeapon = LaserWeapon.new()

func shoot(delta:float, player: Player) -> void:
	if currentWeapon.curDelay <= 0:
		currentWeapon.shoot(player)
		currentWeapon.curDelay = currentWeapon.weaponDelay
	else:
		currentWeapon.curDelay -= delta

class BulletWeapon:
	const weaponDelay: float = 0.2
	var curDelay: float = 0.0
	
	func shoot(player) -> void:
		var bullet = simpleBulletScene.instantiate()
		player.add_sibling(bullet)
		bullet.position = player.position
		bullet.direction = player.last_direction

class LaserWeapon:
	const weaponDelay: float = 1.0
	var curDelay: float = 0.0
	
	func shoot(player) -> void:
		var bullet = laserScene.instantiate()
		player.add_sibling(bullet)
		bullet.position = player.position
		bullet.direction = player.last_direction
		if bullet.direction.y == 0:
			bullet.rotate(PI / 2)
		elif bullet.direction.x != 0:
			var angleSign = -bullet.direction.x / bullet.direction.y
			bullet.rotate(angleSign * PI / 4)

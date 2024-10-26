class_name Player

extends Area2D
signal hit

const Weapon = preload("res://scripts/player/weapon.gd")

@export var speed = 200
var screen_size
var last_direction = Vector2(1, 0)
var weapon = Weapon.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()
	$PlayerSprite.animation = "idle"
	$PlayerSprite.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO # The player's movement vector.
	if get_node("PlayerSprite").animation == "death":
		return

	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		$PlayerSprite.flip_h = false
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
		$PlayerSprite.flip_h = true
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
	if Input.is_key_pressed(KEY_SPACE):
		weapon.shoot(self)

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		self.last_direction = velocity
		$PlayerSprite.animation = "move"
	else:
		$PlayerSprite.animation = "idle"
	$PlayerSprite.play()
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)


func _on_body_entered(body: Node2D) -> void:
	print("HIT")
	get_node("PlayerSprite").play("death")
	await get_node("PlayerSprite").animation_finished
	hide() # Player disappears after being hit.
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$PlayerCollisionShape.set_deferred("disabled", true)
	
func start(pos):
	position = pos
	show()
	$PlayerCollisionShape.disabled = false
	

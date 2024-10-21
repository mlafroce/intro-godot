extends Area2D
signal hit

@export var speed = 200
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()
	$AnimatedSprite2D.animation = "idle"
	$AnimatedSprite2D.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
	if Input.is_action_just_pressed("move_right"):
		$AnimatedSprite2D.animation = "tilt_right"
		$AnimatedSprite2D.play()
	if Input.is_action_just_released("move_right"):
		$AnimatedSprite2D.animation = "tilt_right"
		$AnimatedSprite2D.play_backwards()
	if Input.is_action_just_pressed("move_left"):
		$AnimatedSprite2D.animation = "tilt_left"
		$AnimatedSprite2D.play()
	if Input.is_action_just_released("move_left"):
		$AnimatedSprite2D.animation = "tilt_left"
		$AnimatedSprite2D.play_backwards()
		

	if $AnimatedSprite2D.animation_finished:
		if velocity.x == 0 and $AnimatedSprite2D.animation != "idle" and $AnimatedSprite2D.animation_finished:
			$AnimatedSprite2D.animation = "idle"
			$AnimatedSprite2D.play()
		elif velocity.x > 0 and $AnimatedSprite2D.animation != "right":
			$AnimatedSprite2D.animation = "right"
			$AnimatedSprite2D.play()
		elif velocity.x < 0 and $AnimatedSprite2D.animation != "left":
			$AnimatedSprite2D.animation = "left"
			$AnimatedSprite2D.play()
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)


func _on_body_entered(body: Node2D) -> void:
	hide() # Player disappears after being hit.
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

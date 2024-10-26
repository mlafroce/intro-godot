class_name Bullet

extends Area2D

var BULLET_SPEED: float = 3

@onready var visible_notifier = $VisibleNotifier as VisibleOnScreenNotifier2D
@export var direction = Vector2.ZERO

func _ready() -> void:
	visible_notifier.connect("screen_exited", on_screen_exited)
	body_entered.connect(on_body_entered)

func _physics_process(delta: float) -> void:
	move(delta)

func on_body_entered(body: Node2D):
	if body.has_method("hit") and body.visible: 
		if body.hit():
			queue_free()

func move(delta: float):
	position += self.direction * delta * BULLET_SPEED

func on_screen_exited():
	queue_free()

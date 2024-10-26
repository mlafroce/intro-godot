class_name Zombie

extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var collider = $CollisionShape2D
@onready var hp = 10

var animations = ["up", "rup", "right", "rdown", "down"]
var idx = 0
var direction = 1

func update_animation():
	idx += 1 * direction
	if idx == 4:
		direction = -1
		sprite.flip_h = !sprite.flip_h
	elif idx == 0:
		direction = 1
	sprite.animation = animations[idx]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(sprite)
	sprite.play("up")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func hit():
	hp -= 1
	if hp == 0:
		hide()

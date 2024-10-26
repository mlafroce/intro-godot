class_name Scenario

extends Node2D

@onready var player = $Spaceship as Spaceship
@onready var timer = $Timer as Timer
#@onready var zombie: Zombie = preload("res://zombie.tscn").instantiate() as Zombie
@onready var zombie: Zombie = $Zombie as Zombie

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_SPACE):
		shoot( )

func shoot() -> void:
	var bullet = preload("res://bullet.tscn").instantiate()
	add_child(bullet)
	bullet.position = self.player.position;

func _on_timer_timeout() -> void:
	zombie.update_animation()

class_name Weapon

extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func shoot(player: Player) -> void:
	var bullet = preload("res://scenes/player/bullet.tscn").instantiate()
	player.add_sibling(bullet)
	bullet.position = player.position
	bullet.direction = player.last_direction

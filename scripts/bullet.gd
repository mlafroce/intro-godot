extends Area2D

var travelled_distance = 0
const SPEED = 1000
const MAX_RANGE = 1200
const DMG = 1

func _physics_process(delta: float) -> void:
	var direction: Vector2 = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta

	travelled_distance += SPEED * delta
	if travelled_distance > MAX_RANGE:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	queue_free()
	
	if body.has_method("take_damage"):
		body.take_damage(DMG)

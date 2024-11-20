extends Area2D

var travelled_distance = 0
const SPEED = 1000
const MAX_RANGE = 1200

func _physics_process(delta: float) -> void:
	var direction: Vector2 = Vector2.RIGHT.rotated(rotation)
	#position += direction * SPEED * delta

	#travelled_distance += SPEED * delta
	if travelled_distance > MAX_RANGE:
		queue_free()


func _on_area_entered(area: Area2D) -> void:
	queue_free()
	
	if area.has_method("take_damage"):
		area.take_damage()

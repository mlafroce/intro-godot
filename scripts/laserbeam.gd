extends Area2D

var travelled_distance = 0
const SPEED = 1000
const MAX_RANGE = 1200
const DMG = 3

func _physics_process(delta: float) -> void:
	var direction: Vector2 = Vector2.RIGHT.rotated(rotation)
	position = get_parent().get_global_position()
	self.look_at(get_global_mouse_position())

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
			body.take_damage(DMG)

func _on_timer_timeout() -> void:
	queue_free()

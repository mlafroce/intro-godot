extends RigidBody2D

@onready var player = get_tree().get_root().find_child("Player",true,false)
var screen_size
var velocity
const LINEAR_VELOCITY = 45
const VELOCITY_VARIATION = .08
var velocity_variation

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	$ZombieManSprite.play()
	velocity = Vector2.ZERO
	velocity_variation = randf_range(1 - VELOCITY_VARIATION, 1 + VELOCITY_VARIATION)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity = position.direction_to(player.position) * LINEAR_VELOCITY
	# Apply a 4% velocity disparity.
	velocity *= velocity_variation
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	if velocity.x > 0:
		$ZombieManSprite.flip_h = false
	elif velocity.x < 0:
		$ZombieManSprite.flip_h = true


func _on_zombie_man_visible_on_screen_notifier_screen_exited() -> void:
	hide()
	queue_free()

#func _on_player_death_body_entered(body):
	#if body.name == "Bullet":
		#get_node("ZombieManSprite").play("death")
		#await get_node("ZombieManSprite").animation_finished
		#self.queue_free()
	

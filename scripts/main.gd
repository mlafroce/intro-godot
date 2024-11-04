extends Node

@export var enemy_scene: PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func game_over() -> void:
	#$ScoreTimer.stop()
	$EnemyTimer.stop()

func new_game():
	score = 0
	get_node("Player").start($StartPosition.position)
	$StartTimer.start()


func _on_enemy_timer_timeout() -> void:
	for i in range(30):
		# Create a new instance of the enemy scene.
		var zombie = enemy_scene.instantiate()
		# Choose a random location on Path2D.
		var enemy_spawn_location = $EnemyPath/EnemySpawnLocation
		enemy_spawn_location.progress_ratio = randf()

		# Set the zombie's position to a random location.
		zombie.position = enemy_spawn_location.position

		# Spawn the zombie by adding it to the Main scene.
		add_child(zombie)


func _on_start_timer_timeout() -> void:
	_on_enemy_timer_timeout()
	$EnemyTimer.start()

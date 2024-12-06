extends Control

var score = 0

func _ready() -> void:
	Events.changed_weapon.connect(_on_change_weapon)
	Events.enemy_died.connect(_on_enemy_died)
	Events.player_took_damage.connect(_on_player_took_damage)
	
	%Score.text = "Score: " + str(score)
	%PlayerHealth.value = 100.0

func _on_change_weapon(currentWeapon) -> void:
	%Selector.frame = currentWeapon
	print(currentWeapon)
	
func _on_enemy_died() -> void:
	score+=10
	%Score.text = "Score: " + str(score)

func _on_player_took_damage(damage) -> void:
	%PlayerHealth.value -= damage

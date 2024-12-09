extends Control

func set_bullet_progress(progress: float):
	%BulletBar.value = progress * 100
	
func set_laser_progress(progress: float):
	%LaserBar.value = progress * 100

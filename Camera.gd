extends Camera3D

func _process(delta):
	look_at(%Player.transform.origin)

extends CharacterBody3D

@export var rot_speed := 3.0
@export var speed := 5.0

func _ready():
	set_physics_process(false)

func _physics_process(delta):
	var rot_amt = Input.get_action_strength("1") - Input.get_action_strength("3")
	rotate_y(deg2rad(rot_speed * delta * rot_amt))
	$cam_rig.rotate_y(deg2rad(rot_speed * delta * rot_amt))

	if Input.is_action_pressed("2"):
		velocity = -global_transform.basis.z * speed;
		move_and_slide()
extends CharacterBody3D

@export var rot_speed := 3.0
@export var speed := 5.0
@export var ghost_ship := false

@onready var timer: Timer = $Timer
@onready var ghost_tween

var past_positions := []

func _ready():
	if ghost_ship:
		ghost_tween = create_tween().bind_node(self)
		ghost_tween.set_parallel(true)
		for p in past_positions:
			print(past_positions)
			var chain = ghost_tween.chain()
			var rot = p.get("rotation")
			var pos = p.get("position")
			chain.tween_property(
				self,
				"global_position",
				pos,
				1
			) 
			chain.tween_property(
				self,
				"rotation",
				rot,
				1
			) 

	if not ghost_ship:
		timer.timeout.connect(record_position)
		timer.start()

func record_position():
	print("saved position")
	past_positions.push_back({"position": global_position, "rotation": rotation})
	timer.start()

func ghost_update(delta: float) -> void:
	pass

func _physics_process(delta):
	if ghost_ship:
		ghost_update(delta)
		return

	var rot_amt = Input.get_action_strength("1") - Input.get_action_strength("3")
	rotate_y(deg2rad(rot_speed * delta * rot_amt))
	$cam_rig.rotate_y(deg2rad(rot_speed * delta * rot_amt))

	if Input.is_action_pressed("2"):
		velocity = -global_transform.basis.z * speed;
		move_and_slide()

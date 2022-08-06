extends Node

@onready var player: Node3D = get_tree().get_first_node_in_group("player")
@export var rot_speed = 20

var overworld_state := {
	"p_update": func(delta):
		var rot_amt = Input.get_action_strength("1") - Input.get_action_strength("3")
		player.rotate_y(deg2rad(rot_speed * delta * rot_amt))
}

var current_state = overworld_state

func _input(event: InputEvent) -> void:
	var input = current_state.get("input")
	if input is Callable:
		input.call(event)

func _process(delta):
	var update = current_state.get("update")
	if update is Callable:
		update.call(delta)

func _physics_process(delta):
	var p_update = current_state.get("p_update")
	if p_update is Callable:
		p_update.call(delta)

extends Node3D

@onready var player: Node3D = get_tree().get_first_node_in_group("player")
@export var follow_speed = 10

func _process(delta):
	var orig := player.global_transform.origin

	global_transform.origin = global_transform.origin.lerp(orig, follow_speed * delta)
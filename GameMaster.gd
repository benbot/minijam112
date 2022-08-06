extends Node

@onready var player: CharacterBody3D = get_tree().get_first_node_in_group("player")
@export var rot_speed = 20
@export var speed = 20

var overworld_state := {
	"name": "ow",
	"enter": func(): 
		player.set_physics_process(true),
	"exit": func():
		player.set_physics_process(false)
}

var combat_state := {
	"name": "combat"
}

var current_state = combat_state#{}

func change_state_to(state: Dictionary):
	var new_state = state.duplicate()
	var exit = current_state.get("exit")
	if exit is Callable:
		exit.call()

	var enter = new_state.get("enter")
	if enter is Callable:
		enter.call()

	current_state = new_state

func _input(event: InputEvent) -> void:
	var input = current_state.get("input")
	if input is Callable:
		input.call(event)

func _process(delta):
	if current_state.get("name") == null:
		change_state_to(overworld_state)
	var update = current_state.get("update")
	if update is Callable:
		update.call(delta)

func _physics_process(delta):
	var p_update = current_state.get("p_update")
	if p_update is Callable:
		p_update.call(delta)

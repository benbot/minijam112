extends Node

@onready var player: CharacterBody3D = get_tree().get_first_node_in_group("player")
@export var rot_speed = 20
@export var speed = 20

var overworld_state := {
	"name": "ow",
	"enter": func(): 
		player.process_mode = Node.PROCESS_MODE_ALWAYS,
	"exit": func():
		player.process_mode = Node.PROCESS_MODE_DISABLED
}

var battle := preload("res://battle/battle.tscn")
var combat_state := {
	"name": "combat",
	"enter": func(): 
		%battle_control.visible = true
		%battle_view.add_child(battle.instantiate()),
	"exit": func(): 
		%battle_view.get_child(0).queue_free()
		%battle_control.visible = false,
}

var current_state = {}

func _ready():
	for i in get_tree().get_nodes_in_group("islands"):
		if i.has_signal("open_battle"):
			i.open_battle.connect(func(): change_state_to(combat_state))

func change_state_to(state: Dictionary):
	var new_state = state.duplicate()
	var exit = current_state.get("exit")
	if exit is Callable:
		exit.call()

	var enter = new_state.get("enter")
	if enter is Callable:
		enter.call()

	current_state = new_state

var player_scene := preload("res://player/PlayerCharacter.tscn")
@onready var initial_pos := player.global_position
func _input(event: InputEvent) -> void:
	var input = current_state.get("input")
	if input is Callable:
		input.call(event)
	if event is InputEventKey:
		if event.keycode == KEY_SPACE and not event.is_pressed():
			var nship = player_scene.instantiate()
			nship.remove_from_group("player")
			nship.ghost_ship = true
			nship.past_positions = player.past_positions
			nship.process_mode = Node.PROCESS_MODE_ALWAYS
			get_tree().root.get_child(0).add_child(nship)
			nship.global_position = initial_pos

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

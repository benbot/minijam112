extends Node

var current_state = {
	"input" = func(e):
		if e.is_action("1"):
			pass
		elif e.is_action("2"):
			pass
		elif e.is_action("3"):
			pass
}

func _input(event: InputEvent) -> void:
	var input = current_state.get("input")
	if input is Callable:
		input.call(event)

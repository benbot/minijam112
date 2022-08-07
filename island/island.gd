extends Area3D

@export var treasure := 100

signal open_battle

# Called when the node enters the scene tree for the first time.
func _ready():
	self.body_entered.connect(_on_player_enter)

func _on_player_enter(b: CollisionObject3D):
	if b.is_in_group("player"):
		emit_signal("open_battle")

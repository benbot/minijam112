extends Node2D

@export var speed := 1
@onready var player: CharacterBody2D = %player
@onready var target: Area2D = %target
@onready var startpoint: Node2D = $start
@onready var endpoint: Node2D = $end

@onready var player_sprite: AnimatedSprite2D = $playerSprite
@onready var enemy_sprite: AnimatedSprite2D = $enemySprite

@onready var tween := get_tree().create_tween().bind_node(self)

var target_overlap := false
var can_attack = true

func _set_target_overlap(_body: CollisionObject2D, value: bool) -> void:
	target_overlap = value

func _ready():
	target.body_entered.connect(_set_target_overlap.bind(true))
	target.body_exited.connect(_set_target_overlap.bind(false))
	player.global_position = startpoint.global_position
	tween.set_loops()
	tween.tween_property(player, "global_position", endpoint.global_position, speed)
	tween.tween_property(player, "global_position", startpoint.global_position, speed)

func _physics_process(delta):
	if Input.is_action_just_pressed("2") and can_attack:
		if target_overlap:
			player_sprite.play("ATTACK")
			enemy_sprite.play("HIT")
			await enemy_sprite.animation_finished
			enemy_sprite.play("IDLE")
			player_sprite.play("IDLE")
			can_attack = true
		else:
			enemy_sprite.play("ATTACK")
			player_sprite.play("HIT")
			await player_sprite.animation_finished
			enemy_sprite.play("IDLE")
			player_sprite.play("IDLE")
			can_attack = true


extends Area2D

@onready var anim_player = $AnimationPlayer
@onready var default_player = $DefaultPlayer

func _ready():
	default_player.play("idle")

func _on_body_entered(body):
	if body is Player:
		anim_player.play("stepped_grass")

func _on_body_exited(body):
	if body is Player:
		pass

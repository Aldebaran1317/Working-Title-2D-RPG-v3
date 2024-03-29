extends CharacterBody2D

class_name Player

signal player_moving_signal
signal player_stopped_signal

@export var walk_speed = 4.0
const TILE_SIZE = 16

@onready var anim_tree = $AnimationTree
@onready var anim_state = anim_tree.get("parameters/playback")
@onready var ray = $RayCast2D
@onready var front_check_box = $FrontCheck

enum PlayerState { IDLE, TURNING, WALKING }
enum FacingDirection { LEFT, RIGHT, UP, DOWN }

var player_state = PlayerState.IDLE
var facing_direction = FacingDirection.DOWN

var initial_position = Vector2(0, 0)
var input_direction = Vector2(0, 0)
var is_moving = false
var percent_moved_to_next_tile = 0.0

var can_interact = false
var interactive_object

func _ready():
	anim_tree.active = true
	initial_position = position

func _physics_process(delta):
	if player_state == PlayerState.TURNING:
		return
	elif is_moving == false:
		process_player_input()
	elif input_direction != Vector2.ZERO:
		anim_state.travel("Walk")
		move(delta)
	else:
		anim_state.travel("Idle")
		is_moving = false

func change_front_check_position(dir):
	match dir:
		Vector2.UP:
			front_check_box.position = Vector2(0, -32)
			print_debug("up")
		Vector2.RIGHT:	
			front_check_box.position = Vector2(16, -16)
			print_debug("right")
		Vector2.DOWN:	
			front_check_box.position = Vector2(0, 0)
			print_debug("down")
		Vector2.LEFT:	
			front_check_box.position = Vector2(-16, -16)
			print_debug("left")

func process_player_input():
	if input_direction.y == 0:
		input_direction.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	if input_direction.x == 0:
		input_direction.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	if input_direction != Vector2.ZERO:
		anim_tree.set("parameters/Idle/blend_position", input_direction)
		anim_tree.set("parameters/Walk/blend_position", input_direction)
		anim_tree.set("parameters/Turn/blend_position", input_direction)
		change_front_check_position(input_direction)
		if need_to_turn():
			player_state = PlayerState.TURNING
			anim_state.travel("Turn")
		else:
			initial_position = position
			is_moving = true
	else:
		anim_state.travel("Idle")
		if can_interact && Input.is_action_just_pressed("ui_accept"):
			interactive_object.interact()
			print_debug("Just interacted!")

func need_to_turn():
	var new_facing_direction
	if input_direction.x < 0:
		new_facing_direction = FacingDirection.LEFT
	elif input_direction.x > 0:
		new_facing_direction = FacingDirection.RIGHT
	elif input_direction.y < 0:
		new_facing_direction = FacingDirection.UP
	elif input_direction.y > 0:
		new_facing_direction = FacingDirection.DOWN
	if facing_direction != new_facing_direction:
		facing_direction = new_facing_direction
		return true
	else:
		facing_direction = new_facing_direction
		return false

func finished_turning():
	player_state = PlayerState.IDLE

func move(delta):
	var desired_step: Vector2 = input_direction * TILE_SIZE / 2
	ray.target_position = desired_step
	ray.force_raycast_update()
	if !ray.is_colliding():
		if percent_moved_to_next_tile == 0:
			emit_signal("player_moving_signal")
		percent_moved_to_next_tile += walk_speed * delta
		if percent_moved_to_next_tile >= 1.0:
			position = initial_position + (TILE_SIZE * input_direction)
			percent_moved_to_next_tile = 0.0
			is_moving = false
			emit_signal("player_stopped_signal")
		else:
			position = initial_position + (TILE_SIZE * input_direction * percent_moved_to_next_tile)
	else:
		percent_moved_to_next_tile = 0.0
		is_moving = false


func _on_front_check_body_entered(body):
	if body.has_method("interact"):
		can_interact = true
		interactive_object = body
		print_debug("Interactive object here")


func _on_front_check_body_exited(body):
	if body.has_method("interact"):
		can_interact = false
		interactive_object = null
		print_debug("Leaving interactive object")

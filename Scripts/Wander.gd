class_name WanderState
extends State

@export var actor: Bro
@export var animator: AnimatedSprite2D

var maximum_walk_distance = 600
var minimum_walk_distance = 80
var target_position = Vector2.ZERO
var direction = 1
@onready var position = actor.position
@onready var positionx = actor.position.x
@onready var positiony = actor.position.y
var process = false

func _enter_state():
	var exclusion = 100
	if Global.treecount == 0:
		target_position = Vector2(randi_range(200, 600), actor.position.y)
	else:
		target_position = Vector2(randi_range(200, Global.treecount * Global.x_spacing + 300), actor.position.y)
	print("target_position: ", target_position)
	if  actor.position.distance_to(target_position) <= exclusion:
		print("in range")
		target_position = actor.position
		process = true
		direction = $"../../AnimatedSprite2D".scale.x
	else:
		print("not in range")
		direction = sign(target_position.x - actor.position.x)
		if direction ==0:
			direction = $"../../AnimatedSprite2D".scale.x
		$"../../AnimatedSprite2D".scale.x = direction
		animator.play("Walking")
		process = true
		


func _exit_state():
	process = false
	
func _process(delta):
	if not process:
		return
	if actor.position.distance_to(target_position) < 5:
		Global.emit_signal("exit_wander")
	var velocity = direction * Global.walk_speed
	actor.position += Vector2(velocity, 0)

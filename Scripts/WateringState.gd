class_name WateringState
extends State

@export var actor: Bro
@export var animator: AnimatedSprite2D

@onready var position = actor.position
@onready var positionx = actor.position.x
@onready var positiony = actor.position.y

var process = false
var tree : int
var direction = 1
var target_position = Vector2.ZERO

func _ready():
	Global.connect("watering", _treenumber)

func _enter_state():
	target_position = Vector2((tree+1) * Global.x_spacing - 95, actor.position.y)
	direction = sign(target_position.x - actor.position.x)
	print(target_position.x," actor: ", actor.position.x)
	if direction ==0:
		direction = 1
	$"../../AnimatedSprite2D".scale.x = direction
	if actor.position.distance_to(target_position) < 45:
		water_tree()
		return
	animator.play("Walking")
	process = true
	
func water_tree():
	process = false
	animator.play("Watering")
	await animator.animation_finished
	Global.emit_signal("growing_animation", tree)
	Global.emit_signal("exit_watering")

func _treenumber(tree_number):
	tree = tree_number

func _exit_state():
	Global.paused = false
	process = false
	
func _process(delta):
	if not process:
		return
	if actor.position.distance_to(target_position) < 45:
		water_tree()
	var velocity = direction * Global.walk_speed
	actor.position += Vector2(velocity, 0)
	print("target: ", target_position, "actor: ", actor.position)



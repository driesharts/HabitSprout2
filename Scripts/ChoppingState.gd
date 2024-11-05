extends State
class_name ChoppinState

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
	Global.connect("chopping", _treenumber)

func _enter_state():
	target_position = Vector2((tree+1) * Global.x_spacing - 95, actor.position.y)
	direction = sign(target_position.x - actor.position.x)
	if direction ==0:
		direction = 1
	$"../../AnimatedSprite2D".scale.x = direction
	if actor.position.distance_to(target_position) < 45:
		found_tree()
		return
	animator.play("Walking")
	process = true

func _treenumber(tree_number):
	tree = tree_number

func _exit_state():
	Global.paused = false
	process = false
	
func found_tree():
	process = false
	animator.play("Chopping")
	await animator.animation_finished
	Global.all_tree_data.erase(tree)
	Global.emit_signal("reset_trees", tree)
	Global.emit_signal("chop", tree)
	
func _process(delta):
	if not process:
		return
	if actor.position.distance_to(target_position) < 45:
		found_tree()
	var velocity = direction * Global.walk_speed
	actor.position += Vector2(velocity, 0)
	print(target_position, actor.position)


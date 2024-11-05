class_name IdleState
extends State

@export var actor: Bro
@export var animator: AnimatedSprite2D

var idle_min_duration = 5
var idle_max_duration = 20
var idle_timer = 0
var process = false

func _enter_state():
	idle_timer = randf_range(idle_min_duration, idle_max_duration)
	process = true
	animator.play("Idle")

func _exit_state():
	process = false

func _process(delta):
	if not process:
		return
	idle_timer -= delta
	if idle_timer <= 0:
		Global.emit_signal("exit_idle")

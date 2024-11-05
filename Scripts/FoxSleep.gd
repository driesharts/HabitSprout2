class_name FoxSleep
extends State

@export var actor: Fox
@export var animator: AnimatedSprite2D

var sleep_min_duration = 20
var sleep_max_duration = 60
var sleep_timer = 0
var process = false

func _enter_state():
	sleep_timer = randf_range(sleep_min_duration, sleep_max_duration)
	process = true
	animator.play("Sleeping")

func _exit_state():
	process = false

func _process(delta):
	if not process:# or Global.current_time > 21:
		return
	sleep_timer -= delta
	if sleep_timer <= 0:
		Global.emit_signal("exit_sleepingf")

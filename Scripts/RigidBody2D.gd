extends RigidBody2D

var initial_force = Vector2(randi_range(-120,120), -300)
var move = false
var speed = 20

func _ready():
	apply_central_impulse(initial_force)

func _on_body_entered(body):
	linear_velocity.y *= -1

func _process(delta):
	if move:
		var screensize = DisplayServer.screen_get_size()
		var direction = (Vector2(screensize.x, -565) - position).normalized()
		gravity_scale = 0
		apply_central_force(direction)





func _on_timer_timeout():
	move = true

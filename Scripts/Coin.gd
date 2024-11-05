extends RigidBody2D

var move = false
var coin_position = Vector2(0,0)
var max_speed = 600

func _ready():
	Global.connect("camera_position", current_coin_position)

func _on_body_entered(body):
	linear_velocity.y *= -1

func _process(delta):
	if move:
		var direction = coin_position - global_position
		var distance = direction.length()
		var desired_velocity = direction.normalized() * max_speed
		var steering = desired_velocity - linear_velocity
		var acceleration = steering.normalized() * min(steering.length(), max_speed)
		linear_velocity += 5 * acceleration * delta


func current_coin_position(new_position):
	coin_position = new_position

func _on_timer_timeout():
	gravity_scale = 0
	move = true

func _on_add_to_total_timeout():
	Global.coincount += 1
	Global.emit_signal("add_coin")
	queue_free()

extends Camera2D

@onready var camera = $"."
@onready var coin = $"../UI/HBoxContainer/Coinimage"
@onready var specialcoin = $"../UI/HBoxContainer/TextureRect"

var camera_speed = 1100
var moving_right = false
var moving_left = false
var moving_down = false
var moving_up = false


var camera_min_x = 0  # Minimum X-coordinate for the camera
var camera_max_x = 8000  # Maximum X-coordinate for the camera
var camera_min_y = 0  # Minimum Y-coordinate for the camera
var camera_max_y = 0  # Maximum Y-coordinate for the camera


func _process(delta):
	#could probably be made more efficient
	Global.emit_signal("camera_position", coin.global_position + camera.offset + Vector2(55, 55))
	Global.emit_signal("special_camera_position", specialcoin.global_position + camera.offset + Vector2(55, 55))
	Global.emit_signal("actual_position", floor(camera.offset))
	if moving_right:
		camera.offset.x += camera_speed * delta
	if moving_left:
		camera.offset.x -= camera_speed * delta
	if moving_down:
		camera.offset.y += camera_speed * delta
	if moving_up:
		camera.offset.y -= camera_speed * delta

	# Restrict camera position within boundaries
	camera.offset.x = clamp(camera.offset.x, camera_min_x, camera_max_x)
	camera.offset.y = clamp(camera.offset.y, camera_min_y, camera_max_y)

func _input(event):
	if event is InputEventKey and !Global.camerapaused:
		if event.is_action("ui_right"):
			moving_right = event.pressed
		elif event.is_action("ui_left"):
			moving_left = event.pressed
		elif event.is_action("ui_down"):
			moving_down = event.pressed
		elif event.is_action("ui_up"):
			moving_up = event.pressed

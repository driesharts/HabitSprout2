extends Area2D

var dragging = false
var of : Vector2
var sprite : TextureButton
var camera_of = 0
var type = 2

func _ready():
	Global.connect("actual_position", camera_offset)
	$Control/HBoxContainer/VBoxContainer/FoxPrice.text = str(Global.grassprice)

func camera_offset(new_position):
	camera_of = int(new_position.x)

func _on_mouse_entered():
	if Global.coincount >= Global.grassprice and Global.decorationcount < Global.treecount * 10:
		$Control.scale = Vector2(1.05, 1.05)


func _on_mouse_exited():
	$Control.scale = Vector2(1, 1)


func _process(delta):
	if dragging and Global.dropable:
		sprite.global_position = Vector2((get_global_mouse_position() - of).x, 469)
		sprite.visible = true
	if dragging and !Global.dropable:
		sprite.visible = false



func _on_texture_button_button_down():
	if Global.coincount >= Global.grassprice and Global.decorationcount < Global.treecount * 10:
		dragging = true
		of = get_global_mouse_position() - global_position
		sprite = TextureButton.new()
		sprite.texture_normal = preload("res://Piskel/ProgressBar/grass2.png")
		add_child(sprite)
		sprite.scale = Vector2(4, 4)
		sprite.visible = false

func _on_texture_button_button_up():
	if dragging == true:
		if sprite.visible == true:
			var location = floor(sprite.global_position) + Vector2(camera_of, 0)
			print("spriteposition", sprite.global_position, "camera", camera_of)
			$"../../../../../../../../PlantGrid".plant_decoration(type, location)
			Global.coincount -= Global.grassprice
			Global.emit_signal("add_coin")
		dragging = false
		sprite.queue_free()

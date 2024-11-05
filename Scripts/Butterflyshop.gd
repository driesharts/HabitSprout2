extends Area2D

var dragging = false
var of : Vector2
var sprite : Sprite2D
var butterfly = preload("res://Scenes/butterfly.tscn")
var butterflyprice = Global.butterflyprice
var camera_of = 0

func _ready():
	Global.connect("actual_position", camera_offset)
	$Control/HBoxContainer/VBoxContainer/FoxPrice.text = str(Global.butterflyprice)

func camera_offset(new_position):
	camera_of = new_position.x

func _on_mouse_entered():
	if Global.coincount >= butterflyprice and Global.butterflycount < Global.treecount * 5:
		$Control.scale = Vector2(1.05, 1.05)


func _on_mouse_exited():
	$Control.scale = Vector2(1, 1)


func _process(delta):
	if dragging and Global.dropable:
		sprite.global_position = Vector2((get_global_mouse_position() - of).x, get_global_mouse_position().y)
		sprite.visible = true
	if dragging and !Global.dropable:
		sprite.visible = false



func _on_texture_button_button_down():
	if Global.coincount >= butterflyprice and Global.butterflycount < Global.treecount * 5:
		dragging = true
		of = get_global_mouse_position() - global_position
		sprite = Sprite2D.new()
		sprite.texture = preload("res://Piskel/ProgressBar/bluelogo1.png")
		add_child(sprite)
		sprite.scale = Vector2(4, 4)
		sprite.visible = false


func _on_texture_button_button_up():
	if dragging == true:
		if sprite.visible == true:
			print(camera_of)
			var newbutterfly = butterfly.instantiate()
			newbutterfly.position = sprite.global_position + Vector2(camera_of, 0)
			$"../../../../../../../..".add_child(newbutterfly)
			Global.butterflycount += 1
			Global.coincount -= butterflyprice
			Global.emit_signal("add_coin")
		dragging = false
		sprite.queue_free()


func plant_butterfly():
	var newbutterfly = butterfly.instantiate()
	newbutterfly.position = Vector2(randf_range(150, Global.treecount * Global.x_spacing + 300), randf_range(50, 530))
	$"../../../../../../../..".add_child(newbutterfly)
	Global.butterflycount += 1

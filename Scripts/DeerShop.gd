extends Area2D

var dragging = false
var of : Vector2
var sprite : Sprite2D
var deer = preload("res://Scenes/deer.tscn")
var deerprice = Global.deerprice
var camera_of = 0

func _ready():
	Global.connect("actual_position", camera_offset)
	$Control/HBoxContainer/VBoxContainer/DeerPrice.text = str(Global.deerprice)

func camera_offset(new_position):
	camera_of = new_position.x

func _on_mouse_entered():
	if Global.coincount >= deerprice and Global.deercount < Global.treecount -1:
		$Control.scale = Vector2(1.05, 1.05)


func _on_mouse_exited():
	$Control.scale = Vector2(1, 1)


func _process(delta):
	if dragging and Global.dropable:
		sprite.global_position = Vector2((get_global_mouse_position() - of).x, 495)
		sprite.visible = true
	if dragging and !Global.dropable:
		sprite.visible = false



func _on_texture_button_button_down():
	if Global.coincount >= deerprice and Global.deercount < Global.treecount -1:
		dragging = true
		of = get_global_mouse_position() - global_position
		sprite = Sprite2D.new()
		sprite.texture = preload("res://Piskel/antler3.png")
		add_child(sprite)
		sprite.scale = Vector2(4, 4)
		sprite.visible = false


func _on_texture_button_button_up():
	if dragging == true:
		if sprite.visible == true:
			print(camera_of)
			var newdeer = deer.instantiate()
			newdeer.position = sprite.global_position + Vector2(camera_of, 0)
			$"../../../../../../../..".add_child(newdeer)
			Global.deercount += 1
			Global.coincount -= deerprice
			Global.emit_signal("add_coin")
		dragging = false
		sprite.queue_free()


func plant_deer():
	var newdeer = deer.instantiate()
	newdeer.position = Vector2(randf_range(200, max(Global.treecount * Global.x_spacing + 300, Global.deercount * 400)), 495)
	$"../../../../../../../..".add_child(newdeer)
	Global.deercount += 1

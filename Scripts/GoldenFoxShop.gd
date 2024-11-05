extends Area2D

var dragging = false
var of : Vector2
var sprite : Sprite2D
var fox = preload("res://Scenes/goldenfox.tscn")
var foxprice = Global.goldenfoxprice
var camera_of = 0

func _ready():
	Global.connect("actual_position", camera_offset)
	$Control/HBoxContainer/VBoxContainer/GoldenFoxPrice.text = str(Global.goldenfoxprice)

func camera_offset(new_position):
	camera_of = new_position.x

func _on_mouse_entered():
	if Global.specialcoincount >= foxprice and Global.goldenfoxcount < Global.treecount -1:
		$Control.scale = Vector2(1.05, 1.05)


func _on_mouse_exited():
	$Control.scale = Vector2(1, 1)


func _process(delta):
	if dragging and Global.dropable:
		sprite.global_position = Vector2((get_global_mouse_position() - of).x, 528)
		sprite.visible = true
	if dragging and !Global.dropable:
		sprite.visible = false



func _on_texture_button_button_down():
	if Global.specialcoincount >= foxprice and Global.goldenfoxcount < Global.treecount -1:
		dragging = true
		of = get_global_mouse_position() - global_position
		sprite = Sprite2D.new()
		sprite.texture = preload("res://Piskel/ProgressBar/goldenfox.png")
		add_child(sprite)
		sprite.scale = Vector2(4, 4)
		sprite.visible = false


func _on_texture_button_button_up():
	if dragging == true:
		if sprite.visible == true:
			print(camera_of)
			var newfox = fox.instantiate()
			newfox.position = sprite.global_position + Vector2(camera_of, 0)
			$"../../../../../../../..".add_child(newfox)
			Global.goldenfoxcount += 1
			Global.specialcoincount -= foxprice
			Global.emit_signal("add_special_coin")
		dragging = false
		sprite.queue_free()


func plant_goldenfox():
	var newfox = fox.instantiate()
	newfox.position = Vector2(randf_range(200, max(Global.treecount * Global.x_spacing + 300, Global.foxcount * 400)), 528)
	$"../../../../../../../..".add_child(newfox)
	Global.goldenfoxcount += 1

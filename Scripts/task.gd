extends Label

var coin = preload("res://Scenes/Coin.tscn")
var id = Global.taskcount

func _on_texture_button_pressed():
	#cross
	Global.emit_signal("taskresetting", id)


func _on_texture_button_2_pressed():
	var location = $TextureButton2.global_position
	print(location)
	Global.emit_signal("taskcompletion", id, location)


extends Node2D

@onready var FlowingTap = $TreeTap/Tap
@onready var TapNoWater = $TreeTap/TapnoWater
@onready var GreenTap = $TreeTap/GreenTap
@onready var Sign = $Sign/SignWrite

var Progress = 0

func _ready():
	FlowingTap.visible = false
	GreenTap.visible = false
	$Tree.frame = 0
	$Sign/SignWrite/Information/VBoxContainer/DescriptionInformation.text = Global.tree_name
	$Sign/SignWrite/Information/VBoxContainer/FrequencyInformation.text = Global.tree_frequency
	updatePanelSize()

	
func updatePanelSize():
	var text_width = $Sign/SignWrite/Information/VBoxContainer/DescriptionInformation.get_minimum_size().x
	var label_margin = 10
	var sign_x = text_width + label_margin
	var sign_y = 0
	Sign.set_custom_minimum_size(Vector2(sign_x, sign_y))

func _on_tree_tap_mouse_entered():
	if !FlowingTap.visible:
		GreenTap.visible = true


func _on_tree_tap_mouse_exited():
	if !FlowingTap.visible:
		GreenTap.visible = false


func _on_tree_tap_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed() and not FlowingTap.visible:
				FlowingTap.visible = true
				TapNoWater.visible = false
				GreenTap.visible = false
				Progress += 1
				var trackprogress = floor(Progress/9.42857143)
				$Tree.frame = trackprogress
				print(trackprogress)




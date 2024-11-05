extends Node2D

@onready var FlowingTap = $TreeTap/Tap
@onready var TapNoWater = $TreeTap/TapnoWater
@onready var GreenTap = $TreeTap/GreenTap
@onready var Sign = $Sign/SignWrite
@onready var SignFreq = $Sign/SignWrite/Information/VBoxContainer/FrequencyInformation
@onready var SignDesc = $Sign/SignWrite/Information/VBoxContainer/DescriptionInformation
@onready var EditSlider = $CanvasLayer/EditMenu/VBoxContainer/HSlider
@onready var EditLine = $CanvasLayer/EditMenu/VBoxContainer/LineEdit
@onready var EditText = $CanvasLayer/EditMenu/VBoxContainer/TextEdit


var tree_number = Global.treecount
var width = 0
var coin = preload("res://Scenes/Coin.tscn")
var specialcoin = preload("res://Scenes/special_coin.tscn")
var beam = preload("res://Scenes/streak_beam.tscn")
var streakbeam : Node2D

func _ready():
	if check_streak_finsihed():
		Global.all_tree_data[tree_number]["flowing"] = true
	if check_day_reset():
		if Global.all_tree_data[tree_number]["flowing"] == false:
			if Global.all_tree_data[tree_number]["frequency_value"] == 0:
				Global.all_tree_data[tree_number]["skips"] += 1
		if !check_streak_finsihed():
			Global.all_tree_data[tree_number]["flowing"] = false
		else:
			Global.all_tree_data[tree_number]["flowing"] = true
	if check_streak_reset():
		if Global.all_tree_data[tree_number]["flowing"] == false:
			if !Global.all_tree_data[tree_number]["frequency_value"] == 0:
				Global.all_tree_data[tree_number]["skips"] += progress_increment()
		Global.all_tree_data[tree_number]["streak"] = 0
		Global.all_tree_data[tree_number]["streakarray"] = set_streakarray(Global.all_tree_data[tree_number]["frequency_value"])
		Global.all_tree_data[tree_number]["flowing"] = false
	if Global.all_tree_data[tree_number]["skips"] >= Global.setback:
		#could be more efficient work on this tomorrow
		if Global.all_tree_data[tree_number]["progress"] > 0:
			var setback = int(floor(Global.all_tree_data[tree_number]["skips"]/Global.setback))
			var treename = Global.all_tree_data[tree_number]["tree_name"]
			var tree_node = get_node("/root/Main/PlantGrid/HBoxContainer/" + treename)
			var animation_player = tree_node.get_node("Tree/AnimationPlayer")
			animation_player.play("Shrink")
			Global.all_tree_data[tree_number]["progress"] -= setback
			var trackprogress = floor(Global.all_tree_data[tree_number]["progress"]/9.42857143)
			var progress_frame = tree_node.get_node("Tree")
			progress_frame.frame = int(trackprogress)
			Global.all_tree_data[tree_number]["skips"] -= int(floor(Global.all_tree_data[tree_number]["skips"]/Global.setback))
	initiate_tree()
	set_tree_frame()
	reset_mushrooms()
	Global.connect("growing_animation", _on_growing)
	Global.connect("chop", destroy)
	#$Tree.frame = randi_range(6, 6)
		
func set_width():
	width = ((Global.all_tree_data[tree_number]["streakarray"].size() * -0.5) + 3.5) * 28
	
func set_tree_frame():
	var trackprogress = floor(Global.all_tree_data[tree_number]["progress"]/(Global.completedhabit/7))
	$Tree.frame = trackprogress
	
func initiate_tree():
	$TreeTap/Betterblankflower.visible = false
	$TreeTap/Flower.frame = 0
	EditSlider.value = 0
	EditLine.text = Global.Freq[0]
	if Global.all_tree_data[tree_number]["flowing"] == true:
		$TreeTap/Flower.play("default")
	$CanvasLayer/EditMenu.visible = false
	$Sign/HoverCover.visible = false
	SignDesc.text = Global.all_tree_data[tree_number]["tree_name"]
	SignFreq.text = Global.all_tree_data[tree_number]["tree_frequency"]

func check_completed():
	return Global.all_tree_data[tree_number]["flowing"]
	
func check_day_reset():
	return (Global.current_days > Global.last_days and Global.current_time > Global.reset_time or 
		Global.current_days > Global.last_days and Global.last_time < Global.reset_time or 
		Global.last_time < Global.reset_time and Global.reset_time <= Global.current_time or
		(Global.last_days + 1) < Global.current_days)

func check_streak_reset():
	return (Global.last_weekday < Global.reset_streak and Global.current_weekday >= Global.reset_streak or 
	Global.current_days - Global.last_days >= 7 or
	Global.last_weekday > Global.current_weekday and Global.last_weekday < Global.reset_streak or
	Global.last_weekday > Global.current_weekday and Global.current_weekday >= Global.reset_streak or
	Global.current_weekday == Global.reset_streak and Global.last_weekday == Global.current_weekday and Global.last_time < Global.reset_time and Global.reset_time <= Global.current_time)

func check_streak_finsihed():
	return (Global.all_tree_data[tree_number]["frequency_value"] == 0 and Global.all_tree_data[tree_number]["streak"] >= 7 or
	Global.all_tree_data[tree_number]["frequency_value"] == 1 and Global.all_tree_data[tree_number]["streak"] >= 4 or 
	Global.all_tree_data[tree_number]["frequency_value"] == 2 and Global.all_tree_data[tree_number]["streak"] >= 3 or
	Global.all_tree_data[tree_number]["frequency_value"] == 3 and Global.all_tree_data[tree_number]["streak"] >= 2 or
	Global.all_tree_data[tree_number]["frequency_value"] == 4 and Global.all_tree_data[tree_number]["streak"] >= 1)

func progress_increment():
	if  Global.all_tree_data[tree_number]["frequency_value"] == 0:
		return 1
	if  Global.all_tree_data[tree_number]["frequency_value"] == 1:
		return 2
	if  Global.all_tree_data[tree_number]["frequency_value"] == 2:
		return 3
	if  Global.all_tree_data[tree_number]["frequency_value"] == 3:
		return 3
	if  Global.all_tree_data[tree_number]["frequency_value"] == 4:
		return 4
		
func _on_tree_tap_mouse_entered():
	if !Global.check_paused() and !check_completed():
		$TreeTap/Betterblankflower.visible = true

func _on_tree_tap_mouse_exited():
	$TreeTap/Betterblankflower.visible = false

func _on_tree_tap_pressed():
	if !Global.check_paused()\
	and !check_streak_finsihed()\
	and !check_completed():
		$TreeTap/Betterblankflower.visible = false
		$TreeTap/Flower.play("default")
		Global.paused = true
		Global.emit_signal("watering", tree_number)

	
func draw_dark(x, y):
	var sprite = Sprite2D.new()
	var texture = preload("res://Piskel/ProgressBar/image-1.png (1)-4.png.png")
	sprite.texture = texture
	sprite.position = Vector2(x + 10 + width, y)
	sprite.scale = Vector2(2, 2)
	$Sign/SignWrite/Information/VBoxContainer/FrequencyInformation.add_child(sprite)
	
func draw_light(x, y):
	var sprite = Sprite2D.new()
	var texture = preload("res://Piskel/ProgressBar/image-1.png (1)-3.png.png")
	sprite.texture = texture
	sprite.position = Vector2(x + 10 + width, y)
	sprite.scale = Vector2(2, 2)
	$Sign/SignWrite/Information/VBoxContainer/FrequencyInformation.add_child(sprite)
	
func paint_mushrooms():
	var array = Global.all_tree_data[tree_number]["streakarray"]
	for i in range(array.size()):
			if array[i] == 1:
				print("drawn light")
				draw_light(i * 28, 0)
			if array[i] == 0:
				print("drawn dark")
				draw_dark(i * 28, 0)

func delete_mushrooms():
	for i in $Sign/SignWrite/Information/VBoxContainer/FrequencyInformation.get_children():
		$Sign/SignWrite/Information/VBoxContainer/FrequencyInformation.remove_child(i)
		i.queue_free()

func reset_mushrooms():
	set_width()
	delete_mushrooms()
	paint_mushrooms()

func set_streakarray(slidervalue):
	var setarray = []
	if slidervalue == 0:
		setarray = [0, 0, 0, 0, 0, 0, 0]
	if slidervalue == 1:
		setarray = [0, 0, 0, 0]
	if slidervalue == 2:
		setarray = [0, 0, 0]
	if slidervalue == 3:
		setarray = [0, 0]
	if slidervalue == 4:
		setarray = [0]
	return setarray
	
func _on_growing(tree):
	if tree == tree_number:
		var treename = Global.all_tree_data[tree]["tree_name"]
		var tree_node = get_node("/root/Main/PlantGrid/HBoxContainer/" + treename)
		var animation_player = tree_node.get_node("Tree/AnimationPlayer")
		Global.all_tree_data[tree]["progress"] += progress_increment()
		if Global.all_tree_data[tree]["frequency_value"] == 0:
			#time reset can only happen at night
			var addition = 0
			if Global.current_time <= Global.reset_time:
				addition = 1
			Global.all_tree_data[tree]["streakarray"][Global.current_weekday - 1 - addition] = 1
		else:
			for i in range(Global.all_tree_data[tree]["streakarray"].size()):
				if Global.all_tree_data[tree]["streakarray"][i] == 0:
					Global.all_tree_data[tree]["streakarray"][i] = 1
					break
		Global.all_tree_data[tree]["streak"] += 1
		animation_player.play("Grow")
		await animation_player.animation_finished
		drop_coins()
		if check_streak_finsihed():
			await get_tree().create_timer(1).timeout
			streakbeam = beam.instantiate()
			streakbeam.name = str(streakbeam)
			streakbeam.scale = Vector2(2.5, 3.208)
			streakbeam.position = Vector2(0, 0)
			streakbeam.modulate.a = 0.4
			add_child(streakbeam)
			#var beam_animation = streakbeam.get_node("AnimatedSprite2D/AnimationPlayer")
			#beam_animation.play("appear")
			streak_coins()
		
		if Global.all_tree_data[tree]["progress"] >= Global.completedhabit:
			Global.paused = true
			animation_player.play("Complete")
			await get_tree().create_timer(2).timeout
			streakbeam = beam.instantiate()
			streakbeam.name = str(streakbeam)
			streakbeam.scale = Vector2(2.5, 3.208)
			streakbeam.position = Vector2(0, 0)
			add_child(streakbeam)
			var beam_animation = streakbeam.get_node("AnimatedSprite2D/AnimationPlayer")
			beam_animation.play("whiteout")
			await beam_animation.animation_finished
			$Tree.visible = false
			streakbeam.queue_free()
			drop_special_coins()
			await get_tree().create_timer(9.5).timeout
			Global.emit_signal("reset_trees", tree)
			Global.paused = false
			return

		var trackprogress = floor(Global.all_tree_data[tree]["progress"]/9.42857143)
		var progress_frame = tree_node.get_node("Tree")
		progress_frame.frame = int(trackprogress)
		Global.all_tree_data[tree]["flowing"] = true
		reset_mushrooms()


func streak_coins():
	var coinamount = (floor( 20 / (Global.all_tree_data[tree_number]["frequency_value"] + 1)))
	await get_tree().create_timer(1).timeout
	for i in coinamount:
		var coindrop = coin.instantiate()
		coindrop.position = Vector2(190 + randi_range(-230,230), -550)
		add_child(coindrop)
		await get_tree().create_timer(0.1).timeout
	await get_tree().create_timer(2).timeout
	#var beam_animation = streakbeam.get_node("AnimatedSprite2D/AnimationPlayer")
	#beam_animation.play("disappear")
	#await beam_animation.animation_finished
	streakbeam.queue_free()

func drop_coins():
	var coinamount = (Global.all_tree_data[tree_number]["frequency_value"] + 2) + $Tree.frame
	for i in coinamount:
		var coindrop = coin.instantiate()
		var initial_force = Vector2(randi_range(-120,120), -300)
		coindrop.position = Vector2(190 + randi_range(-20,20), 100)
		coindrop.apply_central_impulse(initial_force)
		add_child(coindrop)
		await get_tree().create_timer(0.2).timeout

func drop_special_coins():
	var coinamount = 1
	for i in coinamount:
		var coindrop = specialcoin.instantiate()
		var initial_force = Vector2(0, -600)
		coindrop.position = Vector2(190, 100)
		coindrop.apply_central_impulse(initial_force)
		add_child(coindrop)

func _on_edit_sign_pressed():
	if !Global.check_paused():
		Global.camerapaused = true
		$CanvasLayer/EditMenu.visible = true
		$Sign.visible = false
		$EditSign.visible = false
		EditText.text = Global.all_tree_data[tree_number]["tree_name"]
		EditSlider.value = Global.all_tree_data[tree_number]["frequency_value"]
		Global.paused = true
		$Sign/HoverCover.visible = false

func _on_exit_edit_menu_pressed():
	$CanvasLayer/EditMenu.visible = false
	$Sign.visible = true
	$EditSign.visible = true
	Global.paused = false
	Global.camerapaused = false

func _on_h_slider_value_changed(value):
	EditLine.text = Global.Freq[value]

func destroy(tree_number):
	_on_exit_edit_menu_pressed()
	Global.emit_signal("exit_chopping")


func _on_destroy_pressed():
	Global.camerapaused = false
	$CanvasLayer/EditMenu.visible = false
	$Sign.visible = true
	$EditSign.visible = true
	Global.paused = true
	Global.emit_signal("chopping", tree_number)

func check_name_exists(name):
	var contin = true
	for basekey in Global.all_tree_data.keys():
		if "tree_name" in Global.all_tree_data[basekey] and Global.all_tree_data[basekey]["tree_name"] == name:
			contin = false
	return contin

func _on_save_pressed():
	if check_name_exists(EditText.text) and EditText.text != "" or Global.all_tree_data[tree_number]["tree_name"] == EditText.text and EditText.text != "":
		if !EditText.text == Global.all_tree_data[tree_number]["tree_name"]:
			Global.all_tree_data[tree_number]["tree_name"] = EditText.text
			SignDesc.text = Global.all_tree_data[tree_number]["tree_name"]
		if !EditSlider.value == Global.all_tree_data[tree_number]["frequency_value"]:
			Global.all_tree_data[tree_number]["tree_frequency"] = Global.Freq[EditSlider.value]
			Global.all_tree_data[tree_number]["frequency_value"] = EditSlider.value
			SignFreq.text = Global.all_tree_data[tree_number]["tree_frequency"]
			var ones = Global.all_tree_data[tree_number]["streakarray"].count(1)
			Global.all_tree_data[tree_number]["streakarray"] = set_streakarray(EditSlider.value)
			change_to_one(Global.all_tree_data[tree_number]["streakarray"].size(), ones)
			Global.all_tree_data[tree_number]["streak"] = ones
			reset_mushrooms()
		_on_exit_edit_menu_pressed()

func change_to_one(arraysize, ones):
	for i in range(min(ones, arraysize)):
		Global.all_tree_data[tree_number]["streakarray"][i] = 1
	
func _on_text_edit_text_changed():
	var text_edit = EditText
	var Lines = text_edit.get_line_wrap_count(0)
	var Lines2 = text_edit.get_line_wrap_count(1)
	var Enters = text_edit.get_line_count()
	var totalspacing = Enters + Lines + Lines2
	var text_edit_string = text_edit.get_text()
	var charcount = text_edit_string.length()
	if charcount >= 24 or totalspacing > 2:
		text_edit.editable = false

func _input(event):
	if Input.is_action_just_pressed('backspace'):
		EditText.editable = true

func _on_edit_sign_mouse_entered():
	if !Global.check_paused():
		$Sign/HoverCover.visible = true

func _on_edit_sign_mouse_exited():
	$Sign/HoverCover.visible = false



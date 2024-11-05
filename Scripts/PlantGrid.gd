extends Node2D

var global_script = preload("res://Scripts/Global.gd")
var plant = preload("res://Scenes/plant.tscn")
var coin = preload("res://Scenes/Coin.tscn")
var task = preload("res://Scenes/task.tscn")

@onready var grid = $HBoxContainer
@onready var FrequencyText = $"../UI/UInode/AddMenu/GridContainer/Frequency"
@onready var FrequencySlider = $"../UI/UInode/AddMenu/GridContainer/FrequencySlider"
@onready var DescriptionText = $"../UI/UInode/AddMenu/GridContainer/DescriptionEdit"
@onready var DailyTask = $"../UI/UInode/TaskMenuCanvas/Dailytasks/VBoxContainer/TextureRect/TaskMenu/Tasks"
@onready var WeeklyTask = $"../UI/UInode/TaskMenuCanvas/Weeklytasks/VBoxContainer/TextureRect/TaskMenu/Tasks"
@onready var YearlyTask = $"../UI/UInode/TaskMenuCanvas/Yearlytasks/VBoxContainer/TextureRect/TaskMenu/Tasks"

func set_data(ntree_name, ntree_frequency,ncounter_value, nfrequency_value, nprogress, nflowing, nstreak, nstreakarray, nskips):
	Global.all_tree_data[ncounter_value] = {
		"tree_name" : ntree_name,
		"tree_frequency" : ntree_frequency,
		"frequency_value" : nfrequency_value,
		"progress" : nprogress,
		"flowing" : nflowing,
		"streak" : nstreak,
		"streakarray" : nstreakarray,
		"skips" : nskips
	}
func set_decoration_data(id, type, location):
	Global.all_decoration_data[id] = {
		"type" : type,
		"location" : location
	}

func set_task_data(id, text, type):
	Global.all_task_data[id] = {
		"task" : text,
		"type" : type
	}

func _ready():
	FrequencySlider.value = 0
	FrequencyText.text = Global.Freq[0]
	Global.connect("reset_trees", _on_chop)
	Global.connect("taskresetting", _task_reset)
	Global.connect("taskcompletion", _task_complete)


func _on_frequency_slider_value_changed(value):
	FrequencyText.text = Global.Freq[value]
	
func plant_tree(tree_name, tree_frequency, frequency_value, progress, flowing, streak, streakarray, skips):
	var tree = plant.instantiate()
	var new_position = grid.get_child_count() * Global.x_spacing
	print("new position", new_position)
	var counter_value = Global.treecount
	tree.position = Vector2(new_position, 0)
	tree.name = tree_name 
	set_data(tree_name, tree_frequency, counter_value, frequency_value, progress, flowing, streak, streakarray, skips)
	grid.add_child(tree)
	Global.treecount = grid.get_child_count()
	print("Total amount of trees: " , Global.treecount , '\n')
	print("All tree data: " , Global.all_tree_data , "\n")

func plant_decoration(type, location):
	print("2", location)
	var id = Global.decorationcount
	var sprite = TextureButton.new()
	var locationvector = str(location)
	print("3", locationvector)
	if type == 1:
		sprite.texture_normal = preload("res://Piskel/ProgressBar/bush2.png")
		sprite.scale = Vector2(4, 4)
		sprite.z_index = -1
	if type == 2:
		sprite.texture_normal = preload("res://Piskel/ProgressBar/grass2.png")
		sprite.scale = Vector2(4, 4)
		sprite.z_index = -1
	if type == 3:
		sprite.texture_normal = preload("res://Piskel/sunflower3.png")
		sprite.scale = Vector2(4, 4)
		sprite.z_index = -1
	if type == 4:
		sprite.texture_normal = preload("res://Piskel/varen.png")
		sprite.scale = Vector2(4, 4)
		sprite.z_index = -1
	if type == 5:
		sprite.texture_normal = preload("res://Piskel/flowerbed.png")
		sprite.scale = Vector2(4, 4)
		sprite.z_index = -1
	if type == 6:
		sprite.texture_normal = preload("res://Piskel/ProgressBar/goldenflower.png")
		sprite.scale = Vector2(4, 4)
		sprite.z_index = -1
	var x = int(locationvector.left(locationvector.find(" ")))
	var y = int(locationvector.right(locationvector.find(" ")))
	locationvector = Vector2(x,y)
	print(locationvector, "locationvector")
	sprite.position = locationvector
	sprite.name = str(id)
	sprite.connect("pressed", _on_decoration_pressed.bind(id))
	set_decoration_data(id, type, location)
	$DecorationGrid.add_child(sprite)
	Global.decorationcount = $DecorationGrid.get_child_count()

func plant_task(text, type):
	var newtask = task.instantiate()
	var spacing = Control.new()
	newtask.text = text
	spacing.custom_minimum_size = Vector2(0, 40)
	var id = Global.taskcount
	set_task_data(id, text, type)
	if type == 0:
		DailyTask.add_child(newtask)
		DailyTask.add_child(spacing)
	elif type == 1:
		WeeklyTask.add_child(newtask)
		WeeklyTask.add_child(spacing)
	else:
		YearlyTask.add_child(newtask)
		YearlyTask.add_child(spacing)
	Global.taskcount += 1

func _on_chop(tree_number):
	reset(tree_number)

func _task_reset(id):
	reset_tasks(id)

func _task_complete(id, location):
	print(location)
	var i = 0
	var freq = Global.all_task_data[id]["type"]
	while i <= 5 + pow(freq * 2, 3):
		var coindrop = coin.instantiate()
		coindrop.position = Vector2(location)
		coindrop.z_index = 4000
		var initial_force = Vector2(randi_range(-120,120), randi_range(-120,120))
		coindrop.apply_central_impulse(initial_force)
		$"../UI/UInode/CoinGenerations".add_child(coindrop)
		i += 1
	reset_tasks(id)

func _on_decoration_pressed(id):
	print("sdfdfdsfdsfd")
	if !Global.paused:
		Global.paused = true
		Global.camerapaused = true
		var button = TextureButton.new()
		var locationvector = str(Global.all_decoration_data[id]["location"])
		var x = int(locationvector.left(locationvector.find(" ")))
		var y = int(locationvector.right(locationvector.find(" ")))
		locationvector = Vector2(x,y)
		button.texture_normal = preload("res://Piskel/ProgressBar/image-1.png-1.png (1).png")
		button.texture_hover = preload("res://Piskel/ProgressBar/image-1.png-1.png (2).png")
		button.scale = Vector2(0.4, 0.4)
		button.position = locationvector + Vector2(-40, 13)
		if Global.all_decoration_data[id]["type"] == 3:
			button.position += Vector2(27, 95)
		if Global.all_decoration_data[id]["type"] == 6:
			button.position += Vector2(0, 30)
		var label = Label.new()
		label.text = "CHOP"
		label.modulate = Color("624723")
		label.scale = Vector2(2.3,2.3)
		label.position = Vector2(55, 82)
		var escape = TextureButton.new()
		escape.texture_normal = preload("res://Piskel/SIGNSHIT-6.png (2).png")
		escape.modulate.a = 0
		escape.scale = Vector2(12, 12)
		add_child(escape)
		add_child(button)
		button.connect("pressed", Callable(on_chop_decoration.bind(id, button, escape)))
		escape.connect("pressed", Callable(on_escape_decoration.bind(id, button, escape)))
		button.add_child(label)
	

func on_chop_decoration(id, button, escape):
	button.queue_free()
	escape.queue_free()
	Global.paused = false
	Global.camerapaused = false
	reset_decoration(id)
	print("on chop", id)


func on_escape_decoration(id, button, escape):
	button.queue_free()
	escape.queue_free()
	Global.paused = false
	Global.camerapaused = false
	print("on escape", id)
	
func type_to_price(type):
	if type == 1:
		return Global.bushprice
	if type == 2:
		return Global.grassprice
	if type == 3:
		return Global.sunflowerprice
	if type == 4:
		return Global.varenprice
	if type == 5:
		return Global.flowerbedprice
	if type == 6:
		return Global.specialflowerprice
	else: return 0

func drop_coins(id):
	var coinamount = (floor(type_to_price(Global.all_decoration_data[id]["type"]) / 2))
	#gets zero for some reason
	var locationvector = str(Global.all_decoration_data[id]["location"])
	var x = int(locationvector.left(locationvector.find(" ")))
	var y = int(locationvector.right(locationvector.find(" ")))
	locationvector = Vector2(x,y)
	if Global.all_decoration_data[id]["type"] == 3:
		locationvector += Vector2(27, 95)
	for i in coinamount:
		var coindrop = coin.instantiate()
		coindrop.position = Vector2(locationvector.x + randi_range(-20,20), locationvector.y) + Vector2(65, 90)
		var initial_force = Vector2(randi_range(-120,120), -300)
		coindrop.apply_central_impulse(initial_force)
		add_child(coindrop)
		await get_tree().create_timer(0.1).timeout

func reset(tree_number):
	var updated_data = {}
	for i in grid.get_children():
		grid.remove_child(i)
		i.queue_free()
	Global.treecount = grid.get_child_count()
	for key in Global.all_tree_data.keys():
		if key < tree_number:
			updated_data[key] = Global.all_tree_data[key]
		elif key > tree_number:
			updated_data[key-1] = Global.all_tree_data[key]
	Global.all_tree_data = updated_data
	for key in Global.all_tree_data.keys():
		var tree_data = Global.all_tree_data[key]
		plant_tree(tree_data["tree_name"], tree_data["tree_frequency"], tree_data["frequency_value"], tree_data["progress"], tree_data["flowing"], tree_data["streak"], tree_data["streakarray"], tree_data["skips"])
		
func reset_decoration(id):
	drop_coins(id)
	var updated_data = {}
	for i in $DecorationGrid.get_children():
		$DecorationGrid.remove_child(i)
		i.queue_free()
	Global.decorationcount = $DecorationGrid.get_child_count()
	for key in Global.all_decoration_data.keys():
		if key < id:
			updated_data[key] = Global.all_decoration_data[key]
		elif key > id:
			updated_data[key-1] = Global.all_decoration_data[key]
	Global.all_decoration_data = updated_data
	for key in Global.all_decoration_data.keys():
		var decoration_data = Global.all_decoration_data[key]
		plant_decoration(decoration_data["type"], decoration_data["location"])

func reset_tasks(id):
	var updated_data = {}
	for i in DailyTask.get_children():
		DailyTask.remove_child(i)
		i.queue_free()
	for i in WeeklyTask.get_children():
		WeeklyTask.remove_child(i)
		i.queue_free()
	for i in YearlyTask.get_children():
		YearlyTask.remove_child(i)
		i.queue_free()
	Global.taskcount = 0
	for key in Global.all_task_data.keys():
		if key < id:
			updated_data[key] = Global.all_task_data[key]
		elif key > id:
			updated_data[key-1] = Global.all_task_data[key]
	Global.all_task_data = updated_data
	for key in Global.all_task_data.keys():
		var task_data = Global.all_task_data[key]
		plant_task(task_data["task"], task_data["type"])

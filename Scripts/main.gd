extends Node2D

var global_data = preload("res://Scripts/Global.gd")

@onready var dayb = $daybackg
@onready var eveningb = $eveningbackg
@onready var sunriseb = $sunrisebackg
@onready var nightb = $nightbackg

func _ready():
	load_game()
	#OP_tree(0)
	set_backg()
	Global.paused = false
	get_tree().auto_accept_quit = false
	update_time()
	DisplayServer.window_set_min_size(Vector2(64, 500), 0)

func update_time():
	Global.last_weekday = Global.current_weekday
	Global.last_days = Global.current_days
	Global.last_time = Global.current_time

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_game()
		get_tree().quit()

func OP_tree(number):
	Global.all_tree_data[number]["tree_frequency"] = "Daily"
	Global.all_tree_data[number]["frequency_value"] = 0
	Global.all_tree_data[number]["progress"] = 70
	Global.all_tree_data[number]["flowing"] = false
	Global.all_tree_data[number]["streak"] = 6
	Global.all_tree_data[number]["streakarray"] = [1, 1, 1, 1, 1, 1, 0]
	Global.all_tree_data[number]["skips"] = 0

func set_backg():
	sunriseb.visible = false
	dayb.visible = false
	eveningb.visible = false
	nightb.visible = false
	if Global.current_time >= 6 and Global.current_time < 12:
		sunriseb.visible = true
	elif Global.current_time >= 12 and Global.current_time < 18:
		dayb.visible = true
	elif Global.current_time >= 18 and Global.current_time < 21:
		eveningb.visible = true
	else:
		nightb.visible = true

func is_leap_year(year):
	return (year % 4 == 0 and year % 100 != 0) or (year % 400 == 0)

func get_days():
	var time_dict = Time.get_datetime_dict_from_system()
	var month_day_count = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
	var days_in_year = 365
	if is_leap_year(time_dict["year"]):
		month_day_count[2] = 29
		days_in_year = 366
	var days = time_dict["day"]
	for i in range(1, time_dict["month"]):
		days += month_day_count[i]
	return days



func save():
	var time_dict = Time.get_datetime_dict_from_system()
	var weekday = time_dict["weekday"]
	var days = get_days()
	var hours = time_dict["hour"]
	var minutes = time_dict["minute"]
	var seconds = time_dict["second"]
	var last_time = hours + (float(minutes)/60) + (float(seconds)/3600)
	var saved_data = {
		"all_tree_data" : Global.all_tree_data,
		"all_decoration_data" : Global.all_decoration_data,
		"all_task_data" : Global.all_task_data,
		"days" : days,
		"time" : last_time,
		"weekday" : weekday,
		"coincount" : Global.coincount,
		"specialcoincount" : Global.specialcoincount,
		"foxcount" : Global.foxcount,
		"goldenfoxcount" : Global.goldenfoxcount,
		"deercount" : Global.deercount,
		"butterflycount" : Global.butterflycount,
		"walking_speed" : Global.walk_speed,
		"setback" : Global.setback,
		"completedhabit" : Global.completedhabit
	}
	return saved_data

func save_game():
	var save_game = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var json_string = JSON.stringify(save())
	save_game.store_line(json_string)



func load_trees(node_data):
	for key in node_data.keys():
		var tree_data = node_data[key]
		$PlantGrid.plant_tree(tree_data["tree_name"], tree_data["tree_frequency"], tree_data["frequency_value"], tree_data["progress"], tree_data["flowing"], tree_data["streak"], tree_data["streakarray"], tree_data["skips"])
		
func load_decoration(node_data):
	for key in node_data.keys():
		var decoration_data = node_data[key]
		$PlantGrid.plant_decoration(decoration_data["type"], decoration_data["location"])


func load_tasks(node_data):
	for key in node_data.keys():
		var task_data = node_data[key]
		$PlantGrid.plant_task(task_data["task"], task_data["type"])

func load_foxes(node_data):
	var planted_foxes = 0
	while planted_foxes < node_data:
		$UI/UInode/ShopMenuCanvas/AnimalScroll/VScrollBar/ShopMenu/VBoxContainer/FoxShop.plant_fox()
		planted_foxes += 1

func load_golden_foxes(node_data):
	var planted_foxes = 0
	while planted_foxes < node_data:
		$UI/UInode/ShopMenuCanvas/SpecialScroll/VScrollBar/ShopMenu/GridContainer/GoldenFoxShop.plant_goldenfox()
		planted_foxes += 1

func load_deers(node_data):
	var planted_deers = 0
	while planted_deers < node_data:
		$UI/UInode/ShopMenuCanvas/AnimalScroll/VScrollBar/ShopMenu/VBoxContainer/DeerShop.plant_deer()
		planted_deers += 1

func load_butterflies(node_data):
	var planted_butterflies = 0
	while planted_butterflies < node_data:
		$UI/UInode/ShopMenuCanvas/AnimalScroll/VScrollBar/ShopMenu/VBoxContainer/Butterflyshop.plant_butterfly()
		planted_butterflies += 1

func load_game():
	if not FileAccess.file_exists("user://savegame.save"):
		print("no file found")
		return
	
	var save_game = FileAccess.open("user://savegame.save", FileAccess.READ)

	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		var node_data = json.get_data()
		Global.last_time = float(node_data["time"])
		Global.last_days = node_data["days"]
		Global.last_weekday = node_data["weekday"]
		Global.coincount = node_data["coincount"]
		Global.specialcoincount = node_data["specialcoincount"]
		Global.walk_speed = node_data["walking_speed"]
		Global.setback = node_data["setback"]
		Global.completedhabit = node_data["completedhabit"]
		load_trees(node_data["all_tree_data"])
		load_decoration(node_data["all_decoration_data"])
		load_tasks(node_data["all_task_data"])
		load_foxes(node_data["foxcount"])
		load_golden_foxes(node_data["goldenfoxcount"])
		load_deers(node_data["deercount"])
		load_butterflies(node_data["butterflycount"])
		#Global.coincount = node_data["coincount"] + 999
		#Global.specialcoincount = node_data["specialcoincount"] + 20
		$UI/HBoxContainer/Coincount.text = str(Global.coincount)
		$UI/HBoxContainer/SpecialCoinCount.text = str(Global.specialcoincount)




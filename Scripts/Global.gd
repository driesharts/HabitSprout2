extends Node

var treecount = 0
var taskcount = 0
var foxcount = 0
var goldenfoxcount = 0
var deercount = 0
var butterflycount = 0
var decorationcount = 0
var all_decoration_data = {}
var all_tree_data = {}
var all_task_data = {}
var Freq = ["Daily", "4 Per Week", "3 Per Week","2 Per Week", "Weekly"]
var x_spacing = 450
var wtf = 0
var walk_speed = 1.5
var walk_speedf = 1.7
var walk_speedd = 1.2
var coincount = 0
var specialcoincount = 0
var dropable = false
var bushprice = 20
var grassprice = 40
var sunflowerprice = 80
var varenprice = 60
var flowerbedprice = 50
var butterflyprice = 20
var specialflowerprice = 1
var foxprice = 150
var goldenfoxprice = 1
var deerprice = 250
var setback = 3
var completedhabit = 66

signal taskcompletion
signal taskresetting
signal add_coin
signal add_special_coin
signal exit_wander
signal exit_wanderf
signal exit_idle
signal exit_idlef
signal watering
signal exit_sleepingf
signal exit_watering
signal chop(tree_number)
signal camera_position(position)
signal special_camera_position(position)
signal actual_position(camera)
signal plant
signal chopping
signal planting
signal exit_chopping
signal exit_planting
signal reset_trees
signal growing_animation

var paused = false
var camerapaused = false

var last_weekday : int
var last_days : float
var last_time : float
var timedict = Time.get_datetime_dict_from_system()
var hours = timedict["hour"]
var minutes = timedict["minute"]
var seconds = timedict["second"]
var current_time = hours + (float(minutes)/60) + (float(seconds)/3600)
var current_days = float(get_days())
var current_weekday = int(timedict["weekday"])
var reset_time = float(4)
var reset_streak = int(1)

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

func check_paused():
	return paused


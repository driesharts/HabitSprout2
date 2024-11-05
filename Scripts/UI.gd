extends Node2D

@onready var AddMenu = $AddMenu
@onready var text_edit = $AddMenu/GridContainer/DescriptionEdit
@onready var slider_edit = $AddMenu/GridContainer/FrequencySlider
@onready var Shopmenu = $ShopMenuCanvas
@onready var Settingsmenu = $SettingsMenuCanvas
@onready var daily_tasks = $TaskMenuCanvas/Dailytasks/VBoxContainer/TextureRect/TaskMenu/LineEdit
@onready var weekly_tasks = $TaskMenuCanvas/Weeklytasks/VBoxContainer/TextureRect/TaskMenu/LineEdit
@onready var yearly_tasks = $TaskMenuCanvas/Yearlytasks/VBoxContainer/TextureRect/TaskMenu/LineEdit

var freq = ""
var freqnumber : int
var progress : int
var flowing : bool
var streak : int
var streakarray = []
var skips : int
var dropable = false
var walkingspeed = 1.5

func _ready():
	AddMenu.visible = false
	Global.connect("plant", _on_plant)
	Global.connect("add_coin", _on_add_coin)
	Global.connect("add_special_coin", _on_add_special_coin)
	_on_decoration_button_pressed()
	_on_texture_button_daily_pressed()
	$TaskMenuCanvas/Weeklytasks.visible = false
	$TaskMenuCanvas/Yearlytasks.visible = false

func _on_shop_button_pressed():
	if Global.paused == false:
		Shopmenu.visible = true
		Global.paused = true


func _on_settings_button_pressed():
	if Global.paused == false:
		Settingsmenu.visible = true
		$SettingsMenuCanvas/VBoxContainer/WalkingSlider.value = Global.walk_speed
		$SettingsMenuCanvas/VBoxContainer/SetbackSlider.value = Global.setback
		Global.paused = true

#AddMenu
func _on_add_button_pressed():
	if Global.paused == false:
		AddMenu.visible = true
		Global.paused = true
		Global.camerapaused = true


func _on_add_menu_quit_pressed():
	AddMenu.visible = false
	text_edit.editable = true
	text_edit.text = ""
	Global.paused = false
	Global.camerapaused = false
	slider_edit.value = 0

func _on_texture_button_pressed():
	Shopmenu.visible = false
	Global.paused = false
	Global.camerapaused = false
	

func check_name_exists(name):
	var contin = true
	for basekey in Global.all_tree_data.keys():
		if "tree_name" in Global.all_tree_data[basekey] and Global.all_tree_data[basekey]["tree_name"] == name:
			contin = false
	return contin

func _on_add_menu_add_pressed():
	var name = text_edit.text
	if check_name_exists(name) and name != "":
		Global.paused = true
		set_tree_data(text_edit.text, Global.Freq[slider_edit.value], slider_edit.value, 0, false, 0, set_streakarray(slider_edit.value), 0)
		_on_add_menu_quit_pressed()
		Global.paused = true
		Global.emit_signal("planting")

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
		
func set_tree_data(namen, freqn, freqnumbern, progressn, flowingn, streakn, streakarrayn, skipsn):
	name = namen
	freq = freqn
	freqnumber = freqnumbern
	progress = progressn
	flowing = flowingn
	streak = streakn
	streakarray = streakarrayn
	skips = skipsn

func _on_plant():
	$"../../PlantGrid".plant_tree(name, freq, freqnumber, progress, flowing, streak, streakarray, skips)

func _on_add_coin():
	$"../HBoxContainer/Coincount".text = str(Global.coincount)

func _on_add_special_coin():
	$"../HBoxContainer/SpecialCoinCount".text = str(Global.specialcoincount)
	
func _on_description_edit_text_changed():
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
		text_edit.editable = true

func _on_quit_button_pressed():
	$"../..".save_game()
	get_tree().quit()

func _on_decoration_button_pressed():
	$ShopMenuCanvas/DecorationScroll.visible = true
	$ShopMenuCanvas/AnimalScroll.visible = false
	$ShopMenuCanvas/SpecialScroll.visible = false
	$ShopMenuCanvas/ShopButtons/DecorationButton.disabled = true
	$ShopMenuCanvas/ShopButtons/AnimalButton.disabled = false
	$ShopMenuCanvas/ShopButtons/SpecialButton.disabled = false
	$ShopMenuCanvas/ShopButtons/DecorationButton.z_index = 1
	$ShopMenuCanvas/ShopButtons/AnimalButton.z_index = 0
	$ShopMenuCanvas/ShopButtons/SpecialButton.z_index = 0


func _on_animal_button_pressed():
	$ShopMenuCanvas/AnimalScroll.visible = true
	$ShopMenuCanvas/DecorationScroll.visible = false
	$ShopMenuCanvas/SpecialScroll.visible = false
	$ShopMenuCanvas/ShopButtons/AnimalButton.disabled = true
	$ShopMenuCanvas/ShopButtons/DecorationButton.disabled = false
	$ShopMenuCanvas/ShopButtons/SpecialButton.disabled = false
	$ShopMenuCanvas/ShopButtons/DecorationButton.z_index = 0
	$ShopMenuCanvas/ShopButtons/AnimalButton.z_index = 1
	$ShopMenuCanvas/ShopButtons/SpecialButton.z_index = 0

func _on_special_button_pressed():
	$ShopMenuCanvas/AnimalScroll.visible = false
	$ShopMenuCanvas/DecorationScroll.visible = false
	$ShopMenuCanvas/SpecialScroll.visible = true
	$ShopMenuCanvas/ShopButtons/AnimalButton.disabled = false
	$ShopMenuCanvas/ShopButtons/DecorationButton.disabled = false
	$ShopMenuCanvas/ShopButtons/SpecialButton.disabled = true
	$ShopMenuCanvas/ShopButtons/DecorationButton.z_index = 0
	$ShopMenuCanvas/ShopButtons/AnimalButton.z_index = 0
	$ShopMenuCanvas/ShopButtons/SpecialButton.z_index = 1

func _on_dropping_area_mouse_entered():
	Global.dropable = true


func _on_dropping_area_mouse_exited():
	Global.dropable = false


func _on_add_daily_task_pressed():
	if daily_tasks.text != "":
		var text = daily_tasks.text
		$"../../PlantGrid".plant_task(text, 0)
		daily_tasks.text = ""

func _on_add_weekly_task_pressed():
	if weekly_tasks.text != "":
		var text = weekly_tasks.text
		$"../../PlantGrid".plant_task(text, 1)
		weekly_tasks.text = ""

func _on_add_yearly_task_pressed():
	if yearly_tasks.text != "":
		var text = yearly_tasks.text
		$"../../PlantGrid".plant_task(text, 2)
		yearly_tasks.text = ""


func _on_texture_button_2_pressed():
	#weekly
	$TaskMenuCanvas/Dailytasks.visible = false
	$TaskMenuCanvas/Weeklytasks.visible = true
	$TaskMenuCanvas/Yearlytasks.visible = false
	$TaskMenuCanvas/TaskMenuButtons/TextureButtonDaily.disabled = false
	$TaskMenuCanvas/TaskMenuButtons/TextureButton2.disabled = true
	$TaskMenuCanvas/TaskMenuButtons/TextureButton3.disabled = false
	weekly_tasks.text = ""

func _on_texture_button_3_pressed():
	$TaskMenuCanvas/Dailytasks.visible = false
	$TaskMenuCanvas/Weeklytasks.visible = false
	$TaskMenuCanvas/Yearlytasks.visible = true
	$TaskMenuCanvas/TaskMenuButtons/TextureButtonDaily.disabled = false
	$TaskMenuCanvas/TaskMenuButtons/TextureButton2.disabled = false
	$TaskMenuCanvas/TaskMenuButtons/TextureButton3.disabled = true
	yearly_tasks.text = ""


func _on_task_menu_quit_pressed():
	$TaskMenuCanvas.visible = false
	Global.paused = false
	Global.camerapaused = false


func _on_texture_button_daily_pressed():
	#daily
	$TaskMenuCanvas/Dailytasks.visible = true
	$TaskMenuCanvas/Weeklytasks.visible = false
	$TaskMenuCanvas/Yearlytasks.visible = false
	$TaskMenuCanvas/TaskMenuButtons/TextureButtonDaily.disabled = true
	$TaskMenuCanvas/TaskMenuButtons/TextureButton2.disabled = false
	$TaskMenuCanvas/TaskMenuButtons/TextureButton3.disabled = false
	daily_tasks.text = ""

func _on_task_button_pressed():
	$TaskMenuCanvas.visible = true
	Global.paused = true
	Global.camerapaused = true


func _on_exit_settings_pressed():
	Settingsmenu.visible = false
	Global.paused = false
	Global.camerapaused = false



func _on_walking_slider_value_changed(value):
	Global.walk_speed = value


func _on_setback_slider_value_changed(value):
	Global.setback = value


func _on_completionslider_value_changed(value):
	Global.completedhabit = value




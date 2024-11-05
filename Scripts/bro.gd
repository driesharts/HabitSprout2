class_name Bro
extends Node2D

@onready var finite_state_machine = $finite_state_machine
@onready var wander_state = $finite_state_machine/WanderState
@onready var idle_state = $finite_state_machine/IdleState
@onready var water_state = $finite_state_machine/WateringState
@onready var chopping_state = $finite_state_machine/ChoppingState
@onready var planting_state = $finite_state_machine/PlantingState

func _ready():
	Global.connect("exit_wander", exit_wander)
	Global.connect("exit_idle", exit_idle)
	Global.connect("exit_watering", exit_watering)
	Global.connect("watering", _water)
	Global.connect("chopping", _chop)
	Global.connect("exit_chopping", exit_chopping)
	Global.connect("planting", _plant)
	Global.connect("exit_planting", exit_planting)
	finite_state_machine.change_state(idle_state)

func exit_wander():
	finite_state_machine.change_state(idle_state)
	
func exit_idle():
	finite_state_machine.change_state(wander_state)

func _water(_tree_number):
	finite_state_machine.change_state(water_state)

func exit_watering():
	finite_state_machine.change_state(idle_state)

func _chop(_tree_number):
	finite_state_machine.change_state(chopping_state)

func exit_chopping():
	finite_state_machine.change_state(idle_state)

func _plant():
	finite_state_machine.change_state(planting_state)

func exit_planting():
	finite_state_machine.change_state(idle_state)

extends Node2D


@onready var actor = $"."
@onready var animator = $AnimatedSprite2D
@onready var positionx = actor.position.x
@onready var positiony = actor.position.y

var button : TextureButton
var escape : TextureButton
var process = false
var mannequin = false
var scaling = -4

var wandering = false
var idle = false
var sleeping = false

var idle_min_duration = 5
var idle_max_duration = 20
var idle_timer = 0

var maximum_walk_distance = 600
var minimum_walk_distance = 80
var target_position = Vector2.ZERO
var direction = 1

var sleep_min_duration = 20
var sleep_max_duration = 60
var sleep_timer = 0

func _ready():
	if Global.current_time > 21 or Global.current_time < 6:
		start_sleeping()
		animator.frame = randi_range(0,3)
	else:
		start_idle()
		animator.frame = randi_range(0,1)
	$AnimatedSprite2D.scale.x = ((randi() & 2) - 1) * scaling

func _process(delta):
	if !mannequin:
		if idle:
			idle_timer -= delta
			if idle_timer <= 0:
				idle = false
				var random_value = randf()
				if random_value < 0.2: 
					start_sleeping()
					return
				else:
					start_wandering()
					return
		if wandering:
			if actor.position.distance_to(target_position) < 1:
				wandering = false
				start_idle()
				return
			var velocity = direction * Global.walk_speedd
			actor.position += Vector2(velocity, 0)
		if sleeping and !Global.current_time > 21:
			sleep_timer -= delta
			if sleep_timer <= 0:
				sleeping = false
				start_idle()
				return
		if process:
			idle = false
			wandering = false
			sleeping = false
			if actor.global_position.x < -40:
				process = false
				queue_free()
			var velocity = -Global.walk_speedd
			actor.position += Vector2(velocity, 0)

func start_idle():
	idle_timer = randf_range(idle_min_duration, idle_max_duration)
	animator.play("Idle")
	idle = true

func start_wandering():
	var exclusion = 100
	if Global.treecount == 0:
		target_position = Vector2(randf_range(200, 600), actor.position.y)
	else:
		target_position = Vector2(randf_range(200, max(Global.treecount * Global.x_spacing + 300, Global.deercount * 400)), actor.position.y)
	if actor.position.distance_to(target_position) <= exclusion:
		start_idle()
		return
	else:
		direction = sign(target_position.x - actor.position.x)
		if direction ==0:
			direction = $AnimatedSprite2D.scale.x / scaling
		$AnimatedSprite2D.scale.x = direction * scaling
		animator.play("Walking")
	wandering = true


func start_sleeping():
	sleep_timer = randf_range(sleep_min_duration, sleep_max_duration)
	animator.play("Sleeping")
	sleeping = true


func _on_button_pressed():
	if !Global.paused and !process:
		mannequin = true
		Global.paused = true
		
		button = TextureButton.new()
		button.texture_normal = preload("res://Piskel/image-1.png-1.png-1.png.png")
		button.texture_hover = preload("res://Piskel/image-1.png-1.png (2)-1.png.png")
		button.scale = Vector2(0.4, 0.4)
		button.position = Vector2(-50, -80)
		var label = Label.new()
		label.text = "RELEASE"
		label.modulate = Color("624723")
		label.scale = Vector2(1.65,1.65)
		label.position = Vector2(33, 80)
		button.add_child(label)
		escape = TextureButton.new()
		escape.texture_normal = preload("res://Piskel/SIGNSHIT-6.png (2).png")
		escape.modulate.a = 0
		escape.scale = Vector2(20, 12)
		escape.position = Vector2(-700, -600)
		add_child(escape)
		add_child(button)
		button.connect("pressed", _on_button)
		escape.connect("pressed", _on_escape)

func _on_button():
	mannequin = false
	button.queue_free()
	escape.queue_free()
	Global.paused = false
	Global.camerapaused = false
	Global.deercount -= 1
	animator.play("Walking")
	$AnimatedSprite2D.scale.x = -1 * scaling
	process = true
	

func _on_escape():
	mannequin = false
	button.queue_free()
	escape.queue_free()
	Global.paused = false
	Global.camerapaused = false

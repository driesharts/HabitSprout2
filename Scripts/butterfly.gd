extends Node2D

var amplitude = randf_range(0.5, 4)
var frequency = 5
var time_passed = 0
var idle_timer = randf_range(2, 20)
var flying_timer = randf_range(5, 20)
var amplitude_timer = randf_range(0.5, 2.5)
var frequency_timer = randf_range(0.5, 2.5)
var direction_timer = randf_range(2, 12)
var speed = randf_range(0.3, 2)
var direction = (randi() & 2) - 1 
var select_color = randf_range(0, 1)
var scaling = randi_range(2, 3)
var idle = false
var flying = false
var current_speed : int
var dangerous_flying_up = false
var dangerous_flying_down = false
var mannequin = false
var button : TextureButton
var escape : TextureButton
var process = false

func _ready():
	flying = true
	current_speed = $AnimatedSprite2D.get_playing_speed()
	$AnimatedSprite2D.scale = Vector2(scaling, scaling)
	scale_sprite()
	if select_color < 0.3:
		$AnimatedSprite2D.play("Blue")
	elif select_color < 0.6:
		$AnimatedSprite2D.play("Orange")
	elif select_color < 0.95:
		$AnimatedSprite2D.play("Purple")
	else:
		$AnimatedSprite2D.play("Gold")
	$AnimatedSprite2D.speed_scale = current_speed + ((amplitude - 3) / 10)

func _process(delta):
	if !mannequin:
		if process:
			if $".".global_position.x < -40:
				process = false
				queue_free()
				
		time_passed += delta
		#direction
		direction_timer -= delta
		if direction_timer < 0:
				direction = (randi() & 2) - 1 
				speed = randf_range(0.3, 2)
				scale_sprite()
				direction_timer = randf_range(2, 15)
		#x restriction
		if !process:
			if position.x < 150:
					direction = 1
					direction_timer = randf_range(2, 15)
					scale_sprite()
					
			if position.x > Global.treecount * Global.x_spacing + 300:
				direction = -1
				direction_timer = randf_range(5, 15)
				scale_sprite()
		#flying
		if flying:
			flying_timer -= delta	
			if flying_timer < 0:
				flying = false
				var randomizer = randi_range(0, 1)
				if randomizer == 0:
					start_idle()
				else:
					start_flying()
				return

			amplitude_timer -= delta
			frequency_timer -= delta
			if amplitude_timer < 0:
				amplitude = randf_range(0.5, 3.7)
				amplitude_timer = randf_range(0.5, 2.5)
				$AnimatedSprite2D.speed_scale = current_speed + ((amplitude - 3) / 10)
			if frequency_timer < 0:
				frequency = randf_range(3, 6)
				frequency_timer = randf_range(0.5, 2.5)
			#if amplitude is x than frequency can be y max
			#if speed is x than amplitude can be y max
			
			amplitude = min(amplitude, speed * 4)
			frequency = (min(frequency, 5 * amplitude))
			
			
			var y_offset = amplitude * sin(frequency * time_passed)
			var x_offset = direction * speed

			#restriction
			if position.y > 530:
				dangerous_flying_down = true
			
			if position.y < 50:
				dangerous_flying_up = true
			
			if dangerous_flying_up:
				if position.y > 130:
					y_offset = abs(y_offset)
				else:
					dangerous_flying_down = false
			if dangerous_flying_down:
				if !position.y < 450:
					y_offset = abs(y_offset) * -1
				else:
					dangerous_flying_up = false
			position.y += y_offset
			position.x += x_offset

			
		#idle
		if idle:
			idle_timer -= delta
			if idle_timer < 0:
				idle = false
				start_flying()
				return
			if position.y < 560:
				var x_offset = direction * randf_range(0.5, 2)
				#var y_offset = 10
				var y_offset = (amplitude * sin(frequency * time_passed) + 2 * amplitude) / 2
				position.y += y_offset
				position.x += x_offset
			else:
				#inefficient because setting frame ever delta
				$AnimatedSprite2D.stop()
				$AnimatedSprite2D.frame = 0

			


func start_idle():
	idle_timer = randf_range(2, 12)
	idle = true

func start_flying():
	flying_timer = randf_range(5, 20)
	$AnimatedSprite2D.play()#does this work or need for specification on color
	flying = true

func scale_sprite():
	$AnimatedSprite2D.scale.x = scaling * direction * -1
#check if pixel behind is colour of plant and then sit on it


func _on_button_pressed():
	if !Global.paused and !process:
		mannequin = true
		Global.paused = true
		
		button = TextureButton.new()
		button.texture_normal = preload("res://Piskel/image-1.png-1.png-1.png.png")
		button.texture_hover = preload("res://Piskel/image-1.png-1.png (2)-1.png.png")
		button.scale = Vector2(0.4, 0.4)
		button.position = Vector2(-45, -90)
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
	Global.butterflycount -= 1
	direction = -1
	scale_sprite()
	direction_timer = 1000
	$AnimatedSprite2D.play()
	flying = true
	speed = 2.5
	idle = false
	flying_timer = 10000
	process = true
	

func _on_escape():
	mannequin = false
	button.queue_free()
	escape.queue_free()
	Global.paused = false
	Global.camerapaused = false


extends KinematicBody2D

# stats
var score : int = 0
var dead : bool = false
var death_time = 0
var death_delay = 1000
var has_rope = false
var rope_length = 400.0
var rope_current = 400.0
var rope_attached = false
var rope_attach_position : Vector2 = Vector2(0,0)

var bottom_death = 400
onready var coin_audio_array = [$CollectCoin0, $CollectCoin1, $CollectCoin2, $CollectCoin3]
 
# physics
var speed : int = 200
var jumpForce : int = 600
var gravity : int = 800
var sight_angle : float = PI/2
var sight_speed : float = PI/3

var rng = RandomNumberGenerator.new()
 
var vel : Vector2 = Vector2()
var grounded : bool = false
var doubleJumpsMax = 0
var doubleJumpsUsed = 0
var doubleJumpActivated = false

# components
onready var sprite = $Sprite
onready var ui = get_node("/root/MainScene/CanvasLayer/UI")

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sight.hide()
	$Rope.hide()
	pass # Replace with function body.

func _physics_process (delta):
	
	if(dead):
		if(OS.get_ticks_msec()-death_time > death_delay):
			get_tree().reload_current_scene()
		return
	
	if position.y > bottom_death + 600:
		die()
		
	#gravity
	vel.y += gravity * delta
	
	if rope_attached:
		var rope_vector = rope_attach_position - global_position
		
		if Input.is_action_pressed("move_up"):
			if rope_current > 20:
				rope_current -= speed/2 * delta
				if is_on_floor():
					vel = rope_vector.normalized() * speed / 2
		
		if Input.is_action_pressed("move_down"):
			if !is_on_floor() && rope_current < rope_length:
				rope_current += speed/2 * delta
		
		if !is_on_floor():
			if Input.is_action_pressed("move_left"):
				vel.x -= speed * delta
			
			elif Input.is_action_pressed("move_right"):
				vel.x += speed * delta
				
			#restrict movement to rope
			var original_target = -rope_vector + vel * delta
			if original_target.length() > rope_current:
				vel = (rope_vector + original_target.normalized() * rope_current) / delta
				pass
		else: 
			#walk with rope
			# reset horizontal velocity
			vel.x = 0
			# movement inputs & animations
			if Input.is_action_pressed("move_left"):
				vel.x -= speed
				$Sprite.play("walk")
			elif Input.is_action_pressed("move_right"):
				vel.x += speed
				$Sprite.play("walk")
			else:
				$Sprite.play("idle")
	else:
			# reset horizontal velocity
		vel.x = 0
		# movement inputs & animations
		if Input.is_action_pressed("move_left"):
			vel.x -= speed
			if is_on_floor():
				$Sprite.play("walk")
		elif Input.is_action_pressed("move_right"):
			vel.x += speed
			if is_on_floor():
				$Sprite.play("walk")
		else:
			if is_on_floor():
				$Sprite.play("idle")
		
	# reset doublejump counter
	if is_on_floor():
		doubleJumpsUsed = 0
		doubleJumpActivated = false
	
	if not is_on_floor():
		if(vel.y) < 0:
			$Sprite.play("jump")
		else:
			$Sprite.play("drop")
	# applying the velocity
	vel = move_and_slide(vel, Vector2.UP)


	if !Input.is_action_pressed("jump") && !is_on_floor():
		doubleJumpActivated = true

	# jump input
	if Input.is_action_pressed("jump"):
		if is_on_floor() or rope_attached:
			rope_attached = false
			vel.y -= jumpForce
			$Jump.play()
			$Sprite.play("jump")
			$Rope.hide()
		elif doubleJumpsMax > doubleJumpsUsed && doubleJumpActivated:
			doubleJumpActivated = false
			vel.y -= jumpForce
			$Jump.play()
			doubleJumpsUsed += 1
	
	# sprite direction
	if vel.x < 0:
		sprite.flip_h = true
	elif vel.x > 0:
		sprite.flip_h = false
		
	if has_rope:
		rope(delta)
	
	
func rope(delta):
	var space_state = get_world_2d().get_direct_space_state()
	
	if Input.is_action_pressed("target_left"):
		sight_angle += delta * sight_speed #PI / 4
	if Input.is_action_pressed("target_right"):
		sight_angle -= delta * sight_speed #PI / 4
	# use global coordinates, not local to node
	var sight_position = rope_length * Vector2(cos(sight_angle), -sin(sight_angle))
	var result = space_state.intersect_ray(global_position, global_position + sight_position, [ self ] )
	
	$Sight.position = sight_position
	
	if result.empty():
		$Sight.modulate = Color(1, 0, 0, 1)
	else:
		$Sight.position = result.position - global_position
		$Sight.modulate = Color(0, 1, 0, 1)
		if Input.is_action_pressed("target_up"):
			rope_attached = true
			rope_attach_position = result.position
			rope_current = (result.position - global_position).length()
			$Rope.show()
	
	if Input.is_action_pressed("target_down"):
			rope_attached = false
			rope_current = 5
			$Rope.hide()
	$Rope.rotation = (global_position - rope_attach_position).angle() - PI
	#$Rope.rotation = -sight_angle
	#$Rope.scale.x = $Sight.position.length()/100.0
	$Rope.scale.x = (global_position - rope_attach_position).length() / 100
	
# called when we hit an enemy
func die ():
	if(dead):
		return
	$Die.play()
	sprite.flip_v = true
	dead = true
	death_time = OS.get_ticks_msec()

# called when we run into a coin
func collect_coin (value):
	score += value
	ui.set_score_text(score)
	var sound_number = rng.randi_range(0, 3)
	coin_audio_array[sound_number].play()

func set_doublejump(amount):
	doubleJumpsMax = amount

func give_rope():
	$Sight.show()
	#$Rope.show()
	has_rope = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
#32,20

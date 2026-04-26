extends CharacterBody2D

const SPEED = 180.0
const JUMP_VELOCITY = -420.0
const DASH_SPEED = 1200.0 

var can_move = true
var is_dashing = false 
var can_dash = true

@onready var animated_sprite = $AnimatedSprite2D
@onready var dash_timer = $dashtimer
@onready var dash_cooldown = $DashCooldown
@onready var dash_particles = $DashParticles 

func _physics_process(delta: float) -> void:
	if not is_on_floor() and not is_dashing: 
		velocity += get_gravity() * delta

	var direction = 0.0

	if can_move:
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		
		if Input.is_action_just_pressed("dash") and can_dash:
			start_dash()

		direction = Input.get_axis("ui_left", "ui_right")
	
	if is_dashing:
		pass 
	elif direction != 0:
		velocity.x = direction * SPEED
		animated_sprite.flip_h = (direction < 0)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	update_animations(direction)

func update_animations(direction):
	if is_dashing:
		animated_sprite.play("dash")
	elif is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")

func start_dash():
	is_dashing = true
	can_move = false
	can_dash = false     
	
	dash_particles.restart() 
	dash_particles.emitting = true
	
	dash_timer.start()    
	dash_cooldown.start() 
	
	var dash_dir = -1 if animated_sprite.flip_h else 1
	velocity.x = dash_dir * DASH_SPEED
	velocity.y = 0 

func _on_dashtimer_timeout() -> void:
	is_dashing = false
	can_move = true
	velocity.x = 0

func _on_dash_cooldown_timeout() -> void:
	can_dash = true
	print("Dash ready!")

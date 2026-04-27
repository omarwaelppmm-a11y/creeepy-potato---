extends CharacterBody2D

const SPEED = 180.0
const JUMP_VELOCITY = -420.0
const DASH_SPEED = 1200.0 

var can_move = true
var is_dashing = false 
var can_dash = true
var is_attacking = false

# Health Variables
var max_health = 6
var current_health = 6
var is_invincible = false

@onready var animated_sprite = $AnimatedSprite2D
@onready var dash_timer = $dashtimer
@onready var dash_cooldown = $DashCooldown
@onready var dash_particles = $DashParticles 
@onready var attack_area = $AttackArea

func _physics_process(delta: float) -> void:
	if not is_on_floor() and not is_dashing: 
		velocity += get_gravity() * delta

	var direction = 0.0

	if can_move:
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		
		if Input.is_action_just_pressed("dash") and can_dash:
			start_dash()
			
		if Input.is_action_just_pressed("Attack") and not is_attacking:
			start_attack()

		direction = Input.get_axis("ui_left", "ui_right")
	
	if is_dashing or is_attacking:
		pass 
	elif direction != 0:
		velocity.x = direction * SPEED
		animated_sprite.flip_h = (direction < 0)
		attack_area.scale.x = -1 if direction < 0 else 1
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	update_animations(direction)

func update_animations(direction):
	if is_attacking:
		animated_sprite.play("attack")
	elif is_dashing:
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

func start_attack():
	is_attacking = true
	can_move = false
	velocity.x = 0
	attack_area.monitoring = true



func take_damage(amount):
	if is_invincible or is_dashing:
		return
		
	current_health -= amount
	print("Mox Health: ", current_health)
	
	if current_health <= 0:
		die()
	else:
		trigger_invincibility()

func trigger_invincibility():
	is_invincible = true

	for i in range(5):
		animated_sprite.modulate.a = 0.5
		await get_tree().create_timer(0.1).timeout
		animated_sprite.modulate.a = 1.0
		await get_tree().create_timer(0.1).timeout
	is_invincible = false

func die():
	print("Game Over")
	get_tree().reload_current_scene()


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.animation == "attack":
		is_attacking = false
		can_move = true
		attack_area.monitoring = false

func _on_dashtimer_timeout() -> void:
	is_dashing = false
	can_move = true
	velocity.x = 0

func _on_dash_cooldown_timeout() -> void:
	can_dash = true
	print("Dash ready!")

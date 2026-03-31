extends CharacterBody2D

# 1. CONSTANTS (The "Rules" of Mox's physics)
const SPEED = 180.0        # How fast he walks
const JUMP_VELOCITY = -400.0 # How high he jumps

# 2. NODES (Linking the script to the Sprite)
@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# 3. GRAVITY (Vertical movement)
	# If not on floor, pull Mox down using the project's gravity settings
	if not is_on_floor():
		velocity += get_gravity() * delta

	# 4. JUMPING (Vertical burst)
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# 5. HORIZONTAL MOVEMENT (Left and Right)
	# We use Godot's built-in "ui" actions (Arrow keys) to ensure it works immediately
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if direction != 0:
		# Set the horizontal speed
		velocity.x = direction * SPEED
		
		# Flip the sprite so he looks where he is going
		if direction > 0:
			animated_sprite.flip_h = false
		elif direction < 0:
			animated_sprite.flip_h = true
	else:
		# If no key is pressed, slide to a stop (Friction)
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# 6. THE ENGINE (Actually moves the character)
	move_and_slide()
	# Play animations
# Play animations
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")

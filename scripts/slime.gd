extends Node2D

const SPEED = 250
var direction = 1

@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var animated_sprite = $AnimatedSprite2D

func _process(delta):
	# 1. Check for collisions to flip direction
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true # Optional: Flips the visual
		
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false # Optional: Flips the visual back
	
	# 2. Apply movement
	position.x += direction * SPEED * delta

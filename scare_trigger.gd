
extends Area2D

# This path finds the AnimationPlayer inside your jumpscare scene
@onready var anim = $"../jumpscareui/AnimationPlayer"

func _on_body_entered(body: Node2D) -> void:
	# Check if the player "Mox" walked into the box
	if body.name == "Mox":
		anim.play("Score") # This must match your animation name exactly!
		
		# This makes the trigger disappear so it only scares once
		queue_free()

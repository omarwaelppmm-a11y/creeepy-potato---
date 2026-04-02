extends Area2D

@onready var audio_node = $AudioStreamPlayer2D
var has_played = false

func _on_body_entered(body):
	if body is CharacterBody2D and not has_played:
		start_the_scene(body)

func start_the_scene(player):
	has_played = true
	
	if "can_move" in player:
		player.can_move = false
		player.velocity = Vector2.ZERO # Stop momentum
	
	audio_node.play()
	
	await audio_node.finished
	
	if "can_move" in player:
		player.can_move = true

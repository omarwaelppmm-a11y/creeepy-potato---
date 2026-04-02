extends Area2D

@onready var vo_player = $AudioStreamPlayer2D
var triggered = false

func _on_body_entered(body):
	# Match the name "Mox" from your scene tree
	if body.name == "Mox" and not triggered:
		play_vo(body)

func play_vo(mox):
	triggered = true
	
	# Lock Mox, play the clip, wait, then unlock
	mox.can_move = false
	vo_player.play()
	
	await vo_player.finished
	
	mox.can_move = true

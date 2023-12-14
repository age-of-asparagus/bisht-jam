extends Area2D




func _on_light_switch_body_entered(body):
	$AudioStreamPlayer.play()
	if Global.lights_out:
		Global.lights_out = false
	else:
		Global.lights_out = true




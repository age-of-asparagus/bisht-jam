extends Area2D




func _on_light_switch_body_entered(body):
	if Global.lights_out:
		Global.lights_out = false
	else:
		Global.lights_out = true




extends Area2D




func _on_light_switch_body_entered(body):
	body.can_switch = true


func _on_light_switch_body_exited(body):
	body.can_switch = false

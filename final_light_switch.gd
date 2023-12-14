extends Area2D





func _on_final_light_switch_body_entered(body):
	get_tree().change_scene( "res://WinMenu.tscn" )

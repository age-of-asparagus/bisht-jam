extends Node2D

onready var tiles = get_node("tiles")
onready var enemies = get_node("enemies")

func _physics_process(delta):
	if Global.lights_out:
		tiles.show()
		enemies.hide()
		$background_color.color = Color(0,0,0)
	else:
		enemies.show()
		tiles.hide()
		$background_color.color = Color(255,255,255)


func _on_final_light_switch_body_entered(body):
	get_tree().change_scene("res://StartMenu.tscn")

extends Node2D

onready var player = get_node("player")
onready var tiles = get_node("tiles")
onready var enemies = get_node("enemies")

func _physics_process(delta):
	
	$enemy_detector/CollisionShape2D.global_position = player.global_position
	
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


func _on_enemy_detector_body_entered(body):
	body.attacking = true

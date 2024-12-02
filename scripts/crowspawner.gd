extends Node

const crow = preload("res://prefabs/crow.tscn")
@onready var timer = $Timer

func _on_timer_timeout():
	if(get_tree().has_group("diggable")):
		var c = crow.instantiate()
		get_tree().current_scene.add_child(c)
		var direction : Vector3 = Vector3(randi_range(-1,1),0,randi_range(-1,1))
		direction = direction.normalized() * 60
		direction.y = 50
		c.global_position = direction
	timer.start(randi_range(40,80))

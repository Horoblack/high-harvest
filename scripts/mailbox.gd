extends Node3D

@onready var flag = $flag
@onready var area = $Area3D

const box = preload("res://prefabs/box.tscn")

var ignore : Array

func _on_timer_timeout():
	if(InfoChecker.visibletoplayer(global_position)):
		return
		
	var delivery = area.get_overlapping_bodies()
	if(delivery != null):
		for n in delivery:
			if(!ignore.has(n) && n.is_in_group("pickup") && !n.is_in_group("heavy")):
				n.queue_free()

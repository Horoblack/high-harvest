extends fooditem

const splatter = preload("res://prefabs/bloodsplatter.tscn")
@onready var area = $Area3D
@onready var floorcheck = $floorcheck

func _on_agingtimer_timeout():
	if(age < maxage):
		area.force_shapecast_update()
		floorcheck.force_shapecast_update()
		if(floorcheck.is_colliding() && !area.is_colliding()):
			var splat = splatter.instantiate()
			get_tree().current_scene.add_child(splat)
			splat.global_position = global_position
		age += .5
	elif maxage != -1:
		data.name = "Rotten meat"

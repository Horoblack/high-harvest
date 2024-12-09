extends Node3D

@onready var cast = $ShapeCast3D
@onready var light = $"../maze/OmniLight3D2"

func monstermash():
	cast.force_shapecast_update()
	for n in cast.get_collision_count():
		if(cast.get_collider(n) is wickerman):
			cast.get_collider(n).active = true


func _on_area_3d_body_exited(body):
	if(body.is_in_group("totem")):
		monstermash()
		light.light_color = Color.RED

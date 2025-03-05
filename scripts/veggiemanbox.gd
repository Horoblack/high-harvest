extends basepickup

@export var contents : Array[String]

func trigger(pl : PlayerCam):
	for n in contents:
		var ob = Library.objs[n].instantiate()
		get_tree().current_scene.add_child(ob)
		ob.global_position = global_position
		ob.global_rotation = global_rotation
	queue_free()

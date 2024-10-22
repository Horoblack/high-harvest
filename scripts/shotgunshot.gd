extends RayCast3D

var ignore

func execute():
	force_raycast_update()
	var col = get_collider()
	if(col == null || ignore.has(col)):
		queue_free()
		return
	ignore.append(col)
	if(col != null && col.has_method("murder")):
		col.murder()
	if(col is RigidBody3D):
		col.apply_impulse(-global_basis.z*6)
	queue_free()

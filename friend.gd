extends MeshInstance3D

var offset = 30.0

func _process(delta):
	global_position = get_parent().global_position + Vector3(offset,1.5,offset)
	global_rotation = Vector3.ZERO
	if(!InfoChecker.visibletoplayer(global_position)):
		offset -= delta * .5
		offset = clampf(offset,.1,99)

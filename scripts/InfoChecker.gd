extends Node

var pl : Node3D

func visibletoplayer(position : Vector3) -> bool:
	if(pl == null):
		pl = get_tree().get_first_node_in_group("player")
		if(pl == null):
			return false
	
	var dir = pl.global_position.direction_to(position)
	return pl.basis.z.dot(dir) < 0

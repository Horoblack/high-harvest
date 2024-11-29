extends Node

var scrcw

func _ready():
	var group = get_tree().get_nodes_in_group("scarecrow")
	if(group.is_empty()):
		queue_free()
		return
	else:
		scrcw = group.pick_random()
		var player = get_tree().get_first_node_in_group("player")
		var pos = player.global_position - player.global_basis.z
		pos.y = player.global_position.y + .7
		scrcw.global_position = pos
		scrcw.global_rotation = player.global_rotation

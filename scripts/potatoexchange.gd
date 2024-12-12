extends Node

func _ready():
	for n in get_tree().get_nodes_in_group("diggable"):
		if(n is crop && n.dropaddress == "potato"):
			n.dropaddress = "potatoling"
	queue_free()

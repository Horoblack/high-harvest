extends Node

func _ready():
	deserializeall()

func serializeall():
	var list : Array
	var allobjs = get_tree().get_nodes_in_group("pickup")
	for n in allobjs:
		if(n.has_meta("obj")):
			var data : InventoryObject = n.get_meta("obj")
			list.append([n.global_position, n.global_rotation, data.objaddress, data.customproperties])
	Savedata.gamedata["objects"] = list
	Savedata.save_data()

func deserializeall():
	Savedata.load_data()
	var list = Savedata.gamedata["objects"].duplicate()
	for n in list:
		var obj = Library.objs[n[2]].instantiate()
		get_tree().current_scene.add_child(obj)
		obj.global_position = n[0]
		obj.global_rotation = n[1]
		var data = obj.get_meta("obj")
		data.customproperties = n[3]
		obj.set_meta("obj", data)

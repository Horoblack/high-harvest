extends Node

func _ready():
	deserializeall()

### CROPS AREN'T GETTING SAVED AND LOADED BECAUSE THEY'RE NOT PICKUPS. FIX LATER
func serializeall():
	var list : Array
	var allobjs = get_tree().get_nodes_in_group("pickup")
	for n in allobjs:
		if(n.has_meta("obj")):
			var data : InventoryObject = n.get_meta("obj")
			list.append(["pickup", n.global_position, n.global_rotation, data.objaddress, data.customproperties])
	
	var serquests = get_tree().get_nodes_in_group("serialize")
	for n in serquests:
		if(n is crop):
			list.append(["crop", n.global_position, n.global_rotation, n.seedaddress, n.curtime])
		if(n is crophole):
			list.append(["crop", n.global_position, n.global_rotation, "crophole"])
	
	Savedata.gamedata["objects"] = list
	Savedata.save_data()

func deserializeall():
	Savedata.load_data()
	var list = Savedata.gamedata["objects"].duplicate()
	for n in list:
		match(n[0]):
			"pickup":
				var obj = Library.objs[n[3]].instantiate()
				get_tree().current_scene.add_child(obj)
				obj.global_position = n[1]
				obj.global_rotation = n[2]
				var data = obj.get_meta("obj").duplicate()
				data.customproperties = n[4]
				obj.set_meta("obj", data)
			"crop":
				var obj = Library.crops[n[3]].instantiate()
				get_tree().current_scene.add_child(obj)
				obj.global_position = n[1]
				obj.global_rotation = n[2]
		

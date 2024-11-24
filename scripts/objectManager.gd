extends Node

func serializeall():
	var list : Array
	var player : Player = get_tree().get_first_node_in_group("player")
	var plinventory = []
	for n : InventoryObject in player.cam.inventory.invlist:
		plinventory.append([n.objaddress, n.customproperties])
	list.append(["player", player.global_position, player.global_basis, plinventory])
	
	var allobjs = get_tree().get_nodes_in_group("pickup")
	for n in allobjs:
		if(n.has_meta("obj")):
			var data : InventoryObject = n.get_meta("obj")
			if(data.objaddress == ""):
				return
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
	#Savedata.delete_data()
	Savedata.load_data()
	get_tree().current_scene.get_node("%day manager").timeofday = Savedata.gamedata["timeofday"]
	
	var list = Savedata.gamedata["objects"].duplicate()
	for n in list:
		match(n[0]):
			"player":
				var player : Player = get_tree().get_first_node_in_group("player")
				var plinventory = []
				for i in n[3]:
					var data : InventoryObject = Library.invobjs[i[0]].duplicate()
					data.customproperties = i[1]
					plinventory.append(data)
				player.global_position = n[1]
				player.global_basis = n[2]
				player.cam.inventory.invlist = plinventory
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
				if(obj is crop):
					obj.curtime = n[4]
				obj.global_position = n[1]
				obj.global_rotation = n[2]

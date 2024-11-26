extends Node

func serializeall():
	var list : Array
	var player : Player = get_tree().get_first_node_in_group("player")
	var plinventory = []
	var playerhand = []
	var playergrabbed = []
	var excludehand = null
	var excludegrabbed = null
	for n : InventoryObject in player.cam.inventory.invlist:
		plinventory.append([n.objaddress, n.customproperties])
	if player.cam.held != null && player.cam.held.has_meta("obj"):
		excludehand = player.cam.held
		var data : InventoryObject = player.cam.held.get_meta("obj")
		playerhand = [data.objaddress,data.customproperties]
	if(player.cam.grabbed != null && player.cam.grabbed.has_meta("obj")):
		excludegrabbed = player.cam.grabbed
		var data : InventoryObject = player.cam.grabbed.get_meta("obj")
		playergrabbed = [data.objaddress,data.customproperties]
	list.append(["player", player.global_position, player.global_basis, plinventory, playerhand,playergrabbed])
	
	var allobjs = get_tree().get_nodes_in_group("pickup")
	if(excludehand != null):
		allobjs.erase(excludehand)
	if(excludegrabbed != null):
		allobjs.erase(excludegrabbed)
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
	
	Savedata.gamedata["objects%s"%Savedata.gamedata["playerscene"]] = list
	#Savedata.save_data()

func deserializeall():
	#Savedata.delete_data()
	Savedata.load_data()
	get_tree().current_scene.get_node("%day manager").timeofday = Savedata.gamedata["timeofday"]
	
	if(!Savedata.gamedata.has("objects%s"%Savedata.gamedata["playerscene"])):
		return
	
	var list = Savedata.gamedata["objects%s"%Savedata.gamedata["playerscene"]].duplicate()
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
				if(!n[4].is_empty()):
					var obj = Library.objs[n[4][0]].instantiate()
					var data = obj.get_meta("obj").duplicate()
					data.customproperties = n[4][1]
					obj.set_meta("obj", data)
					get_tree().current_scene.add_child(obj)
					player.cam.grabbed = obj
					player.cam.holdobj()
				if(!n[5].is_empty()):
					var obj = Library.objs[n[5][0]].instantiate()
					var data = obj.get_meta("obj").duplicate()
					data.customproperties = n[5][1]
					obj.set_meta("obj", data)
					get_tree().current_scene.add_child(obj)
					obj.global_position = player.global_position + -player.global_basis.z
					player.cam.grabobj(obj)
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

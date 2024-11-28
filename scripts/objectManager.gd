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

	list.append(["player", player.global_position, player.global_rotation, player.energy,player.hunger,plinventory, playerhand,playergrabbed])
	
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
		if(n.has_meta("objaddress")):
			var props = {}
			if(n.has_meta("customproperties")):
				props = n.get_meta("customproperties")
			list.append(["other", n.get_meta("objaddress"),n.global_position,n.global_rotation,props])
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
				for i in n[5]:
					var data : InventoryObject = Library.invobjs[i[0]].duplicate()
					data.customproperties = i[1]
					plinventory.append(data)
				player.global_position = n[1]
				player.global_rotation = n[2]
				player.energy = n[3]
				player.hunger = n[4]
				player.cam.forceupdaterotation()
				player.cam.inventory.invlist = plinventory
				if(!n[6].is_empty()):
					var obj = Library.objs[n[6][0]].instantiate()
					var data = obj.get_meta("obj").duplicate()
					data.customproperties = n[6][1]
					obj.set_meta("obj", data)
					get_tree().current_scene.add_child(obj)
					player.cam.grabbed = obj
					player.cam.holdobj()
				if(!n[7].is_empty()):
					var obj = Library.objs[n[7][0]].instantiate()
					var data = obj.get_meta("obj").duplicate()
					data.customproperties = n[7][1]
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
			"other":
				var obj :Node3D = Library.others[n[1]].instantiate()
				get_tree().current_scene.add_child(obj)
				obj.global_position = n[2]
				obj.global_rotation = n[3]
				if(n.size() > 4 && !n[4].is_empty()):
					obj.set_meta("customproperties", n[4])

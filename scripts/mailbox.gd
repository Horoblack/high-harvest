extends Node3D

@onready var flag = $flag
@onready var lid = $lid
@onready var area = $Area3D
@onready var letterspawn = $letterspawn
@onready var boxspawn = $boxspawn

var ignore : Array

func _ready():
	%"day manager".day.connect(spawnflyer)

func _on_timer_timeout():
	if(InfoChecker.visibletoplayer(global_position)):
		return
	var delivery : Array = area.get_overlapping_bodies()
	delivery.erase(lid)
	var usedturn : bool = false
	if(delivery != null && !delivery.is_empty()):
		for n in delivery:
			if(!ignore.has(n) && n is box): #.is_in_group("pickup") && !n.is_in_group("heavy")
				usedturn = true
				spawnletter(n.inventory)
				n.queue_free()
			if(!ignore.has(n) && n is storeflyer && !n.buyingselection.is_empty()):
				var totalprice : float = 0
				for i in n.buyingselection:
					totalprice += Library.purchasables[i]
				
				if(Savedata.gamedata["money"] - totalprice >= 0):
					usedturn = true
					Savedata.gamedata["money"] -= totalprice
					var bx : box = Library.objs["box"].instantiate()
					ignore.append(bx)
					var receipt : InventoryObject = Library.invobjs["receipt"].duplicate()
					receipt.customproperties["text"] = "Thank you for your purchase.\nYour new balance is $%s." % Savedata.gamedata["money"]
					bx.inventory.append(receipt)
					for i in n.buyingselection:
						for q in n.buyingselection[i]:
							bx.inventory.append(Library.invobjs[i].duplicate())
					get_tree().current_scene.add_child(bx)
					bx.global_position = boxspawn.global_position
					bx.global_rotation = boxspawn.global_rotation
					n.queue_free()
			elif(n is storeflyer):
				usedturn = true
	if(!usedturn):
		flag.rotation_degrees = Vector3(0,0,90)
		lid.rotation_degrees = Vector3.ZERO
		spawnflyer()

func spawnletter(solditems : Array):
	flag.rotation_degrees = Vector3.ZERO
	var itemamounts : Dictionary
	for n : InventoryObject in solditems:
		var pp = n.name.to_lower()
		if(n.customproperties.has("sellmod")):
			pp = n.customproperties["sellmod"]
		if(!itemamounts.has(pp)):
			itemamounts[pp] = 0
		itemamounts[pp] += 1
	#print(itemamounts)
	var str = "Thank you for your contribution.\n\n\n"
	for n in itemamounts:
		var amt : float = Library.sell(n)
		if(Savedata.gamedata.daysales.has(n)):
			Savedata.gamedata.daysales[n] += itemamounts[n]
		for b in itemamounts[n]:
			str += "\n%s : $%.2f" % [n, amt]
	str += "\n\nYour new total balance is: $%.2f\n" % Savedata.gamedata["money"]
	if(!Savedata.gamedata["debtpaid"] && Savedata.gamedata["money"] >= Library.debt):
		Savedata.gamedata["debtpaid"] = true
		Savedata.gamedata["money"] -= Library.debt
		var bx : box = Library.objs["box"].instantiate()
		ignore.append(bx)
		var receipt : InventoryObject = Library.invobjs["receipt"].duplicate()
		receipt.customproperties["text"] = "Your debt is paid. A commemorative plaque has been issued."
		bx.inventory.append(receipt)
		var obj = Library.invobjs["plaque"].duplicate()
		obj.customproperties["timeplayed"] = Savedata.gamedata["playtime"]
		obj.customproperties["moneyearned"] = Savedata.gamedata["totalmoney"]
		bx.inventory.append(obj)
		get_tree().current_scene.add_child(bx)
		bx.global_position = boxspawn.global_position
		bx.global_rotation = boxspawn.global_rotation
	if(!Savedata.gamedata["debtpaid"]):
		str += ("Your total debt is %f. " % Library.debt)
	
	var letter : bankstatement = Library.objs["bankstatement"].instantiate()
	get_tree().current_scene.add_child(letter)
	
	letter.text(str)
	letter.global_position = letterspawn.global_position
	letter.global_rotation = letterspawn.global_rotation

func spawnflyer():
	var flyer : storeflyer = Library.objs["storeflyer"].instantiate()
	#ignore.append(flyer)
	get_tree().current_scene.add_child(flyer)
	flyer.global_position = letterspawn.global_position
	flyer.global_rotation = letterspawn.global_rotation


func _on_area_3d_body_exited(body: Node3D) -> void:
	ignore.erase(body)

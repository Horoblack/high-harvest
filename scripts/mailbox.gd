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
				
				if(Savedata.gamedata["money"] - totalprice >= -20):
					usedturn = true
					Savedata.gamedata["money"] -= totalprice
					var bx : box = Library.objs["box"].instantiate()
					ignore.append(bx)
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
		ignore.clear()
		spawnflyer()

func spawnletter(solditems : Array):
	flag.rotation_degrees = Vector3.ZERO
	var itemamounts : Dictionary
	for n : InventoryObject in solditems:
		if(!itemamounts.has(n)):
			itemamounts[n] = 0
		itemamounts[n] += 1
	
	var str = "Thank you for your contribution.\n\n\n"
	for n in itemamounts:
		var pp = n.name.to_lower()
		if(n.customproperties.has("sellmod")):
			pp = n.customproperties["sellmod"]
		
		var amt : float = Library.sell(pp,itemamounts[n])
		for b in itemamounts[n]:
			str += "%s : $%.2f\n" % [pp, amt]
		str += "\n\nYour new total balance is: $%.2f" % Savedata.gamedata["money"]
	
	var letter : bankstatement = Library.objs["bankstatement"].instantiate()
	get_tree().current_scene.add_child(letter)
	
	letter.text(str)
	letter.global_position = letterspawn.global_position
	letter.global_rotation = letterspawn.global_rotation

func spawnflyer():
	var flyer : storeflyer = Library.objs["storeflyer"].instantiate()
	ignore.append(flyer)
	get_tree().current_scene.add_child(flyer)
	flyer.global_position = letterspawn.global_position
	flyer.global_rotation = letterspawn.global_rotation

extends Node

var objs : Dictionary = {
	"shovel":load("res://prefabs/shovel.tscn"),
	"carrot":load("res://prefabs/carrot.tscn"),
	"carrotseed":load("res://prefabs/seedstuff/carrotseed.tscn"),
	"carrotseedbag":load("res://prefabs/seedstuff/carrotseedbag.tscn"),
	"tomatoseedbag":load("res://prefabs/seedstuff/tomatoseedbag.tscn"),
	"tomatoseed":load("res://prefabs/seedstuff/tomatoseed.tscn"),
	"tomato":load("res://prefabs/tomato.tscn"),
	"wateringcan":load("res://prefabs/watering_can.tscn"),
	"box":load("res://prefabs/box.tscn"),
	"boxlid":load("res://prefabs/lid.tscn"),
	"chicken":load("res://prefabs/chicken.tscn"),
	"rooster":load("res://prefabs/rooster.tscn"),
	"egg":load("res://prefabs/egg.tscn"),
	"bankstatement":load("res://prefabs/bankstatement.tscn"),
	"storeflyer":load("res://prefabs/storeflyer.tscn"),
	"trashcan":load("res://prefabs/trashcan.tscn"),
	"trashbag":load("res://prefabs/trashbag.tscn"),
	"newtrashbag":load("res://prefabs/newtrashbag.tscn"),
	"shotgun":load("res://prefabs/shotgun.tscn"),
	"ammobox":load("res://prefabs/ammobox.tscn"),
	"chickenmeat":load("res://prefabs/chickenmeat.tscn"),
	"calendar":load("res://prefabs/calendar.tscn"),
	"nail":load("res://prefabs/nail.tscn"),
}

var invobjs : Dictionary = {
	"shovel":load("res://invobjs/shovel.tres"),
	"carrot":load("res://invobjs/carrot.tres"),
	"carrotseed":load("res://invobjs/carrotseed.tres"),
	"carrotseedbag":load("res://invobjs/carrotseedbag.tres"),
	"tomatoseed":load("res://invobjs/tomatoseed.tres"),
	"tomatoseedbag":load("res://invobjs/tomatoseedbag.tres"),
	"wateringcan":load("res://invobjs/wateringcan.tres"),
	"box":load("res://invobjs/box.tres"),
	"boxlid":load("res://invobjs/lid.tres"),
	"chicken":load("res://invobjs/chicken.tres"),
	"rooster":load("res://invobjs/rooster.tres"),
	"egg":load("res://invobjs/egg.tres"),
	"trashcan":load("res://invobjs/trashcan.tres"),
	"trashbag":load("res://invobjs/trashbag.tres"),
	"newtrashbag":load("res://invobjs/newtrashbag.tres"),
	"shotgun":load("res://invobjs/shotgun.tres"),
	"ammobox":load("res://invobjs/ammobox.tres"),
	"chickenmeat":load("res://invobjs/chickenmeat.tres"),
	"calendar":load("res://invobjs/calendar.tres"),
	"nail":load("res://invobjs/nail.tres"),
}

var purchasables : Dictionary = {
	"carrotseedbag" = 10.0,
	"tomatoseedbag" = 10.0,
	"shovel" = 9.0,
	"wateringcan" = 8.0,
	"chicken" = 17.0,
	"rooster" = 20.0,
	"newtrashbag" = 5.0,
	"trashcan" = 10.0,
	"shotgun" = 30.0,
	"ammobox" = 5.0,
	"nail" = 1.0,
	"calendar" = 10.0,
}

var sellvalues : Dictionary = {
	"carrot" = 5.0,
	"tomato" = 5.0,
	"egg" = 5.0,
	"trashbag" = 1.0,
	"ammobox" = 5.0,
	"used ammobox" = 0.99,
	"chickenmeat" = 10.0,
	"rotten meat" = 0.00
}

const crops : Dictionary = {
	"crophole":preload("res://prefabs/crops/hole.tscn"),
	"carrotseed":preload("res://prefabs/crops/carrotcrop.tscn"),
	"tomatoseed":preload("res://prefabs/crops/tomatocrop.tscn")
}

func sell(item : String, amount : int) -> float:
	if(Library.sellvalues.has(item)):
		if(Savedata.gamedata["stocks"].has(item)):
			var returnvalue = Library.sellvalues[item] * Savedata.gamedata["stocks"][item]
			returnvalue = snapped(returnvalue,.01)
			Savedata.gamedata["money"] += returnvalue * amount
			Savedata.gamedata["stocks"][item] = clamp(Savedata.gamedata["stocks"][item] - (0.05 * amount),0.5,2)
			return returnvalue
		else:
			return Library.sellvalues[item]
	elif(Library.purchasables.has(item)):
		return Library.purchasables[item]
	else:
		return 0

func marketmutate():
	for n in Savedata.gamedata["stocks"]:
		var rng = randi_range(-3,5) / 10
		Savedata.gamedata["stocks"][n] = clamp(Savedata.gamedata["stocks"][n] + rng,0.5,2)

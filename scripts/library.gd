extends Node

var objs : Dictionary = {
	"shovel":load("res://prefabs/shovel.tscn"),
	"potato":load("res://prefabs/potato.tscn"),
	"dicedpotato":load("res://prefabs/dicedpotato.tscn"),
	"carrot":load("res://prefabs/carrot.tscn"),
	"carrotseed":load("res://prefabs/seedstuff/carrotseed.tscn"),
	"carrotseedbag":load("res://prefabs/seedstuff/carrotseedbag.tscn"),
	"dicedcarrot":load("res://prefabs/dicedcarrot.tscn"),
	"tomato":load("res://prefabs/tomato.tscn"),
	"tomatoseed":load("res://prefabs/seedstuff/tomatoseed.tscn"),
	"tomatoseedbag":load("res://prefabs/seedstuff/tomatoseedbag.tscn"),
	"dicedtomato":load("res://prefabs/dicedtomato.tscn"),
	"turnip":load("res://prefabs/turnip.tscn"),
	"turnipseed":load("res://prefabs/seedstuff/turnipseed.tscn"),
	"turnipseedbag":load("res://prefabs/seedstuff/turnipseedbag.tscn"),
	"dicedturnip":load("res://prefabs/dicedturnip.tscn"),
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
	"crowmeat":load("res://prefabs/crowmeat.tscn"),
	"pigmeat":load("res://prefabs/pigmeat.tscn"),
	"calendar":load("res://prefabs/calendar.tscn"),
	"nail":load("res://prefabs/nail.tscn"),
	"dice":load("res://prefabs/dice.tscn"),
	"knife":load("res://prefabs/knife.tscn"),
	"bowl":load("res://prefabs/bowl.tscn"),
	"crow":load("res://prefabs/crow.tscn"),
	"lantern":load("res://prefabs/lantern.tscn"),
	"oilbottle":load("res://prefabs/oilbottle.tscn"),
}

var invobjs : Dictionary = {
	"shovel":load("res://invobjs/shovel.tres"),
	"potato":load("res://invobjs/potato.tres"),
	"dicedpotato":load("res://invobjs/dicedpotato.tres"),
	"carrot":load("res://invobjs/carrot.tres"),
	"carrotseed":load("res://invobjs/carrotseed.tres"),
	"carrotseedbag":load("res://invobjs/carrotseedbag.tres"),
	"dicedcarrot":load("res://invobjs/dicedcarrot.tres"),
	"tomato":load("res://invobjs/tomato.tres"),
	"tomatoseed":load("res://invobjs/tomatoseed.tres"),
	"tomatoseedbag":load("res://invobjs/tomatoseedbag.tres"),
	"dicedtomato":load("res://invobjs/dicedtomato.tres"),
	"turnip":load("res://invobjs/turnip.tres"),
	"turnipseed":load("res://invobjs/turnipseed.tres"),
	"turnipseedbag":load("res://invobjs/turnipseedbag.tres"),
	"dicedturnip":load("res://invobjs/dicedturnip.tres"),
	"wateringcan":load("res://invobjs/wateringcan.tres"),
	"storeflyer":load("res://invobjs/storeflyer.tres"),
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
	"crowmeat":load("res://invobjs/crowmeat.tres"),
	"pigmeat":load("res://invobjs/pigmeat.tres"),
	"calendar":load("res://invobjs/calendar.tres"),
	"nail":load("res://invobjs/nail.tres"),
	"dice":load("res://invobjs/dice.tres"),
	"knife":load("res://invobjs/knife.tres"),
	"bowl":load("res://invobjs/bowl.tres"),
	"crow":load("res://invobjs/crow.tres"),
	"lantern":load("res://invobjs/lantern.tres"),
	"oilbottle":load("res://invobjs/oilbottle.tres"),
}

var purchasables : Dictionary = {
	"carrotseedbag" = 10.0,
	"tomatoseedbag" = 10.0,
	"turnipseedbag" = 10.0,
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
	"dice" = 1.0,
	"lantern" = 40.0,
	"oilbottle" = 10.0,
}

var sellvalues : Dictionary = {
	"carrot" = 5.0,
	"tomato" = 5.0,
	"turnip" = 5.0,
	"egg" = 5.0,
	"trashbag" = 1.0,
	"ammobox" = 5.0,
	"used ammobox" = 0.99,
	"chickenmeat" = 10.0,
	"crowmeat" = 6.0,
	"pigmeat" = 10.0,
	"rotten meat" = 0.00
}

const crops : Dictionary = {
	"crophole":preload("res://prefabs/crops/hole.tscn"),
	"carrotseed":preload("res://prefabs/crops/carrotcrop.tscn"),
	"tomatoseed":preload("res://prefabs/crops/tomatocrop.tscn"),
	"turnipseed":preload("res://prefabs/crops/turnipcrop.tscn"),
	"dicedpotato":preload("res://prefabs/crops/potatocrop.tscn"),
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

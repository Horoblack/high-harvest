extends Node

var objs : Dictionary = {
	"shovel":load("res://prefabs/shovel.tscn"),
	"carrot":load("res://prefabs/carrot.tscn"),
	"carrotseed":load("res://prefabs/seedstuff/carrotseed.tscn"),
	"carrotseedbag":load("res://prefabs/seedstuff/carrotseedbag.tscn"),
	"tomatoseed":load("res://prefabs/seedstuff/tomatoseed.tscn"),
	"tomato":load("res://prefabs/tomato.tscn"),
	"wateringcan":load("res://prefabs/watering_can.tscn"),
	"box":load("res://prefabs/box.tscn"),
	"boxlid":load("res://prefabs/lid.tscn"),
	"chicken":load("res://prefabs/chicken.tscn"),
	"rooster":load("res://prefabs/rooster.tscn"),
	"egg":load("res://prefabs/egg.tscn"),
	"bankstatement":load("res://prefabs/bankstatement.tscn")
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
}

var purchasables : Dictionary = {
	"carrotseedbag" = 10,
	"tomatoseedbag" = 10,
	"shovel" = 9,
	"wateringcan" = 8,
	"chicken" = 17,
	"rooster" = 20
}

const crops : Dictionary = {
	"carrotseed":preload("res://prefabs/crops/carrotcrop.tscn"),
	"tomatoseed":preload("res://prefabs/crops/tomatocrop.tscn")
}

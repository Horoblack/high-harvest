extends Node

var objs : Dictionary = {
	"shovel":load("res://prefabs/shovel.tscn"),
	"carrot":load("res://prefabs/carrot.tscn"),
	"carrotseed":load("res://prefabs/carrotseed.tscn"),
	"wateringcan":load("res://prefabs/watering_can.tscn"),
	"box":load("res://prefabs/box.tscn"),
	"boxlid":load("res://prefabs/lid.tscn"),
	"chicken":load("res://prefabs/chicken.tscn"),
	"rooster":load("res://prefabs/rooster.tscn"),
	"egg":load("res://prefabs/egg.tscn")
}

var invobjs : Dictionary = {
	"shovel":load("res://invobjs/shovel.tscn"),
	"carrot":load("res://invobjs/carrot.tscn"),
	"carrotseed":load("res://invobjs/carrotseed.tscn"),
	"wateringcan":load("res://invobjs/wateringcan.tscn"),
	"box":load("res://invobjs/box.tscn"),
	"boxlid":load("res://invobjs/lid.tscn"),
	"chicken":load("res://invobjs/chicken.tscn"),
	"rooster":load("res://invobjs/rooster.tscn"),
	"egg":load("res://invobjs/egg.tscn")
}

const crops : Dictionary = {
	"carrotseed":preload("res://prefabs/carrotcrop.tscn")
}

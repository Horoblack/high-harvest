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
	"egg":load("res://prefabs/egg.tscn"),
	"bankstatement":load("res://prefabs/bankstatement.tscn")
}

var invobjs : Dictionary = {
	"shovel":load("res://invobjs/shovel.tres"),
	"carrot":load("res://invobjs/carrot.tres"),
	"carrotseed":load("res://invobjs/carrotseed.tres"),
	"wateringcan":load("res://invobjs/wateringcan.tres"),
	"box":load("res://invobjs/box.tres"),
	"boxlid":load("res://invobjs/lid.tres"),
	"chicken":load("res://invobjs/chicken.tres"),
	"rooster":load("res://invobjs/rooster.tres"),
	"egg":load("res://invobjs/egg.tres")
}

const crops : Dictionary = {
	"carrotseed":preload("res://prefabs/carrotcrop.tscn")
}

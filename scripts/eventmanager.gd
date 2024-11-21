extends Node

@export var events : Array[eventClass]

var curevent

func _ready() -> void:
	events = events.filter(func(a:eventClass): return !a.singletime || !Savedata.gamedata["seenevents"].contains(a.eventname))

func chooseevent():
	if(events.is_empty()):
		return
	curevent = events.pick_random()

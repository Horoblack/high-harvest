extends Node

@export var events : Array[eventClass]

var curevent : eventClass 
var curobj : Node

func _ready() -> void:
	events = events.filter(func(a:eventClass): return !a.singletime || !Savedata.gamedata["seenevents"].contains(a.eventname))

func _process(delta: float) -> void:
	if(curobj == null && curevent != null):
		curevent = null

func chooseevent():
	if(events.is_empty() || curevent != null):
		return
	curevent = events.pick_random()
	var curobj = curevent.object.instantiate()
	get_tree().current_scene.add_child(curobj)
	if(curevent.singletime):
		Savedata.gamedata["seenevents"].append(curevent.eventname)

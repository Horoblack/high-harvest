extends Node

@export var events : Array[eventClass]

var curevent : eventClass 
var curobj : Node

var targettime : int = -1

func _ready() -> void:
	%"day manager".day.connect(func(): if(randi_range(0,1)==0):chooseevent())
	events = events.filter(func(a:eventClass): return !a.singletime || !Savedata.gamedata["seenevents"].has(a.eventname))

func _process(delta: float) -> void:
	if(curobj == null && curevent != null):
		curevent = null
	if(curevent != null):
		if(%"day manager".timeofday >= targettime && targettime != -1):
			spawnit()
			targettime = -1

func chooseevent():
	if(events.is_empty() || curevent != null):
		return
	curevent = events.pick_random()
	targettime = randi_range(curevent.timerange.x,curevent.timerange.y)

func spawnit():
	if(curevent == null):
		return
	var curobj = curevent.object.instantiate()
	get_tree().current_scene.add_child(curobj)
	curobj.global_position = curevent.position
	if(curevent.singletime):
		Savedata.gamedata["seenevents"].append(curevent.eventname)

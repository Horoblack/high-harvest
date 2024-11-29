extends Node

@export_range(0,2400,1) var timeofday : float = 1200.0
@export var simulate : bool = false
@export_range(0,1,.05) var rateoftime : float = .1
@export var sunlightcurve : Curve
@export var moonlightcurve : Curve

@export var sun : DirectionalLight3D
@export var moon  : DirectionalLight3D

var curtick = 0

var sunenergy
var moonenergy

func _ready() -> void:
	timeofday = Savedata.gamedata["timeofday"]

func _process(delta):
	if(simulate):
		timeofday += rateoftime
	if(timeofday >= 2400):
		passday()
	Savedata.gamedata["timeofday"] = timeofday
	Savedata.gamedata["playtime"] += delta
	
	if(sun != null):
		sun.light_energy = sunlightcurve.sample(timeofday/2400)
		sun.rotation_degrees.x = lerp(90,-270, timeofday / 2400)
	if(moon != null):
		moon.light_energy = moonlightcurve.sample(timeofday/2400)

signal day
func passday():
	timeofday = 0
	Library.marketmutate()
	Savedata.gamedata["day"] += 1
	day.emit()

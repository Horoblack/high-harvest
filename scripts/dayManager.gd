extends WorldEnvironment

@export_range(0,2400,1) var timeofday : float = 1200.0
@export var simulate : bool = false
@export_range(0,10,.1) var rateoftime : float = .1
@export var sunlightcurve : Curve
@export var moonlightcurve : Curve

@onready var sun = $DirectionalLight3D
@onready var moon = $DirectionalLight3D/DirectionalLight3D2

var curtick = 0

var sunenergy
var moonenergy

func _process(delta):
	if(simulate):
		timeofday += rateoftime
	if(timeofday >= 2400):
		passday()
	Savedata.gamedata["timeofday"] = timeofday
	Savedata.gamedata["playtime"] += delta
	
	sun.light_energy = sunlightcurve.sample(timeofday/2400)
	moon.light_energy = moonlightcurve.sample(timeofday/2400)
	sun.rotation_degrees.x = lerp(90,-270, timeofday / 2400)

signal day
func passday():
	timeofday = 0
	Library.marketmutate()
	Savedata.gamedata["day"] += 1
	day.emit()

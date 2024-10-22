extends WorldEnvironment

@export_range(0,2400,1) var timeofday : float = 1200.0
@export var simulate : bool = false
@export_range(0,10,.1) var rateoftime : float = .1

@onready var sun = $DirectionalLight3D

var curtick = 0
func _process(delta):
	if(simulate):
		timeofday += rateoftime
		if(timeofday >= curtick + 1):
			curtick = curtick + 1
			tick.emit()
	if(timeofday >= 2400):
		passday()
	sun.light_energy = 1 if timeofday > 800 && timeofday < 1900 else 0
	sun.rotation_degrees.x = lerp(90,-270, timeofday / 2400)

signal tick

signal day
func passday():
	timeofday = 0
	Library.marketmutate()
	day.emit()

extends RigidBody3D

const droplet = preload("res://prefabs/water_drop.tscn")

@onready var nozzlepos = $nozzlepos
@onready var timer = $Timer

var watercount : float = 5
var maxwater : float = 10

func _ready():
	await get_tree().process_frame
	set_meta("obj", get_meta("obj").duplicate())
	if(get_meta("obj").customproperties.has("water")):
		watercount = get_meta("obj").customproperties["water"]
	else:
		watercount = 0
		var data : InventoryObject = get_meta("obj")
		data.customproperties["water"] = watercount
		set_meta("obj", data)

func _physics_process(delta):
	if(nozzlepos.global_basis.z.dot(Vector3.DOWN) < -0.1):
		if(timer.is_stopped()):
			timer.start()
	else:
		if(!timer.is_stopped()):
			timer.stop()

func _on_timer_timeout():
	if(watercount > 0):
		watercount -= .1
		var data : InventoryObject = get_meta("obj")
		data.customproperties["water"] = watercount
		set_meta("obj", data)
		var drop = droplet.instantiate()
		get_tree().current_scene.add_child(drop)
		drop.global_position = nozzlepos.global_position - (nozzlepos.global_basis.z*.1)
		drop.apply_central_impulse(-nozzlepos.global_basis.z * 10)
	else:
		watercount = 0

func water():
	watercount = clamp(watercount+.1, 0, maxwater)

func info() -> String:
	return ("%.1f" % watercount) + " / " + ("%.1f" % maxwater)

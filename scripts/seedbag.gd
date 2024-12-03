extends basepickup

@onready var grabarea = $grabarea

@export var seedaddress : String

var seedcount : int = 10
var pl : PlayerCam
var data

func _ready():
	super()
	grabarea.grabbed.connect(removeitem)
	await get_tree().process_frame
	data = get_meta("obj").duplicate()
	if(data.customproperties.has("seedcount")):
		seedcount = data.customproperties["seedcount"]
	else:
		data.customproperties["seedcount"] = seedcount
	set_meta("obj", data)

func hold(holder):
	pl = holder

func trigger(pl):
	if(pl.cast.is_colliding()):
		removeitem(null, pl.cast.get_collision_point())
	else:
		removeitem(null, pl.global_position + (-pl.global_basis.z * 3))

func removeitem(bod : Player, pos : Vector3 = Vector3.ZERO):
	if(seedcount > 0):
		var physitem = Library.objs[seedaddress].instantiate()
		seedcount -= 1
		if(bod != null):
			bod.cam.grabobj(physitem)
		get_tree().current_scene.add_child(physitem)
		if(pos == Vector3.ZERO):
			physitem.global_position = global_position
		else:
			physitem.global_position = pos
		updatedata()


func updatedata():
	if(data == null):
		data = get_meta("obj").duplicate()
	data.customproperties["seedcount"] = seedcount
	set_meta("obj", data)

func info() -> String:
	return ("seeds left: " + str(seedcount))

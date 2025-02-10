extends basepickup

var beers : int = 6

var data

func _ready():
	super()
	await get_tree().process_frame
	data = get_meta("obj").duplicate()
	if(data.customproperties.has("beers")):
		beers = data.customproperties["beers"]
	else:
		data.customproperties["beers"] = beers
	set_meta("obj", data)

func trigger(pl : PlayerCam):
	if(beers > 0):
		beers -= 1
		updatedata()
		var physitem = Library.objs["beer"].instantiate()
		get_tree().current_scene.add_child(physitem)
		if(pl.cast.is_colliding()):
			physitem.global_position = pl.cast.get_collision_point()
		else:
			physitem.global_position = pl.global_position + (-pl.global_basis.z * 3)

func updatedata():
	if(data == null):
		data = get_meta("obj").duplicate()
	data.customproperties["beers"] = beers
	if(beers < 6):
		data.customproperties["sellmod"] = "usedsixpack"
	set_meta("obj", data)

func info() -> String:
	return ("beers left: " + str(beers))

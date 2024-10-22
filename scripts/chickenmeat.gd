extends RigidBody3D

var data : InventoryObject

var age : float = 0

const mat = preload("res://models/textures/chicken/meat/chickenmeat.tres")
const rotmat = preload("res://models/textures/chicken/meat/rottenchickenmeat.tres")
@onready var model = $model

func _ready():
	await get_tree().process_frame
	data = get_meta("obj").duplicate()
	if(data.customproperties.has("age")):
		age = data.customproperties["age"]
	if(age < 30):
		model.set_surface_override_material(0,mat)
	else:
		data.name = "Rotten meat"
		model.set_surface_override_material(0,rotmat)
	updatedata()

func updatedata():
	if(data == null):
		data = get_meta("obj").duplicate()
	data.customproperties["age"] = age
	if(age >= 30):
		data.customproperties["sellmod"] = "rotten meat"
	set_meta("obj", data)


func _on_agingtimer_timeout():
	if(age < 30):
		age += .5
		model.set_surface_override_material(0,mat)
	else:
		data.name = "Rotten meat"
		model.set_surface_override_material(0,rotmat)

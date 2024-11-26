extends RigidBody3D

var data : InventoryObject

var age : float = 0

@export var mat : Material
@export var rotmat : Material
const splatter = preload("res://prefabs/bloodsplatter.tscn")
@onready var model = $model
@onready var area = $Area3D
@onready var floorcheck = $floorcheck

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
		area.force_shapecast_update()
		floorcheck.force_shapecast_update()
		if(floorcheck.is_colliding() && !area.is_colliding()):
			var splat = splatter.instantiate()
			get_tree().current_scene.add_child(splat)
			splat.global_position = global_position
		age += .5
		model.set_surface_override_material(0,mat)
	else:
		data.name = "Rotten meat"
		model.set_surface_override_material(0,rotmat)

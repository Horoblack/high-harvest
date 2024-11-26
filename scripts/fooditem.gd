extends RigidBody3D
class_name fooditem

@onready var model = $model

var data : InventoryObject

var age : float = 0

@export var mats : Array[Material]
@export var rotmats : Array[Material]

@export var fillamount : float
@export var maxage : float = 30

func _ready():
	await get_tree().process_frame
	data = get_meta("obj").duplicate()
	if(data.customproperties.has("age")):
		age = data.customproperties["age"]
	if(age > maxage):
		data.name = "Spoiled food"
	updatedata()
	updatemats()

func trigger(pl : PlayerCam):
	pl.body.feed(fillamount)
	queue_free()

func updatedata():
	if(data == null):
		data = get_meta("obj").duplicate()
	data.customproperties["age"] = age
	if(age >= maxage && maxage != -1):
		data.customproperties["sellmod"] = "spoiled food"
	set_meta("obj", data)

func updatemats(rotten : bool = false):
	for n in mats.size():
		model.set_surface_override_material(n,mats[n] if !rotten else rotmats[n])

func _on_agingtimer_timeout():
	if(age < maxage):
		age += .5
	elif(maxage != -1):
		data.name = "Spoiled food"

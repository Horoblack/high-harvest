extends RigidBody3D
class_name shotgun

@onready var anim = $anim
@onready var model : MeshInstance3D = $Skeleton3D/shotgunmodel
const loadmat = preload("res://models/textures/shotgun/loaded.tres")
const emptymat = preload("res://models/textures/shotgun/empty.tres")

var data : InventoryObject

var loaded : bool = false
var open : bool = false

func _ready():
	await get_tree().process_frame
	data = get_meta("obj").duplicate()
	if(data.customproperties.has("loaded")):
		loaded = data.customproperties["loaded"]
	model.set_surface_override_material(1, loadmat if loaded else emptymat)
	set_meta("obj", data)

func reload():
	loaded = true
	updatedata()

func trigger(pl):
	if(!open):
		loaded = false
		updatedata()

func sectrigger(pl):
	if(anim.is_playing()):
		return
	open = !open
	anim.play("idle" if !open else "open")

func shoot():
	loaded = false
	updatedata()

func updatedata():
	if(data == null):
		data = get_meta("obj").duplicate()
	model.set_surface_override_material(1, loadmat if loaded else emptymat)
	data.customproperties["loaded"] = loaded
	set_meta("obj", data)

func info() -> String:
	return "Loaded" if loaded else "Not loaded"

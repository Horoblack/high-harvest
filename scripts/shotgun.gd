extends RigidBody3D
class_name shotgun

@onready var anim = $anim
@onready var bulletpos : Node3D = $bulletpos
@onready var model : MeshInstance3D = $Skeleton3D/shotgunmodel
const loadmat = preload("res://models/textures/shotgun/loaded.tres")
const emptymat = preload("res://models/textures/shotgun/empty.tres")
const shot = preload("res://prefabs/shotgunshot.tscn")

var data : InventoryObject

var loaded : bool = false
var open : bool = false

@export var bulletcount : int = 20

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

var aimpos
var pla : PlayerCam
func trigger(pl : PlayerCam):
	pla = pl
	if(!open && !anim.is_playing() && loaded):
		aimpos = pl.getplayeraim()
		anim.play("shoot")

func sectrigger(pl):
	if(anim.is_playing()):
		return
	open = !open
	anim.play("idle" if !open else "open")

func shoot():
	loaded = false
	var direction = (aimpos - bulletpos.global_position).normalized()
	var ignore : Array = []
	ignore.append(pla.body)
	for n in bulletcount:
		var sh = shot.instantiate()
		sh.ignore = ignore
		get_tree().current_scene.add_child(sh)
		sh.global_position = bulletpos.global_position
		var offset = Vector3(randf_range(-1,1),randf_range(-1,1),randf_range(-1,1)).normalized() * .2
		sh.look_at(sh.global_position + direction + offset)
		sh.execute()
	updatedata()

func candrop() -> bool:
	return !anim.is_playing()

func updatedata():
	if(data == null):
		data = get_meta("obj").duplicate()
	model.set_surface_override_material(1, loadmat if loaded else emptymat)
	data.customproperties["loaded"] = loaded
	set_meta("obj", data)

func info() -> String:
	return "Loaded" if loaded else "Not loaded"

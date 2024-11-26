extends Node3D

@export var fullmat : Material
@export var emptymat : Material
@onready var bottle = $bottle

const EMPTY = preload("res://sprites/itemicons/oilbottleempty.png")
const FULL = preload("res://sprites/itemicons/oilbottlefull.png")

var data : InventoryObject

var full : bool = true

func _ready():
	await get_tree().process_frame
	data = get_meta("obj").duplicate()
	if(data.customproperties.has("full")):
		full = data.customproperties["full"]
	updatemesh()
	set_meta("obj", data)

func updatemesh():
	bottle.set_surface_override_material(0,fullmat if full else emptymat)
	data.icon = FULL if full else EMPTY

func info():
	return "full" if full else "empty"

func _on_body_entered(body):
	if(body.has_method("filloil") && full):
		body.filloil()
		full = false
		data.customproperties["full"] = false
		updatemesh()
		set_meta("obj", data)

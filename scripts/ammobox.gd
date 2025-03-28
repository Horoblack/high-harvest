extends basepickup

@export var startammo : int = 10
var curammo : int = 0

var data : InventoryObject

func _ready():
	super()
	await get_tree().process_frame
	data = get_meta("obj").duplicate()
	if(data.customproperties.has("ammo")):
		curammo = data.customproperties["ammo"]
	else:
		curammo = startammo
	updatedata()

func _on_body_entered(body):
	if(body is shotgun && body.open && curammo > 0 && !body.loaded):
		body.reload()
		curammo -= 1
		updatedata()

func updatedata():
	if(data == null):
		data = get_meta("obj").duplicate()
	data.customproperties["ammo"] = curammo
	if(curammo < startammo):
		data.customproperties["sellmod"] = "used ammobox"
	set_meta("obj", data)

func info() -> String:
	return "%s/%s"%[curammo,startammo]

extends RigidBody3D

@onready var textstuff = $textstuff

@export var slots : Array[Control]

var plref
var data : InventoryObject
var hovered

func _ready():
	await get_tree().process_frame
	data = get_meta("obj").duplicate()
	set_meta("obj", data)
	
	for n in slots:
		n.mouse_entered.connect(func(): hovered = n)
		n.mouse_exited.connect(func(): hovered = null)

func trigger(pl):
	plref = pl
	if(pl.inventory.visible):
		return
	
	var on = !textstuff.visible
	pl.camfrozen = on
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED if !on else Input.MOUSE_MODE_VISIBLE)
	textstuff.visible = on
	if(!on):
		plref = null

func _input(event):
	if(plref && textstuff.visible && (event.is_action_pressed("inventory") || event.is_action_pressed("grab"))):
		plref.camfrozen = false
		textstuff.visible = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func updatedata():
	if(data == null):
		data = get_meta("obj").duplicate()
	set_meta("obj", data)

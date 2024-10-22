extends RigidBody3D
class_name bankstatement

@onready var textstuff = $textstuff
@onready var textbox = $textstuff/ColorRect/ColorRect/textbox

var plref

var data : InventoryObject

func _ready():
	await get_tree().process_frame
	data = get_meta("obj").duplicate()
	if(data.customproperties.has("text")):
		text(data.customproperties["text"])
	set_meta("obj", data)

func text(str : String):
	textbox.text = str
	updatedata()

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
	if(plref && textstuff.visible && (event.is_action_pressed("inventory") || event.is_action_pressed("grab") || event.is_action_pressed("hold"))):
		plref.camfrozen = false
		textstuff.visible = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func updatedata():
	if(data == null):
		data = get_meta("obj").duplicate()
	data.customproperties["text"] = textbox.text
	set_meta("obj", data)

#func info() -> String:
	#var ret : String = textbox.text
	#return ret

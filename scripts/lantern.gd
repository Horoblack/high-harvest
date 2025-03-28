extends basepickup

@export var onmat : Material
@export var offmat : Material

@onready var lantern = $lantern
@onready var light = $OmniLight3D
@onready var ring = $HingeJoint3D/ring

var on : bool = false

var fuel : float = 50

var data : InventoryObject

func _ready():
	super()
	await get_tree().process_frame
	data = get_meta("obj").duplicate()
	if(data.customproperties.has("on")):
		on = data.customproperties["on"]
	if(data.customproperties.has("fuel")):
		fuel = data.customproperties["fuel"]
	set_meta("obj", data)
	updatelight()

func _process(delta):
	if(on):
		if(fuel > 0):
			fuel -= delta *.1
		else:
			on = false
			updatelight()
	data.customproperties["fuel"] = fuel

func hold(pl):
	ring.freeze = pl != null
	ring.rotation = Vector3.ZERO
	ring.position = Vector3(0,0.05,0)

func trigger(pl):
	on = !on
	updatelight()

func filloil():
	fuel = 50

func info():
	return "%s/50" % str(fuel).pad_decimals(1)

func updatelight():
	lantern.set_surface_override_material(1,onmat if on else offmat)
	light.visible = on

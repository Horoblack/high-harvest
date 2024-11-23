extends RigidBody3D

@onready var deep = $deep
@onready var shallow = $shallow

var data : InventoryObject

var fill : int = 0

func _ready():
	await get_tree().process_frame
	data = get_meta("obj").duplicate()
	if(data.customproperties.has("fill")):
		fill = data.customproperties["fill"]
	if(fill > 0):
		shallow.visible = true
	if(fill == 6):
		deep.visible = true
	set_meta("obj", data)

func updatedata():
	if(data == null):
		data = get_meta("obj").duplicate()
	data.customproperties["fill"] = fill
	set_meta("obj", data)

func info():
	return "%s/6" % fill

func trigger(pl):
	if(fill == 6):
		pl.body.feed(40)
		shallow.visible = false
		deep.visible = false
		fill = 0

func _on_area_3d_body_entered(body : Node3D):
	if(body.is_in_group("diced") && fill <= 6):
		body.queue_free()
		fill += 1
		updatedata()
		shallow.visible = true
		if(fill == 6):
			deep.visible = true

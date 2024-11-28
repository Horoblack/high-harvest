extends RigidBody3D
class_name trashcan

@onready var bagmodel = $spreadbag
@onready var grabarea = $grabarea

var data : InventoryObject

var maxfill : int = 20
var fillamount : int = 0
var bag : bool = false

func _ready():
	grabarea.grabbed.connect(grabbag)
	await get_tree().process_frame
	data = get_meta("obj").duplicate()
	if(data.customproperties.has("bag")):
		bag = data.customproperties["bag"]
	if(data.customproperties.has("fillamount")):
		fillamount = data.customproperties["fillamount"]
	bagmodel.visible = bag
	set_meta("obj", data)

func _on_body_entered(body):
	if(body.has_meta("obj") && body.get_meta("obj").objaddress == "newtrashbag" && body != removed):
		body.queue_free()
		bag = true
		bagmodel.visible = true
		fillamount = 0
		updatedata()
	elif(body.has_meta("obj") && body.get_meta("obj").objaddress == "trashbag" && body != removed):
		bag = true
		bagmodel.visible = true
		fillamount = body.get_meta("obj").customproperties["fillamount"]
		body.queue_free()
		updatedata()
	elif(bag && fillamount < maxfill && body.get_meta("obj").objaddress != "trashbag"):
		if(body != self && body.has_meta("obj") && !body is trashcan):
			fillamount += 1
			body.queue_free()
			updatedata()

var removed
func grabbag(bod : Player):
	if(bag):
		if(fillamount == 0):
			var bb = Library.objs["newtrashbag"].instantiate()
			removed = bb
			get_tree().current_scene.add_child(bb)
			bb.global_position = global_position
			bb.global_rotation = global_rotation
			if(bod != null):
				bod.cam.grabobj(bb)
		else:
			var bb :Node3D = Library.objs["trashbag"].instantiate()
			removed = bb
			bb.set_meta("obj", bb.get_meta("obj").duplicate())
			bb.get_meta("obj").customproperties["fillamount"] = fillamount
			get_tree().current_scene.add_child(bb)
			bb.global_position = global_position
			bb.global_rotation = global_rotation
			if(bod != null):
				bod.cam.grabobj(bb)
		bag = false
		bagmodel.visible = false
		fillamount = 0
		updatedata()
		await get_tree().create_timer(.3).timeout
		removed = null

func updatedata():
	if(data == null):
		data = get_meta("obj").duplicate()
	data.customproperties["bag"] = bag
	data.customproperties["fillamount"] = fillamount
	if(bag):
		data.icon = load("res://sprites/itemicons/baggedtrashcan.png")
	else:
		data.icon = load("res://sprites/itemicons/trashcan.png")
	set_meta("obj", data)

func info() -> String:
	return "%s/%s" % [fillamount,maxfill]

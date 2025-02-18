extends basepickup

var data : InventoryObject

var drunk : bool = false
var crushed : bool = false

@onready var anim = $AnimationPlayer
const FRIEND = preload("res://prefabs/friend.tscn")
func _ready():
	super()
	await get_tree().process_frame
	data = get_meta("obj").duplicate()
	if(data.customproperties.has("drunk")):
		drunk = data.customproperties["drunk"]
	if(data.customproperties.has("crushed")):
		crushed = data.customproperties["crushed"]
	if(crushed):
		data.icon = preload("res://sprites/itemicons/crushedcan.png")
		anim.play("crushed")
	updatedata()

var pl : PlayerCam
func trigger(pla : PlayerCam):
	if(anim.is_playing()):
		return
	if(!drunk):
		pl = pla
		anim.play("drink")
	else:
		crushed = true
		anim.play("crushed")
		updatedata()

func drinkeffect():
	if(pl):
		pl.body.feed(10, false)
		drunk = true
		updatedata()
		if(randi_range(0,14) == 0):
			var fren = FRIEND.instantiate()
			get_tree().current_scene.add_child(fren)

func updatedata():
	if(data == null):
		data = get_meta("obj").duplicate()
	data.customproperties["drunk"] = drunk
	data.customproperties["crushed"] = crushed
	if(crushed):
		data.icon = preload("res://sprites/itemicons/crushedcan.png")
	set_meta("obj", data)

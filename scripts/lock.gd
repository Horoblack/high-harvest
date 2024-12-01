extends RigidBody3D

@onready var key: MeshInstance3D = $key
@onready var topshape: CollisionShape3D = $topshape
@onready var openshape: CollisionShape3D = $openshape

var data : InventoryObject

func _ready() -> void:
	await get_tree().process_frame
	data = get_meta("obj").duplicate()
	if(data.customproperties.has("unlocked") && data.customproperties["unlocked"]):
		unlock()

func unlock():
	remove_from_group("heavy")
	key.visible = true
	topshape.position = Vector3(0,.55,0)
	openshape.disabled = true
	data.customproperties["unlocked"] = true
	set_meta("obj",data)

func _on_body_entered(body: Node) -> void:
	if(body.has_meta("obj") && body.get_meta("obj").objaddress == "key"):
		body.queue_free()
		unlock()

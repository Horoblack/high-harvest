extends RigidBody3D
@onready var childshape: CollisionShape3D = $childshape
@onready var teenagershape: CollisionShape3D = $teenagershape
@onready var adultshape: CollisionShape3D = $adultshape
@onready var childmodel: Node3D = $child
@onready var teenagermodel: Node3D = $teenager
@onready var adultskeleton: Node3D = $adult
@onready var adultmodel: MeshInstance3D = $adult/Skeleton3D/pig
@onready var oldmodel: MeshInstance3D = $adult/Skeleton3D/oldpig

const BLOOD = preload("res://prefabs/bloodsplatter.tscn")
const BLOOD2 = preload("res://prefabs/bloodparticles.tscn")

var baseweight : float = .1
var weight : float = 0
var agestage : int = -1
var age : float = 0
var sexmale : bool = false
var data : InventoryObject

func _ready():
	await get_tree().process_frame
	data = get_meta("obj").duplicate()
	if(data.customproperties.has("age")):
		age = data.customproperties["age"]
	updatedata()
	agecheck()

func straighten():
	apply_central_impulse(Vector3.UP*3)
	#global_rotation.x = 0
	#global_rotation.z = 0
	var strength = 1
	match agestage:
		0: strength = .2
		1: strength = .5
		2: strength = 1
	apply_torque_impulse((global_basis.x * (-global_rotation.x))*strength)
	apply_torque_impulse((global_basis.z * (-global_rotation.z))*strength)

func murder():
	die()

func die():
	var meat = Library.objs["chickenmeat"].instantiate()
	get_tree().current_scene.add_child(meat)
	meat.global_position = global_position
	meat.global_rotation = global_rotation
	var splatter = BLOOD.instantiate()
	get_tree().current_scene.add_child(splatter)
	splatter.global_position = global_position
	splatter.global_rotation = global_rotation
	splatter.rotation_degrees.y = randi_range(-180,180)
	var bloo = BLOOD2.instantiate()
	get_tree().current_scene.add_child(bloo)
	bloo.global_position = global_position
	bloo.global_rotation = global_rotation
	bloo.rotation_degrees.y = randi_range(-180,180)
	queue_free() 

func _on_agetimer_timeout():
	age += .2
	updatedata()
	agecheck()

func agecheck():
	match agestage:
		0:
			childshape.disabled = false
			childmodel.visible = true
			teenagershape.disabled = true
			teenagermodel.visible = false
			adultshape.disabled = true
			adultskeleton.visible = false
			adultmodel.visible = false
			oldmodel.visible = false
		1:
			childshape.disabled = true
			childmodel.visible = false
			teenagershape.disabled = false
			teenagermodel.visible = true
			adultshape.disabled = true
			adultskeleton.visible = false
			adultmodel.visible = false
			oldmodel.visible = false
		2:
			childshape.disabled = true
			childmodel.visible = false
			teenagershape.disabled = true
			teenagermodel.visible = false
			adultshape.disabled = false
			adultskeleton.visible = true
			adultmodel.visible = true
			oldmodel.visible = false
		3:
			childshape.disabled = true
			childmodel.visible = false
			teenagershape.disabled = true
			teenagermodel.visible = false
			adultshape.disabled = false
			adultskeleton.visible = true
			adultmodel.visible = false
			oldmodel.visible = true

func _on_actiontimer_timeout():
	pass # Replace with function body.
	
func updatedata():
	if(data == null):
		data = get_meta("obj").duplicate()
	data.customproperties["age"] = age
	data.weight = baseweight + weight
	set_meta("obj", data)

func info() -> String:
	var ret : String = "Age: %s\n%s" % [age, "Male" if sexmale else "Female"]
	return ret

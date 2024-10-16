extends RigidBody3D

@onready var anim = $AnimationPlayer
@onready var actiontimer = $actiontimer
@onready var floorcast = $floorcast

@onready var chickmodel = $chickmodel
@onready var chickshape = $chickshape

@onready var midskeleton = $midskeleton
@onready var midshape = $midshape

@onready var oldskeleton = $oldskeleton
@onready var oldshape = $oldshape

@export var chickthumbnail : Texture2D
@export var midthumbnail : Texture2D
@export var oldthumbnail : Texture2D

var state : int = 0

var baseweight : float = .1
var weight : float = 0
var agestage : int = -1
var age : float = 0
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

func jump():
	#global_basis = global_basis.rotated(global_basis.y, randf_range(-PI,PI))
	if(global_basis.y.dot(Vector3.UP) < 0.1):
		straighten()
	else:
		var strength = .7
		match agestage:
			0: strength = .2
			1: strength = .5
			2: strength = .7
		apply_torque_impulse((global_basis.y * randf_range(-PI,PI))*strength)
		await get_tree().create_timer(.07).timeout
		apply_central_impulse((-global_basis.z*2) + (global_basis.y*2))

func jumptowards(node):
	if(global_basis.y.dot(Vector3.UP) < 0.1):
		straighten()
	else:
		var dir = global_position.direction_to(node.global_position)
		var perp = global_basis.z.cross(dir)
		var lr = -perp.dot(global_basis.y)
		apply_torque_impulse(global_basis.y * lr)
		apply_central_impulse((dir * 2) + (global_basis.y*2))

func agecheck():
	if(age < 10 && agestage != 0):
		agestage = 0
		baseweight = .1
		chickmodel.visible = true
		chickshape.disabled = false
		midskeleton.visible = false
		midshape.disabled = true
		oldskeleton.visible = false
		oldshape.disabled = true
		var shape : BoxShape3D = chickshape.shape.duplicate()
		shape.size *= 1.1
		floorcast.shape = shape
	elif(age >= 10 && age < 20 && agestage != 1):
		agestage = 1
		baseweight = .5
		oldskeleton.scale = Vector3.ONE * (weight+1)
		oldskeleton.visible = false
		oldshape.disabled = true
		midskeleton.visible = true
		midshape.disabled = false
		chickmodel.visible = false
		chickshape.disabled = true
		var shape : BoxShape3D = oldshape.shape.duplicate()
		shape.size *= 1.1
		floorcast.shape = shape
	elif(age >= 20 && age < 50 && agestage != 2):
		agestage = 2
		baseweight = 1
		oldskeleton.scale = Vector3.ONE * (weight+1)
		oldskeleton.visible = true
		oldshape.disabled = false
		midskeleton.visible = false
		midshape.disabled = true
		chickmodel.visible = false
		chickshape.disabled = true
		var shape : BoxShape3D = oldshape.shape.duplicate()
		shape.size *= 1.1
		floorcast.shape = shape
	elif(age >= 50):
		queue_free() #FUCKING DIE OF OLD AGE

func updatedata():
	if(data == null):
		data = get_meta("obj").duplicate()
	match agestage:
		0: data.icon = chickthumbnail
		1: data.icon = midthumbnail
		2: data.icon = oldthumbnail
	data.customproperties["age"] = age
	data.weight = baseweight + weight
	set_meta("obj", data)

func _on_animation_player_animation_finished(anim_name):
	if(anim_name == "peck"):
		anim.play("idle")

func _on_actiontimer_timeout():
	match(state):
		0:
			if(!floorcast.is_colliding()):
				state = 1
				anim.play("air")
			else:
				if(randi_range(0,5) == 0):
					anim.play("RESET")
					anim.play("peck")
					actiontimer.start(randf_range(.8,1))
				else:
					var ch = getclosestchicken()
					if(ch != null):
						if(global_position.distance_to(ch.global_position) < 2):
							ch.fertilize()
							actiontimer.start(randf_range(.5,1))
						elif(global_position.distance_to(ch.global_position) < 10):
							jumptowards(ch)
							actiontimer.start(randf_range(.4,.6))
					else:
						jump()
						actiontimer.start(randf_range(.5,1))
		1:
			if(floorcast.is_colliding()):
				state = 0
				anim.play("idle")

func _on_agetimer_timeout():
	age += .2
	agecheck()

func getclosestchicken():
	var ch
	for n in get_tree().get_nodes_in_group("chicken"):
		if((ch == null || global_position.distance_to(ch.global_position) > global_position.distance_to(n.global_position)) && n.fertility <= 1):
			ch = n
	return ch

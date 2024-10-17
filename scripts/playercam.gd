extends Camera3D
class_name PlayerCam

@onready var body : Player = get_parent()
@onready var cast = $RayCast3D
@onready var grabpos = $grabpos
@onready var heldpos = $heldpos
@onready var grabbedinfobox = $CanvasLayer/grabbedinfobox
@onready var grabbedinfolabel = $CanvasLayer/grabbedinfobox/MarginContainer/infolabel
@onready var heldinfobox = $CanvasLayer/heldinfobox
@onready var heldinfolabel = $CanvasLayer/heldinfobox/MarginContainer/infolabel

var CameraRotation = Vector2.ZERO
var MouseSensitivity = .002
var MouseEvent

var grabbeddistance : float = 2
var rotating : bool = false
var grabbed : RigidBody3D = null
var held = null
@onready var inventory : Inventory = $CanvasLayer/inventory

var camfrozen : bool = false

func _ready():
	var rot = body.transform.basis.get_euler()
	CameraLook(Vector2(-rot.y, -rot.x))
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	inventory.spawn.connect(dropobj)

func _input(event):
	if !camfrozen && event is InputEventMouseMotion:
		MouseEvent = event.relative * MouseSensitivity
		if(!rotating):
			CameraLook(MouseEvent)

	if(event.is_action_pressed("grab") && cast.is_colliding()):
		var obj = cast.get_collider()
		if(obj.has_method("grabtrigger")):
			obj.grabtrigger(body)
		if(obj is PhysicsBody3D):
			grabobj(obj)
	if event.is_action_released("grab"):
		grabbedinfobox.visible = false
		if(is_instance_valid(grabbed) && grabbed.has_method("endgrabtrigger")):
			grabbed.endgrabtrigger(body)
		letgoofgrabbed()
	if(event.is_action_pressed("hold")):
		holdobj()
	if(event.is_action_pressed("store")):
		if(grabbed != null):
			if(grabbed.has_meta("obj")):
				var objweight = grabbed.get_meta("obj").weight
				if(inventory.currentweight + objweight <= inventory.maxweight):
					if(grabbed.has_method("updatedata")):
						grabbed.updatedata()
					
					inventory.invlist.append(grabbed.get_meta("obj"))
					inventory.UpdateList()
					grabbed.queue_free()
					grabbed = null
		elif (held != null):
			if(held.has_meta("obj")):
				var objweight = held.get_meta("obj").weight
				if(inventory.currentweight + objweight <= inventory.maxweight):
					if(held.has_method("updatedata")):
						held.updatedata()
					inventory.invlist.append(held.get_meta("obj"))
					inventory.UpdateList()
					held.queue_free()
					held = null
	if(event.is_action_pressed("inventory")):
		inventory.showInv()
		body.frozen = true
		camfrozen = true
	if(event.is_action_pressed("leftclick")):
		if(grabbed && is_instance_valid(grabbed)):
			grabbed.apply_impulse(-global_basis.z * 20)
			letgoofgrabbed()
		elif(held != null && held.has_method("trigger") && !camfrozen):
			held.trigger(self)
	if event.is_action_pressed("rightclick") && grabbed:
		rotating = true
	if event.is_action_released("rightclick"):
		rotating = false
	if event.is_action_released("MWU"):
		grabbeddistance += .1
		grabbeddistance = clamp(grabbeddistance, 1,3)
	if event.is_action_released("MWD"):
		grabbeddistance -= .1
		grabbeddistance = clamp(grabbeddistance, 1,3)

func holdobj():
	if(grabbed != null && !grabbed.is_in_group("heavy") && held == null):
		heldinfobox.visible = true
		held = grabbed
		body.add_collision_exception_with(held)
		grabbed = null
		held.reparent(heldpos)
		if(held.has_method("hold")):
			held.hold(self)
		held.position = Vector3.ZERO
		held.rotation = Vector3.ZERO
		held.freeze = true
		for n in held.find_children("*", "CollisionShape3D", true, false):
			if(n.get_parent() is RigidBody3D):
				n.disabled = true
	elif(held != null):
		body.remove_collision_exception_with(held)
		held.reparent(get_tree().current_scene)
		if(cast.is_colliding()):
			held.global_position = cast.get_collision_point()
		else:
			held.global_position = global_position - global_basis.z
		if(held.has_method("hold")):
			held.hold(null)
		held.freeze = false
		for n in held.find_children("*", "CollisionShape3D", true, false):
			if(n.get_parent() is RigidBody3D):
				n.disabled = false
		held = null

func grabobj(obj):
	if(obj.is_in_group("pickup") && obj is RigidBody3D):
		if(obj.has_method("info")):
			grabbedinfobox.visible = true
		#holddistance = 2
		grabpos.global_rotation = obj.global_rotation
		grabbed = obj

func letgoofgrabbed():
	if(grabbed != null):
		grabpos.rotation = Vector3.ZERO
		rotating = false
		if(is_instance_valid(grabbed) && grabbed is RigidBody3D):
			grabbed.sleeping = false
		grabbed = null

func dropobj(ob : InventoryObject):
	var o = Library.objs[ob.objaddress].instantiate()
	o.set_meta("obj", ob)
	get_tree().current_scene.add_child(o)
	o.global_position = global_position - global_basis.z

func _physics_process(delta):
	grabpos.position.z = -grabbeddistance
	if(grabbed != null):
		if(global_position.distance_to(grabbed.global_position) > 4):
			letgoofgrabbed()
			return
		
		var force = ((grabpos.global_position - grabbed.global_position) * 100) - (grabbed.linear_velocity * 10)
		grabbed.apply_central_force(force)
		#heldpos.global_rotation = lerp(heldpos.global_rotation, heldobj.global_rotation, .2)
		
		var strt = Quaternion(grabpos.global_basis)
		var trgt = Quaternion(grabbed.global_basis)
		var sler2 = trgt.slerp(strt, .8 / clamp(grabbed.mass*grabbed.mass, 1, 100))
		grabbed.global_basis = Basis(sler2)
		var sler = strt.slerp(trgt, .2 / clamp(grabbed.mass*grabbed.mass, 1, 100))
		grabpos.global_basis = Basis(sler)
		
		#grabbed.global_rotation = grabpos.global_rotation
		
		if(grabbed && rotating):
			grabpos.rotate(basis.y,MouseEvent.x * clamp(2-(grabbed.mass*.1), 0.01,1))
			grabpos.rotate(basis.x,MouseEvent.y * clamp(2-(grabbed.mass*.1), 0.01,1))


func _process(delta):
	if(is_instance_valid(held) && held.has_method("info")):
		heldinfobox.visible = true
		heldinfolabel.text = held.info()
	else:
		heldinfobox.visible = false
	
	if(is_instance_valid(grabbed) && grabbed.has_method("info")):
		grabbedinfobox.visible = true
		grabbedinfolabel.text = grabbed.info()
	else:
		grabbedinfobox.visible = false
	
	var vel = body.velocity * body.global_transform.basis
	vel = Vector3(clamp(vel.y-vel.z if abs(vel.y-vel.z) > 2 else 0, -.1, .1), 0, clamp(vel.x if abs(vel.x) > 4 else 0, -.1, .1))

func CameraLook(Movement: Vector2):
	CameraRotation += Movement
	CameraRotation.y = clamp(CameraRotation.y, -1.5, 1.6)
	
	body.transform.basis = Basis()
	transform.basis = Basis()
	
	body.rotate_object_local(Vector3(0,1,0), -CameraRotation.x)
	rotate_object_local(Vector3(1,0,0), -CameraRotation.y)

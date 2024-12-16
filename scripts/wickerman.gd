extends RigidBody3D
class_name wickerman
@onready var raycast = $RayCast3D
@onready var chest = $lombar/chest
@onready var rightfoot = $r_hip/r_upperleg/r_knee/r_lowerleg/r_ankle/r_foot
@onready var leftfoot = $l_hip/l_upperleg/l_knee/l_lowerleg/l_ankle/l_foot
@onready var leftfootgrounded = $l_hip/l_upperleg/l_knee/l_lowerleg/l_ankle/l_foot/footgrounded
@onready var rightfootgrounded = $r_hip/r_upperleg/r_knee/r_lowerleg/r_ankle/r_foot/footgrounded


var rightfoottarget : Vector3
var leftfoottarget : Vector3
var leftforward : bool = true

@export var active : bool = false
@export var targetheight : float
@export var stepsize : float = .7
@export var limbs : Array[RigidBody3D]

var movementdirection : Vector3 = Vector3(0,0,1)

var player

var props

func _ready():
	player = get_tree().get_first_node_in_group("player")
	for n in limbs:
		leftfootgrounded.add_exception(n)
		rightfootgrounded.add_exception(n)
		raycast.add_exception(n)
		#for i in limbs:
			#n.add_collision_exception_with(i)
	
	await get_tree().process_frame
	props = get_meta("customproperties").duplicate()
	if(props.has("limbs")):
		for n in limbs.size():
			#limbs[n].position = props["limbs"][n][0]
			limbs[n].rotation = props["limbs"][n]
	else:
		props["limbs"] = []
		props["limbs"].resize(limbs.size())
	if(props.has("active")):
		active = props["active"]
	set_meta("customproperties",props)

func _physics_process(delta):
	if(props && props["limbs"]):
		props["active"] = active
		for n in limbs.size():
			#props["limbs"][n] = []
			#props["limbs"][n].resize(2)
			#props["limbs"][n][0] = limbs[n].position 
			props["limbs"][n] = limbs[n].rotation 
	if(!active || player.global_position.distance_to(global_position) > 10):
		return
	if(player.global_position.distance_to(global_position) < 2):
		var direction = (player.global_position - global_position).normalized()
		direction.y = .1
		player.velocity = direction * 40
		player.ragdoll(20)
		apply_impulse(direction * -20)
	movementdirection = global_position.direction_to(player.global_position)
	raycast.target_position = raycast.to_local(global_position + Vector3.DOWN * targetheight)
	if(raycast.is_colliding()):
		var point = raycast.get_collision_point()
		
		if(movementdirection.length() > .5):
			#left foot stuff
			var actualleft = point + (movementdirection if leftforward else Vector3.ZERO) + (Vector3.UP.cross(movementdirection)*.2)
			if(leftfoottarget.distance_to(actualleft) > stepsize || leftfoottarget == Vector3.ZERO):
				leftfoottarget = actualleft
				if(!leftforward):
					leftforward = true
			if(leftfoot.global_position.distance_to(leftfoottarget) > .1):
				leftfoot.apply_force((leftfoottarget-leftfoot.global_position) * 20)
			
			#right foot stuff
			var actualright = point + (movementdirection if !leftforward else Vector3.ZERO) + (movementdirection.cross(Vector3.UP)*.2)
			if(rightfoottarget.distance_to(actualright) > stepsize || rightfoottarget == Vector3.ZERO):
				rightfoottarget = actualright
				if(leftforward):
					leftforward = false
			if(rightfoot.global_position.distance_to(rightfoottarget) > .1):
				rightfoot.apply_force((rightfoottarget-rightfoot.global_position) * 20)
		
		#chest movement
		var targetchestposition = point + Vector3.UP * targetheight
		var strength = 100 + (100 if leftfootgrounded.is_colliding() else 0) + (100 if rightfootgrounded.is_colliding() else 0)
		chest.apply_force((targetchestposition-chest.global_position)*strength,chest.global_basis.y)
		chest.apply_force(movementdirection * 20)
		var targetbasis = chest.global_basis.looking_at(movementdirection)
		chest.apply_torque(Library.calc_angular_velocity(chest.global_basis,targetbasis))

func murder():
	active = false
	if(randi_range(0,1)==0):
		await get_tree().create_timer(5).timeout
		active = true

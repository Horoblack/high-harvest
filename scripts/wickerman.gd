extends RigidBody3D

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

func _ready():
	player = get_tree().get_first_node_in_group("player")
	for n in limbs:
		leftfootgrounded.add_exception(n)
		rightfootgrounded.add_exception(n)
		raycast.add_exception(n)

func _physics_process(delta):
	if(!active):
		return
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
		chest.apply_force(movementdirection * 10)
		var targetbasis = chest.global_basis.looking_at(movementdirection)
		chest.apply_torque(Library.calc_angular_velocity(chest.global_basis,targetbasis))

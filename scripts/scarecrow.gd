extends RigidBody3D

@onready var cast = $RayCast3D
@onready var joint = $SliderJoint3D

var anchored : bool = false

func _physics_process(delta):
	if(cast.is_colliding() && !anchored):
		var normal : Vector3 = cast.get_collision_normal()
		if(normal.dot(global_basis.y) > .7):
			joint.node_b = cast.get_collider().get_path()
			anchored = true
			joint.enabled = true
			gravity_scale = 0
	if(!cast.is_colliding() && anchored):
		joint.node_b = NodePath("")
		joint.enabled = false
		anchored = false
		gravity_scale = 1

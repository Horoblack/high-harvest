extends RigidBody3D

@onready var pinjoint: PinJoint3D = $PinJoint3D
@onready var cast: RayCast3D = $RayCast3D

func _physics_process(delta: float) -> void:
	if(cast.is_colliding()):
		testdepth()

func testdepth():
	var col1 : PhysicsBody3D = cast.get_collider()
	cast.add_exception(col1)
	cast.target_position = Vector3.FORWARD * .4
	cast.force_raycast_update()
	if(!cast.is_colliding()):
		cast.clear_exceptions()
		return
	var col2 = cast.get_collider()
	reparent(col2)
	freeze = true
	pinjoint.node_a = col1.get_path()
	pinjoint.node_b = col2.get_path()

func grabtrigger(bod):
	freeze = false
	reparent(get_tree().current_scene)
	pinjoint.node_a = NodePath("")
	pinjoint.node_b = NodePath("")

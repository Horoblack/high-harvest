extends basepickup

@onready var pinjoint: JoltPinJoint3D = $PinJoint3D
@onready var cast: RayCast3D = $RayCast3D

func _ready() -> void:
	cast.add_exception(get_tree().get_first_node_in_group("player"))

func _physics_process(delta: float) -> void:
	super(delta)
	if(cast.is_colliding()):
		testdepth()

func testdepth():
	var col1 : PhysicsBody3D = cast.get_collider()
	cast.add_exception(col1)
	cast.target_position = Vector3.FORWARD * .2
	cast.force_raycast_update()
	if(!cast.is_colliding()):
		cast.clear_exceptions()
		cast.add_exception(get_tree().get_first_node_in_group("player"))
		return
	var col2 = cast.get_collider()
	reparent(col2)
	freeze = true
	add_collision_exception_with(col1)
	add_collision_exception_with(col2)
	pinjoint.node_a = col1.get_path()
	pinjoint.node_b = col2.get_path()

func trigger(pl):
	if(pl.cast.is_colliding()):
		cast.enabled = true
		var point = pl.cast.get_collision_point()
		global_position = point
		pl.letgoofheld()


func holdtrigger(bod):
	cast.enabled = false

func grabtrigger(bod):
	for n in get_collision_exceptions():
		remove_collision_exception_with(n)
	freeze = false
	cast.target_position = Vector3.FORWARD * .1
	reparent(get_tree().current_scene)
	pinjoint.node_a = NodePath("")
	pinjoint.node_b = NodePath("")
	cast.enabled = false
	await get_tree().create_timer(.2).timeout
	cast.enabled = true

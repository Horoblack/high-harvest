extends basepickup

@onready var cast: RayCast3D = $RayCast3D

func _ready() -> void:
	cast.add_exception(get_tree().get_first_node_in_group("player"))

func _physics_process(delta: float) -> void:
	super(delta)
	if(cast.is_colliding() && freeze == false):
		testdepth()

func testdepth():
	if(get_tree().get_first_node_in_group("held") != null):
		cast.add_exception(get_tree().get_first_node_in_group("held"))
	var col1 : PhysicsBody3D = cast.get_collider()
	cast.add_exception(col1)
	reparent(col1)
	freeze = true
	add_collision_exception_with(col1)

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
	cast.clear_exceptions()
	freeze = false
	#cast.target_position = Vector3.FORWARD * .1
	var pos = global_position
	reparent(get_tree().current_scene)
	#bod.cam.grabobj(self)
	global_position = pos
	cast.enabled = false
	#print(global_position)
	await get_tree().create_timer(.2).timeout
	#print(global_position)
	cast.enabled = true

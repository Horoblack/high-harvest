extends basepickup
class_name veggiemandecal

@onready var cast: RayCast3D = $RayCast3D
@onready var colshape: CollisionShape3D = $CollisionShape3D

var anchor : Node3D

var colexceptions : Array

func _ready() -> void:
	cast.add_exception(get_tree().get_first_node_in_group("player"))

func _physics_process(delta: float) -> void:
	super(delta)
	if(cast.is_colliding() && freeze == false):
		testdepth()
	if anchor != null && !anchor.is_queued_for_deletion():
		global_position = anchor.global_position
		global_rotation = anchor.global_rotation
	elif freeze == true:
		freeze = false

func testdepth():
	if(get_tree().get_first_node_in_group("held") != null):
		cast.add_exception(get_tree().get_first_node_in_group("held"))
	var col1 : PhysicsBody3D = cast.get_collider()
	if(col1 is veggiemandecal):
		return
	cast.add_exception(col1)
	#reparent(col1)
	#anchor = Node3D.new()
	anchor = CollisionShape3D.new()
	anchor.shape = colshape.shape
	#get_tree().current_scene.add_child(anchor)
	col1.add_child(anchor)
	anchor.global_position = global_position
	anchor.global_rotation = global_rotation
	freeze = true
	add_collision_exception_with(col1)
	colexceptions.append(col1)

func trigger(pl):
	if(pl.cast.is_colliding()):
		cast.enabled = true
		var point = pl.cast.get_collision_point()
		global_position = point
		pl.letgoofheld()

func holdtrigger(bod):
	cast.enabled = false

func grabtrigger(bod):
	#var list = get_collision_exceptions().filter(func(a): return a != null)
	for n in colexceptions:
		remove_collision_exception_with(n)
	colexceptions.clear()
	cast.clear_exceptions()
	freeze = false
	#reparent(get_tree().current_scene)
	if anchor != null && !anchor.is_queued_for_deletion(): 
		anchor.queue_free()
	linear_velocity = Vector3.UP
	cast.enabled = false
	await get_tree().create_timer(.2).timeout
	cast.enabled = true

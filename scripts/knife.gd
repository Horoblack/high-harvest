extends RigidBody3D

@onready var cast = $RayCast3D

var anchored : bool = false

var p : PlayerCam

func trigger(pl : PlayerCam):
	p = pl
	use()

func grabtrigger(bod):
	reset()
	cast.enabled = false
	await get_tree().create_timer(.2).timeout
	cast.enabled = true

func use():
	if(p.cast.is_colliding() && p.cast.get_collider().has_meta("diced")):
		var col = p.cast.get_collider()
		var dicprefab = Library.objs[col.get_meta("diced")]
		for n in 3:
			var dic : Node3D = dicprefab.instantiate()
			get_tree().current_scene.add_child(dic)
			dic.global_position = col.global_position
			dic.apply_central_impulse(Vector3(randf_range(-2,2),1,randf_range(-2,2)).normalized()*.2)
		col.queue_free()

func _physics_process(delta):
	if(cast.is_colliding() && !anchored && linear_velocity.length() > 1):
		var normal : Vector3 = cast.get_collision_normal()
		if(normal.dot(-global_basis.y) > .7):
			var col = cast.get_collider()
			reparent(col)
			freeze = true
			anchored = true
			gravity_scale = 0
			global_position += global_basis.y * .1
			add_collision_exception_with(col)
			
	if(!cast.is_colliding() && anchored):
		reset()

func reset():
	reparent(get_tree().current_scene)
	freeze = false
	anchored = false
	gravity_scale = 1
	for n in get_collision_exceptions():
		remove_collision_exception_with(n)

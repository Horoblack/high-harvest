extends RigidBody3D

var pl : PlayerCam
@onready var anim = $AnimationPlayer

const hole = preload("res://prefabs/hole.tscn")

func hold(holder):
	pl = holder

func trigger(pl):
	if(pl.inventory.visible):
		return
	anim.play("dig")

func dig():
	if(pl.cast.is_colliding()):
		if(pl.cast.get_collider().is_in_group("diggable")):
			var point = pl.cast.get_collision_point()
			var space := get_world_3d().direct_space_state
			var query = PhysicsShapeQueryParameters3D.new()
			var sphere = SphereShape3D.new()
			sphere.radius = .1
			query.shape = sphere
			query.transform.origin = point
			var cols = space.intersect_shape(query)
			for n in cols:
				if(n.collider.has_method("uproot")):
					n.collider.uproot()
					return
			var hol = hole.instantiate()
			get_tree().current_scene.add_child(hol)
			hol.global_position = point

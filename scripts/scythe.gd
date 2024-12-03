extends basepickup

@onready var shapecast: ShapeCast3D = $shapecast
@onready var anim: AnimationPlayer = $AnimationPlayer

func trigger(pl):
	anim.play("reap")

func reap():
	shapecast.global_rotation = Vector3.ZERO
	shapecast.force_shapecast_update()
	for n in shapecast.get_collision_count():
		var un = shapecast.get_collider(n)
		if(un.has_method("uproot")):
			un.uproot()

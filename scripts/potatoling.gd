extends RigidBody3D
@onready var cast = $ShapeCast3D
@onready var anim = $AnimationPlayer

var randomdir : float = 0

var lifetime : float = 10

const POTATOCROP = preload("res://prefabs/crops/potatocrop.tscn")

func _physics_process(delta):
	if(cast.is_colliding()):
		var cur = global_basis.get_euler()
		var target = global_basis.from_euler(Vector3(0,cur.y+randomdir,0))
		angular_velocity = Library.calc_angular_velocity(global_basis,target)*20
		freeze = false
		#linear_velocity = -global_basis.z * 20
		apply_force(-global_basis.z * 20)#,Vector3(0,-.1,0))
		if(lifetime < 0):
			if(cast.get_collider().is_in_group("diggable")):
				anim.play("bury")
		else:
			lifetime -= delta

func bury():
	var crp = POTATOCROP.instantiate()
	get_tree().current_scene.add_child(crp)
	crp.global_position = cast.get_collision_point()
	queue_free()

func _on_timer_timeout():
	randomdir = randf_range(-.2,.2)

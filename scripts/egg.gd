extends RigidBody3D

var lastspeed

var fertile : bool = false

var hatchtime : float = 60

const chick = preload("res://prefabs/chicken.tscn")
const roost = preload("res://prefabs/rooster.tscn")
const decal = preload("res://prefabs/eggdecal.tscn")

func _physics_process(delta):
	lastspeed = linear_velocity.length()

func incubate(delta):
	if(fertile):
		hatchtime -= delta
		if(hatchtime <= 0 && hatchtime > -20):
			hatchtime = -20
			var ch = roost.instantiate() if randi_range(0,3)==0 else chick.instantiate()
			get_tree().current_scene.add_child(ch)
			ch.global_position = global_position
			queue_free()

var colnormal = Vector2.UP
func _integrate_forces( state ):
	if(state.get_contact_count() >= 1):  #this check is needed or it will throw errors 
		colnormal = state.get_contact_local_normal(0)

func _on_body_entered(body):
	var impactforce = lastspeed - linear_velocity.length()
	if(impactforce > 5):
		var dec = decal.instantiate()
		get_tree().current_scene.add_child(dec)
		dec.global_position = global_position
		dec.basis = align_up(dec.basis,colnormal)
		dec.scale = Vector3.ONE
		queue_free()

func align_up(node_basis, normal):
	var result = Basis()
	result.x = normal.cross(node_basis.z)
	result.y = normal
	result.z = node_basis.x.cross(normal)
	result = result.orthonormalized()
	
	return result

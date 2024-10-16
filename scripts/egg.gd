extends RigidBody3D

var lastspeed

var fertile : bool = false

var hatchtime : float = 60

const chick = preload("res://prefabs/chicken.tscn")
const roost = preload("res://prefabs/rooster.tscn")

func _physics_process(delta):
	lastspeed = linear_velocity.length()

func incubate(delta):
	if(fertile):
		hatchtime -= delta
		if(hatchtime <= 0 && hatchtime > -20):
			hatchtime = -20
			var ch = roost.instantiate() if randi_range(0,5)==0 else chick.instantiate()
			get_tree().current_scene.add_child(ch)
			ch.global_position = global_position
			queue_free()

func _on_body_entered(body):
	var impactforce = lastspeed - linear_velocity.length()
	if(impactforce > 7):
		queue_free()

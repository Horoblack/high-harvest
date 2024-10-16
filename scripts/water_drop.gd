extends RigidBody3D


func _on_body_entered(body):
	if(body.has_method("water")):
		body.water()
	queue_free()

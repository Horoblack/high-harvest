extends RigidBody3D

@export var fillamount : float

func trigger(pl : PlayerCam):
	pl.body.feed(fillamount)
	queue_free()

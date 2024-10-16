extends RigidBody3D

@export var lockangle : float
var locked : bool = true

func _physics_process(delta):
	if(locked && rotation_degrees.x!= lockangle):
		rotation_degrees.x = lockangle

func grabtrigger(_obj):
	locked = false

func endgrabtrigger(_obj):
	if(abs(rotation_degrees.x - lockangle) <= 3):
		locked = true

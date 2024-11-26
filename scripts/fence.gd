@tool
extends Path3D

@onready var multimesh = $MultiMeshInstance3D

@export var dist : float = 2
var dirty = false

func _process(delta):
	if(dirty):
		updatemesh()
		dirty = false

func updatemesh():
	var pathlength : float = curve.get_baked_length()
	var count = floor(pathlength / dist)
	var mesh : MultiMesh = multimesh.multimesh
	mesh.instance_count = count
	for i in count:
		var distance = dist * i
		var position = curve.sample_baked(distance,true)
		var forward = position.direction_to(curve.sample_baked(distance+.1,true))
		var up = curve.sample_baked_up_vector(distance,true)
		var x = forward.cross(up).normalized()
		var basis = Basis()
		basis.y = up
		basis.x = x
		basis.z = -forward
		var transform = Transform3D(basis,position)
		mesh.set_instance_transform(i,transform)


func _on_curve_changed():
	dirty = true

extends MultiMeshInstance3D

#var aabb : AABB = AABB(Vector3(-40.0,-2,-40.0), Vector3(80.0,4,80.0))

@export var list : Array
func _ready() -> void:
	multimesh.instance_count = list.size()
	for n in list.size():
		#var pos = Vector3.ZERO
		#while aabb.has_point(pos):
		#	pos = Vector3(randi_range(-size,size),0,randi_range(-size,size))
		#list.append(pos)
		multimesh.set_instance_transform(n, Transform3D(Basis(), list[n]))

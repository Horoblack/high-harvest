extends MultiMeshInstance3D

var aabb1 : AABB = AABB(Vector3(-40.0,-2,-40.0), Vector3(80.0,4,80.0))
var aabb2 : AABB = AABB(Vector3(40.0,-2,70.0), Vector3(50.0,4,80.0))

@export var list : Array
func _ready() -> void:
	multimesh.instance_count = list.size()
	for n in list.size():
		#var pos = Vector3.ZERO
		#while aabb1.has_point(pos) || aabb2.has_point(pos):
		#	pos = Vector3(randi_range(-320,320),0,randi_range(-400,400))
		#list.append(pos)
		multimesh.set_instance_transform(n, Transform3D(Basis(), list[n]))

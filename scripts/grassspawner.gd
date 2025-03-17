@tool

extends MultiMeshInstance3D

var aabb1 : AABB = AABB(Vector3(-40.0,-10,-40.0), Vector3(80.0,20,80.0))
var aabb2 : AABB = AABB(Vector3(40.0,-10,70.0), Vector3(60.0,20,80.0))

@export var list : Array
@export var spawnamount : int = 200
@export var size : Vector2 = Vector2(300,500)
func _ready() -> void:
	#print(aabb1.has_point(Vector3(3,0,12)))
	var amt
	#amt = list.size()
	amt = spawnamount
	multimesh.instance_count = amt
	#multimesh.buffer.clear()
	#multimesh.instance_count = 0
	
	#STILL GENERATING INSIDE THE AABB. FIX OR DIE
	for n in amt:
		var trans : Transform3D
		trans.origin = Vector3(randi_range(-size.x/2,size.x/2),0,randi_range(-size.y/2,size.y/2))
		while aabb1.has_point(global_position+trans.origin) || aabb2.has_point(global_position+trans.origin):
			trans.origin = Vector3(randi_range(-size.x/2,size.x/2),0,randi_range(-size.y/2,size.y/2))
		multimesh.set_instance_transform(n, trans)

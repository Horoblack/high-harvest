extends MeshInstance3D
class_name LineRenderer

@export var Enabled : bool = true

@export var Witdh : float = 0.5

var points : Array = [Vector3.ZERO,Vector3.ZERO]

func _ready():
	mesh = ImmediateMesh.new()

func SetPoints(pts):
	points = pts
	if(Enabled):
		updatemesh()

func updatemesh():
	mesh.clear_surfaces()
	
	if(points.size() < 2):
		return
	
	mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)
	for i in range(points.size()):
		var t = float(i)/ (points.size()-1.0)
		
		var t0 = i / points.size()
		var t1 = t
		
		mesh.surface_set_uv(Vector2(t0, 0))
		mesh.surface_add_vertex(to_local(points[i] + Vector3(Witdh,Witdh,Witdh)))
		mesh.surface_set_uv(Vector2(t1, 1))
		mesh.surface_add_vertex(to_local(points[i] - Vector3(Witdh,Witdh,Witdh)))
	mesh.surface_end()

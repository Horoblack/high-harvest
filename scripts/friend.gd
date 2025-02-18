extends MeshInstance3D

@export var colors : Array[Color]
@export var sprites : Array[Texture2D]

var direction : Vector3
var distance : float

var startdistance : float = 50

var mat : ShaderMaterial

var speed : float

func _ready():
	var pl = get_tree().get_first_node_in_group("player")
	direction = pl.basis.z
	reparent(pl)
	speed = randf_range(1,3)
	distance = startdistance
	mat = get_surface_override_material(0).duplicate()
	mat.set_shader_parameter("albedo", colors.pick_random())
	mat.set_shader_parameter("texture_albedo", sprites.pick_random())
	set_surface_override_material(0,mat)

func _process(delta):
	global_position = get_parent().global_position + (direction.normalized()*distance)
	global_position.y += 1.6
	global_rotation = Vector3.ZERO
	if(!InfoChecker.visibletoplayer(global_position)):
		distance -= delta * speed
		distance = clampf(distance,0,99)
		#transparency = (distance+ (startdistance/4))/startdistance
		#mat.set_shader_parameter("lod", (distance/startdistance)*15)
		if(distance < .1):
			get_parent().ragdoll()
			queue_free()

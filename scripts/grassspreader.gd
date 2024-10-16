extends Node3D

const GRASS = preload("res://prefabs/grass.tscn")

@export var circlesize : float = 10
@export var startsize : float = 100
@export var steps : int = 12
@export var stepper : int = 10

var innerradius : float 
var outerradius : float

var circles : Array[Array]

func _ready():
	outerradius = startsize + circlesize
	innerradius = startsize
	execute()
	execute()
	execute()
	%"day manager".day.connect(execute)

func execute():
	innerradius -= circlesize
	outerradius -= circlesize
	spawn()

func spawn():
	var arr = []
	for n in steps:
		var angle : float = float(360.0 / steps) * n
		for i in stepper:
			var pos = Vector3(randf_range(-2,2),0,1) * randf_range(innerradius, outerradius)
			pos = pos.rotated(Vector3.UP, deg_to_rad(angle))
			var g = GRASS.instantiate()
			add_child(g)
			g.global_position = pos
			arr.append(g)
	circles.append(arr)

func erase():
	if(circles.size() > 0):
		var circl = circles.pop_back()
		for n in circl:
			n.delete = true

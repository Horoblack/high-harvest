extends Node3D

@onready var decal = $decal
@export var lifetime : float = 10
var lftm

func _ready():
	lftm = lifetime

func _process(delta):
	lftm -= delta
	decal.modulate.a = lftm / (lifetime/2)
	if(lftm <= 0):
		queue_free()

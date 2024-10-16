extends Node3D

@onready var mesh = $MeshInstance3D

var delete : bool = false

func _ready():
	mesh.visible = false

func _process(delta):
	if(!InfoChecker.visibletoplayer(position)):
		if(!mesh.visible):
			mesh.visible = true
		if(delete):
			queue_free()

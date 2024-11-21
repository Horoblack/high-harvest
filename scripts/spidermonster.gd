extends Node3D

@onready var model: MeshInstance3D = $Skeleton3D/model
@onready var eyes = $Skeleton3D/eyes
@onready var anim = $AnimationPlayer
@onready var respawntimer = $respawntimer

var pl

var active : bool = true

var targettransparency

var distance = 30

func _ready():
	pl = get_tree().get_first_node_in_group("player")
	spawn()

func spawn():
	var randpos = pl.basis.z * distance
	global_position = pl.global_position + Vector3(randpos.x,0,randpos.z)
	active = true
	visible = true
	targettransparency = -2
	distance -= 5
	distance = clamp(distance,10,100)

func _process(delta):
	var dir = global_position.direction_to(pl.global_position)
	basis = basis.looking_at(-dir)
	global_position += dir * delta * 5
	if(active):
		if(InfoChecker.visibletoplayer(global_position)):
			active = false
	else:
		if(targettransparency <= 1):
			targettransparency += delta * 5
			model.transparency = targettransparency
			eyes.transparency = targettransparency
		else:
			visible = false
			if(respawntimer.is_stopped()):
				respawntimer.start()
